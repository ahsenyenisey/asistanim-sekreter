import 'dart:io' show Platform;

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' show getDatabasesPath;
import 'package:sqflite_common_ffi/sqflite_ffi.dart' show Database, inMemoryDatabasePath;

import 'database.dart';

/// Uygulama genelinde paylaşılan tek SQLite bağlantısı.
/// main() içinde `AppDatabase.open()` çağrıldıktan sonra `AppDatabase.instance`
/// tüm ekranlarca kullanılabilir.
class AppDatabase {
  AppDatabase._();
  static Database? _instance;

  static Database get instance {
    final db = _instance;
    if (db == null) {
      throw StateError('AppDatabase henüz açılmadı. Önce AppDatabase.open() çağrılmalı.');
    }
    return db;
  }

  static Future<void> open({String? pathOverride}) async {
    final path = pathOverride ?? await _resolveDefaultPath();
    _instance = await openAppDatabase(path: path);
  }

  /// Testlerde her çağrıda izole, bellek içi bir veritabanı açmak için.
  static Future<void> openInMemory() => open(pathOverride: inMemoryDatabasePath);

  static Future<String> _resolveDefaultPath() async {
    if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
      final dir = await getApplicationSupportDirectory();
      return p.join(dir.path, dbFileName);
    }
    return p.join(await getDatabasesPath(), dbFileName);
  }
}
