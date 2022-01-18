import 'dart:io';

import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart' as p;
import '../constants.dart';
import '../string_extension.dart';

bool containsPath(Map<Directory, StringBuffer> map, FileSystemEntity entity) {
  return map.keys.firstWhere((directory) => entity.path == directory.path) !=
      null;
}

void fileWorker() async {
  var assets = Directory('assets');
  final directories = <String, StringBuffer>{};
  final imagesExtension = StringBuffer('''
// GENERATED CODE - DO NOT MODIFY BY HAND
  import 'package:flutter/foundation.dart';
  
  import 'assets.fg.dart';

  
  extension Files on String {
  f(context, [List args = const []]) {
    if (!kIsWeb) {
      return 'assets/' + this;
    } else {
      return this;
    }
  }
}
  
  _Files assets = _Files();
class _Files{
  ''');

  Stream directoryParser = assets.list(recursive: true).asBroadcastStream()
    ..listen((FileSystemEntity element) {
      if (element is Directory && element.parent.path == assets.path) {
        imagesExtension.write(
            '${p.basename(element.path).toCamelCase().capitalizeFirst()} get ${p.basename(element.path).toCamelCase()} => ${p.basename(element.path).toCamelCase().capitalizeFirst()}();');
      }
      if (element is Directory) {
        if (!directories.containsKey(element)) {
          directories[element.path] = StringBuffer(
              'class ${p.basename(element.path).toCamelCase().capitalizeFirst()}{');
        }
        if (directories.containsKey(element.parent.path)) {
          (directories[element.parent.path]).write(
              '${p.basename(element.path).toCamelCase().capitalizeFirst()} get ${p.basename(element.path).toCamelCase()} => ${p.basename(element.path).toCamelCase().capitalizeFirst()}();');
        }
      }
      if (element is File && !element.path.contains('.DS_Store')) {
        var fileToWrite =
            'String get ${p.basename(element.path).replaceAll(".", "_").toCamelCase()} => "\${assetsPrefix}${element.uri.path.replaceFirst('assets/', '')}";';

        if (directories.containsKey(element.parent.path)) {
          directories[element.parent.path].write(fileToWrite);
        } else {
          imagesExtension.write(fileToWrite);
        }
      }
    });
  await directoryParser.last;
  imagesExtension.write('}');
  final genExtensions =
      Directory('lib/${ExportConstants.exportFolder}/assets');
  genExtensions.createSync(recursive: true);
  final generatedFilesExtension =
      File(genExtensions.path + '/assets.dart');
  if (!generatedFilesExtension.existsSync()) {
    generatedFilesExtension..createSync(recursive: true);
  }
  generatedFilesExtension
    ..writeAsStringSync(DartFormatter().format('${imagesExtension.toString()}'),
        mode: FileMode.write);
  imagesExtension.clear();
  directories.forEach((key, value) {
    value.write('}');
    imagesExtension.write(value);
  });

  genExtensions.createSync(recursive: true);
  final _generatedFilesExtension =
      File(genExtensions.path + '/assets.fg.dart');
  if (!_generatedFilesExtension.existsSync()) {
    _generatedFilesExtension..createSync(recursive: true);
  }
  _generatedFilesExtension
    ..writeAsStringSync(
        DartFormatter().format('''
        // GENERATED CODE - DO NOT MODIFY BY HAND
        import 'package:flutter/foundation.dart';
const assetsPrefix = kIsWeb ? "assets/" : "assets/";
        '''
            '${imagesExtension.toString()}'),
        mode: FileMode.write);
  print('Обработка файлов завершена');
}
