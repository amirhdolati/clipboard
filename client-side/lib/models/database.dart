import 'dart:io' show Platform;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hive/hive.dart';

class DataBase {
  DataBase._privateConstructor();
  static final DataBase _database_instance = DataBase._privateConstructor();

  factory DataBase() {
    return _database_instance;
  }

  var _database_directory;
  var box;

  void save_ip(String ip) async {
    await box.put('ip', ip);
  }

  String get ip {
    return box.get('ip', defaultValue: "127.0.0.1");
  }

  void save_is_http(bool value) async {
    await box.put('is_http', value);
  }

  bool get is_http {
    return box.get('is_http', defaultValue: true);
  }

  Future<bool> load_database() async {
    try {
      if (Platform.isAndroid) {
        // going to get storage permission
        var permission_status = await Permission.storage.status;
        if (!permission_status.isGranted) {
          var permission_request = await Permission.storage.request();
          if (!permission_request.isGranted) return false;
        }
        final temp = await getApplicationDocumentsDirectory();
        _database_directory = temp.path;
      } else if (Platform.isWindows) {
        _database_directory = "./";
      } else {
        throw -1;
      }
      Hive.init(_database_directory);
      box = await Hive.openBox("db");
    } catch (_) {
      print("catch called!");
      return false;
    }
    return true;
  }
}
