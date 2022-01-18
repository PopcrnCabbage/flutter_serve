import 'package:args/args.dart';
import 'controller.dart';

import 'modules/workers/file_worker.dart';
import 'modules/workers/pub_worker.dart';

void main(List<String> arguments) => chooseWhatYouWant(arguments);

void chooseWhatYouWant([List<String> arguments]) {
  print('ARGUMENTS: $arguments');

  final parser = ArgParser();
  parser.addFlag(LaunchFlags.files.onlyName(), callback: (isExist) {
    if (isExist) {
      fileWorker();
    }
  });
  parser.addFlag(LaunchFlags.pub.onlyName(), callback: (isExist) {
    if (isExist) {
      pubWorker();
    }
  });
  parser.parse(arguments);
}
