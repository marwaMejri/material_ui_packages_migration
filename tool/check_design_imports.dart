// Lists which dependencies still import the SDK's Material or Cupertino,
// and which ones already use material_UI or Cupertino_UI.
// Run from the root of a Flutter project, after `flutter pub get`:
//   dart run tool/check_design_imports.Dart
import 'dart:convert';
import 'dart:io';

const Set<String> skipped = <String>{
  'flutter',
  'flutter_test',
  'flutter_localizations',
  'flutter_web_plugins',
  'flutter_driver',
  'integration_test',
  'sky_engine',
  'material_ui',
  'cupertino_ui',
};

void main() {
  final File config = File('.dart_tool/package_config.json');
  if (!config.existsSync()) {
    stderr.writeln(
      'No .dart_tool/package_config.json. Run `flutter pub get` first.',
    );
    exit(1);
  }
  final Map<String, dynamic> json =
      jsonDecode(config.readAsStringSync()) as Map<String, dynamic>;
  final RegExp sdkImport = RegExp(
    r'package:flutter/(material|cupertino)\.dart',
  );
  final RegExp newImport = RegExp(r'package:(material_ui|cupertino_ui)/');
  final RegExp themeRead = RegExp(r'Theme\.of\(');

  final List<String> oldOnes = <String>[];
  final List<String> newOnes = <String>[];

  for (final dynamic entry in json['packages'] as List<dynamic>) {
    final Map<String, dynamic> package = entry as Map<String, dynamic>;
    final String name = package['name'] as String;
    final String rootUri = package['rootUri'] as String;
    if (skipped.contains(name) || rootUri == '../') {
      continue;
    }
    final Uri root = config.absolute.uri.resolve(
      rootUri.endsWith('/') ? rootUri : '$rootUri/',
    );
    final Directory lib = Directory.fromUri(root.resolve('lib/'));
    if (!lib.existsSync()) {
      continue;
    }

    int oldFiles = 0;
    int newFiles = 0;
    int themeReads = 0;
    for (final FileSystemEntity file in lib.listSync(recursive: true)) {
      if (file is! File || !file.path.endsWith('.dart')) {
        continue;
      }
      final String source = file.readAsStringSync();
      if (sdkImport.hasMatch(source)) {
        oldFiles++;
        themeReads += themeRead.allMatches(source).length;
      }
      if (newImport.hasMatch(source)) {
        newFiles++;
      }
    }

    final String version = root.pathSegments
        .lastWhere((String s) => s.isNotEmpty)
        .replaceFirst('$name-', '');
    if (oldFiles > 0) {
      oldOnes.add(
        '  $name $version: $oldFiles '
        '${oldFiles == 1 ? 'file imports' : 'files import'} the SDK Material, '
        '$themeReads ${themeReads == 1 ? 'read' : 'reads'} of Theme.of in them',
      );
    } else if (newFiles > 0) {
      newOnes.add(
        '  $name $version: $newFiles '
        '${newFiles == 1 ? 'file uses' : 'files use'} material_ui',
      );
    }
  }

  stdout.writeln('Still on the SDK Material (${oldOnes.length}):');
  oldOnes.forEach(stdout.writeln);
  stdout.writeln('Already on material_ui (${newOnes.length}):');
  newOnes.forEach(stdout.writeln);
}
