import 'dart:io';

import 'package:path_provider/path_provider.dart';

abstract class StorageManager {
  Future store(String value);

  Future<String> read();
}


/// use this implementation for a mock test
class MockStorageManager implements StorageManager {

  String _value = '';

  @override
  Future<String> read() => Future.value(this._value);

  @override
  Future store(String value) {
    return Future(() {
      this._value = value;
    });
  }

}

/// store a file on local app storage folder
class LocalStorageManager implements StorageManager {
  final String filename;

  LocalStorageManager(this.filename);

  @override
  Future store(String value) async {
    await deleteFile(this.filename)
        .then((res) => getlocalFile(filename))
        .then((file) => file.writeAsString(value, flush: true));
  }

  @override
  Future<String> read() {
    return getlocalFile(filename).then((file) => file.readAsStringSync());
  }

  Future<File> getlocalFile(String filename) async {
    return getApplicationDocumentsDirectory().then((path) {
      String finalPath = path.path + '/' + filename;
      return File(finalPath).exists().then((bool) {
        if (bool) {
          return File(finalPath);
        } else {
          return File(finalPath).create().then((file) {
            return file;
          });
        }
      });
    });
  }

  Future<void> deleteFile(String fileName) async {
    try {
      File file = await getlocalFile(fileName);
      var exists = await file.exists();
      if (exists) {
//        await file.delete(recursive: true);
        await file.writeAsString('', flush: true);
      }
    } catch (e) {
      print("error while delete file : $e ");
    }
  }
}
