import 'dart:io';
import 'dart:typed_data';

/// LOAD segments must be aligned to 16 KB for Play's Android 15+ page-size rule.
const kPlayStorePageSize = 16384;

class NativeLibAlignment {
  const NativeLibAlignment({
    required this.path,
    required this.aligned,
    required this.maxLoadAlign,
  });

  final String path;
  final bool aligned;
  final int maxLoadAlign;
}

int _u16(Uint8List b, int o, bool le) {
  final v = ByteData.sublistView(b, o, o + 2);
  return le ? v.getUint16(0, Endian.little) : v.getUint16(0, Endian.big);
}

int _u32(Uint8List b, int o, bool le) {
  final v = ByteData.sublistView(b, o, o + 4);
  return le ? v.getUint32(0, Endian.little) : v.getUint32(0, Endian.big);
}

int _u64(Uint8List b, int o, bool le) {
  final v = ByteData.sublistView(b, o, o + 8);
  return le ? v.getUint64(0, Endian.little) : v.getUint64(0, Endian.big);
}

/// Max PT_LOAD `p_align` for ELF32 or ELF64, or null if not ELF.
int? maxPtLoadAlign(Uint8List bytes) {
  if (bytes.length < 52) return null;
  if (bytes[0] != 0x7f || bytes[1] != 0x45 || bytes[2] != 0x4c || bytes[3] != 0x46) {
    return null;
  }
  final is64 = bytes[4] == 2;
  final le = bytes[5] == 1;
  final phoff = is64 ? _u64(bytes, 32, le) : _u32(bytes, 28, le);
  final phentsize = is64 ? _u16(bytes, 54, le) : _u16(bytes, 42, le);
  final phnum = is64 ? _u16(bytes, 56, le) : _u16(bytes, 44, le);
  final alignOffset = is64 ? 48 : 28;
  var maxAlign = 0;
  for (var i = 0; i < phnum; i++) {
    final off = phoff + i * phentsize;
    if (off + phentsize > bytes.length) break;
    final type = _u32(bytes, off, le);
    if (type != 1) continue; // PT_LOAD
    final align = is64
        ? _u64(bytes, off + alignOffset, le)
        : _u32(bytes, off + alignOffset, le);
    if (align > maxAlign) maxAlign = align;
  }
  return maxAlign;
}

List<NativeLibAlignment> inspectApkNativeLibs(File apk) {
  final listed = Process.runSync('unzip', ['-Z1', apk.path]);
  if (listed.exitCode != 0) {
    throw StateError('unzip -Z1 failed: ${listed.stderr}');
  }
  final names = listed.stdout
      .toString()
      .split('\n')
      .where((name) => name.startsWith('lib/') && name.endsWith('.so'))
      .toList();
  final dir = Directory.systemTemp.createTempSync('rak_playstore_apk_');
  try {
    if (names.isNotEmpty) {
      final result = Process.runSync('unzip', [
        '-oq',
        apk.path,
        ...names,
        '-d',
        dir.path,
      ]);
      if (result.exitCode != 0) {
        throw StateError('unzip failed: ${result.stderr}');
      }
    }
    final libs = dir
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.so'))
        .toList();
    return [
      for (final lib in libs)
        () {
          final bytes = Uint8List.fromList(lib.readAsBytesSync());
          final align = maxPtLoadAlign(bytes) ?? 0;
          return NativeLibAlignment(
            path: lib.path.substring(dir.path.length + 1),
            aligned: align >= kPlayStorePageSize,
            maxLoadAlign: align,
          );
        }(),
    ];
  } finally {
    dir.deleteSync(recursive: true);
  }
}
