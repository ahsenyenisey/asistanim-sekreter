import 'dart:io' show Platform;

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

const dbFileName = 'asistanim.db';

/// Uygulama veritabanını açar ve şemayı (yoksa) oluşturur.
///
/// Mobilde (Android/iOS) standart `sqflite` kullanılır. Masaüstünde
/// (macOS/Linux/Windows veya `dart test`) `sqflite_common_ffi` kullanılır,
/// böylece aynı kod cihazsız da test edilebilir.
///
/// Bu dosya bilerek `path_provider` gibi Flutter eklentilerine bağımlı
/// değildir (sadece `sqflite_common_ffi` — saf Dart): böylece `dart test`
/// Flutter motoru olmadan doğrudan çalıştırılabilir. Gerçek dosya yolunun
/// çözülmesi `lib/db/app_database.dart`'ın sorumluluğundadır.
Future<Database> openAppDatabase({required String path}) async {
  DatabaseFactory factory;
  if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
    sqfliteFfiInit();
    factory = databaseFactoryFfi;
  } else {
    factory = databaseFactory;
  }

  return factory.openDatabase(
    path,
    options: OpenDatabaseOptions(
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) => _createSchema(db),
    ),
  );
}

Future<void> _createSchema(Database db) async {
  final batch = db.batch();
  batch.execute('''
    CREATE TABLE notes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      content TEXT NOT NULL DEFAULT '',
      image_uri TEXT,
      pinned INTEGER NOT NULL DEFAULT 0,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL
    )
  ''');
  batch.execute('''
    CREATE TABLE reminders (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      body TEXT NOT NULL DEFAULT '',
      due_at TEXT NOT NULL,
      notification_id TEXT,
      done INTEGER NOT NULL DEFAULT 0,
      created_at TEXT NOT NULL
    )
  ''');
  batch.execute('CREATE INDEX idx_reminders_due ON reminders(due_at)');
  batch.execute('''
    CREATE TABLE processes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      description TEXT NOT NULL DEFAULT '',
      status TEXT NOT NULL DEFAULT 'active',
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL
    )
  ''');
  batch.execute('''
    CREATE TABLE process_steps (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      process_id INTEGER NOT NULL REFERENCES processes(id) ON DELETE CASCADE,
      title TEXT NOT NULL,
      position INTEGER NOT NULL,
      done INTEGER NOT NULL DEFAULT 0
    )
  ''');
  batch.execute('CREATE INDEX idx_steps_process ON process_steps(process_id, position)');
  batch.execute('''
    CREATE TABLE chat_messages (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      role TEXT NOT NULL,
      content TEXT NOT NULL,
      created_at TEXT NOT NULL
    )
  ''');
  batch.execute('''
    CREATE TABLE settings (
      key TEXT PRIMARY KEY NOT NULL,
      value TEXT NOT NULL
    )
  ''');
  await batch.commit(noResult: true);
}
