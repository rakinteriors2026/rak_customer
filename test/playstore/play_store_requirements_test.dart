import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rak_customer/app/app.dart';
import 'package:rak_customer/core/di/injection.dart';
import 'package:rak_customer/core/domain/entities/account.dart';
import 'package:rak_customer/core/storage/in_memory_session_storage.dart';
import 'package:rak_customer/core/theme/app_theme.dart';
import 'package:rak_customer/features/auth/presentation/cubit/session_cubit.dart';
import 'package:rak_customer/features/auth/presentation/pages/account_page.dart';

import '../helpers/memory_database.dart';
import 'elf_16kb.dart';

void main() {
  final root = Directory.current;
  final mainManifest = File('${root.path}/android/app/src/main/AndroidManifest.xml');
  final gradle = File('${root.path}/android/app/build.gradle.kts');
  final settings = File('${root.path}/android/settings.gradle.kts');
  final releaseManifest = File(
    '${root.path}/build/app/intermediates/merged_manifests/release/processReleaseManifest/AndroidManifest.xml',
  );
  final apk = File('${root.path}/build/app/outputs/flutter-apk/app-release.apk');

  group('Play Store policy surfaces', () {
    TestWidgetsFlutterBinding.ensureInitialized();

    Widget wrap(Widget child, {SessionCubit? sessionCubit}) {
      final page = MaterialApp(theme: AppTheme.light(), home: child);
      if (sessionCubit == null) return page;
      return BlocProvider.value(value: sessionCubit, child: page);
    }

    setUp(() async {
      if (sl.isRegistered<SessionCubit>()) {
        await sl.reset();
      }
      await configureDependencies(
        database: createMemoryDatabase(),
        sessionStorage: InMemorySessionStorage(),
      );
    });

    tearDown(() async {
      await sl.reset();
    });

    testWidgets('signed-in account can start Google Play account deletion', (
      tester,
    ) async {
      final sessionCubit = sl<SessionCubit>();
      sessionCubit.signedIn(
        const Account(
          id: 'acc',
          phone: '+919876540001',
          displayName: 'Anjali Menon',
          hasProjects: false,
        ),
      );
      await tester.binding.setSurfaceSize(const Size(390, 1800));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(wrap(const AccountPage(), sessionCubit: sessionCubit));
      await tester.pumpAndSettle();

      expect(find.text('Delete account'), findsOneWidget);
    });

    testWidgets('sign-in discloses terms and privacy before account creation', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(390, 1800));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final sessionCubit = sl<SessionCubit>();
      await sessionCubit.restore();
      await tester.pumpWidget(RakCustomerApp(sessionCubit: sessionCubit));
      await tester.pumpAndSettle();
      expect(find.textContaining('Privacy Policy'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });
  });

  group('Android packaging requirements', () {
    test('launcher activity is exported and not a debug-only stub', () {
      final xml = mainManifest.readAsStringSync();
      expect(xml, contains('android:name=".MainActivity"'));
      expect(xml, contains('android:exported="true"'));
      expect(xml, isNot(contains('android:debuggable="true"')));
      expect(xml, isNot(contains('QUERY_ALL_PACKAGES')));
      expect(xml, isNot(contains('MANAGE_EXTERNAL_STORAGE')));
      expect(xml, isNot(contains('REQUEST_INSTALL_PACKAGES')));
    });

    test('release manifest targets API 36 and is not debuggable', () {
      expect(
        releaseManifest.existsSync(),
        isTrue,
        reason: 'Build a release APK/AAB so the merged manifest exists.',
      );
      final xml = releaseManifest.readAsStringSync();
      expect(xml, contains('android:targetSdkVersion="36"'));
      expect(xml, isNot(contains('android:debuggable="true"')));
    });

    test('predictive back is enabled for Android 13+ Play review devices', () {
      final xml = mainManifest.readAsStringSync();
      expect(
        xml,
        contains('android:enableOnBackInvokedCallback="true"'),
        reason:
            'Play pre-launch / Android 15 devices use predictive back. '
            'Set enableOnBackInvokedCallback on the application or activity.',
      );
    });

    test('AGP is new enough for 16 KB packaging', () {
      final text = settings.readAsStringSync();
      final match = RegExp(
        r'id\("com.android.application"\) version "([^"]+)"',
      ).firstMatch(text);
      expect(match, isNotNull);
      final version = match!.group(1)!;
      final parts = version.split('.').map(int.parse).toList();
      final ok =
          parts[0] > 8 ||
          (parts[0] == 8 && parts[1] > 5) ||
          (parts[0] == 8 && parts[1] == 5 && parts[2] >= 1);
      expect(ok, isTrue, reason: 'Need AGP 8.5.1+, found $version');
    });

    test(
      'release R8 shrinking is on for Play DEX-optimization rules',
      () {
        final text = gradle.readAsStringSync();
        expect(
          text.contains('isMinifyEnabled = true') ||
              text.contains('minifyEnabled = true'),
          isTrue,
          reason:
              'From Feb 2027 Play expects ~25% R8 shrinking/obfuscation on published Android bytecode.',
        );
      },
      skip:
          'Upcoming Play Console threshold (Feb 2027). Enable isMinifyEnabled with Flutter ProGuard rules before then.',
    );

    test('native libs in the release APK are 16 KB aligned and 64-bit', () {
      expect(
        apk.existsSync(),
        isTrue,
        reason: 'Build app-release.apk before this check.',
      );
      final libs = inspectApkNativeLibs(apk);
      expect(libs, isNotEmpty, reason: 'Flutter APKs include libflutter.so');
      final misaligned = libs.where((lib) => !lib.aligned).toList();
      expect(
        misaligned,
        isEmpty,
        reason: misaligned
            .map((lib) => '${lib.path} align=${lib.maxLoadAlign}')
            .join('\n'),
      );
      expect(
        libs.any((lib) => lib.path.contains('arm64-v8a')),
        isTrue,
        reason: 'Play requires a 64-bit arm64-v8a native library.',
      );
    });
  });
}
