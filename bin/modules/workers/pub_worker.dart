import 'dart:io';

import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

void pubWorker() {
  const defaultPath = ['flutter', 'assets'];
  final editor = loadConfigFile('pubspec.yaml');

  var assets = Directory('assets');
  try {
    editor.remove(defaultPath);
  } catch (_) {}
  var patches = assets
      .listSync(recursive: true)
      .whereType<Directory>()
      .map<String>((directory) => directory.path + '/');
  editor.update(defaultPath,
      wrapAsYamlNode(patches.toList(), collectionStyle: CollectionStyle.BLOCK));

  writeConfigFile('pubspec.yaml', editor);
}

YamlEditor loadConfigFile(String path) {
  final file = File(path);
  final yamlString = file.readAsStringSync();
  return YamlEditor(yamlString);
}

void writeConfigFile(String path, YamlEditor editor) {
  File(path).writeAsStringSync(editor.toString());
}
