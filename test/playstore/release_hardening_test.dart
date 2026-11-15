import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// F-06 — Android release hardening. These are static file checks so they run
/// without an Android SDK / release build. Runtime behaviour (the release build
/// actually failing without key.properties, R8 keeping the right classes) must
/// be verified on a real build — see README.
void main() {
  final root = Directory.current.path;
  final gradle = File('$root/android/app/build.gradle.kts');
  final manifest = File('$root/android/app/src/main/AndroidManifest.xml');
  final dataRules =
      File('$root/android/app/src/main/res/xml/data_extraction_rules.xml');
  final fullBackup =
      File('$root/android/app/src/main/res/xml/full_backup_content.xml');
  final proguard = File('$root/android/app/proguard-rules.pro');
  final androidIgnore = File('$root/android/.gitignore');
  final verifyScript = File('$root/tool/verify_release.sh');

  group('release signing (F-06)', () {
    test('release build type does not fall back to the debug keystore', () {
      final text = gradle.readAsStringSync();
      expect(
        text.contains('signingConfigs.getByName("debug")'),
        isFalse,
        reason: 'Release must not be signed with the debug keystore.',
      );
    });

    test('a real release signing config reads from key.properties', () {
      final text = gradle.readAsStringSync();
      expect(text.contains('key.properties'), isTrue);
      expect(text.contains('create("release")'), isTrue);
      expect(
        text.contains('signingConfig = signingConfigs.getByName("release")') ||
            text.contains('signingConfigs.getByName("release")'),
        isTrue,
      );
    });

    test('missing key.properties fails the release build with a message', () {
      final text = gradle.readAsStringSync();
      expect(text.contains('GradleException'), isTrue);
      expect(text.toLowerCase().contains('key.properties'), isTrue);
    });
  });

  group('R8 shrinking (F-06)', () {
    test('release enables minify and resource shrinking with proguard rules',
        () {
      final text = gradle.readAsStringSync();
      expect(text.contains('isMinifyEnabled = true'), isTrue);
      expect(text.contains('isShrinkResources = true'), isTrue);
      expect(text.contains('proguard-rules.pro'), isTrue);
    });

    test('proguard rules keep Flutter, drift/sqlite and AR/camera plugins', () {
      expect(proguard.existsSync(), isTrue);
      final text = proguard.readAsStringSync();
      expect(text.contains('io.flutter'), isTrue);
      expect(text.toLowerCase().contains('sqlite'), isTrue);
      expect(
        text.contains('com.google.ar') ||
            text.toLowerCase().contains('arcore') ||
            text.toLowerCase().contains('filament'),
        isTrue,
      );
    });
  });

  group('backup protection (F-06)', () {
    test('allowBackup is disabled and backup rules are wired in', () {
      final xml = manifest.readAsStringSync();
      expect(xml.contains('android:allowBackup="false"'), isTrue);
      expect(xml.contains('android:dataExtractionRules='), isTrue);
      expect(xml.contains('android:fullBackupContent='), isTrue);
    });

    test('backup rule files exclude the database and secure storage', () {
      expect(dataRules.existsSync(), isTrue);
      expect(fullBackup.existsSync(), isTrue);
      final dr = dataRules.readAsStringSync();
      final fb = fullBackup.readAsStringSync();
      for (final text in [dr, fb]) {
        expect(text.contains('domain="database"'), isTrue);
        expect(text.contains('domain="sharedpref"'), isTrue);
      }
    });
  });

  group('secret hygiene (F-06)', () {
    test('key.properties and keystores are gitignored', () {
      final text = androidIgnore.readAsStringSync();
      expect(text.contains('key.properties'), isTrue);
      expect(
        text.contains('*.keystore') || text.contains('*.jks'),
        isTrue,
      );
    });

    test('a CI verify script exists and checks signing + allowBackup', () {
      expect(verifyScript.existsSync(), isTrue);
      final text = verifyScript.readAsStringSync();
      expect(text.toLowerCase().contains('allowbackup'), isTrue);
      expect(
        text.contains('apksigner') || text.toLowerCase().contains('debug'),
        isTrue,
      );
    });
  });
}
