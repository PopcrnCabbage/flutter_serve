enum LaunchFlags { strings, files, db, uploadDb2Web, testDbLocally, pub }

extension LFC on LaunchFlags {
  String stringify() {
    return toString().replaceAll('.', '_');
  }

  String onlyName() {
    return toString().replaceFirst('$LaunchFlags.', '');
  }
}
