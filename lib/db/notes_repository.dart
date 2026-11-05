import 'package:sqflite_common_ffi/sqflite_ffi.dart' show Database;

import 'models.dart';

class NotesRepository {
  final Database db;
  const NotesRepository(this.db);

  String get _now => DateTime.now().toIso8601String();

  Future<List<Note>> listNotes({String search = ''}) async {
    List<Map<String, Object?>> rows;
    if (search.trim().isNotEmpty) {
      final q = '%${search.trim()}%';
      rows = await db.query(
        'notes',
        where: 'title LIKE ? OR content LIKE ?',
        whereArgs: [q, q],
        orderBy: 'pinned DESC, updated_at DESC',
      );
    } else {
      rows = await db.query('notes', orderBy: 'pinned DESC, updated_at DESC');
    }
    return rows.map(Note.fromMap).toList();
  }

  Future<Note?> getNote(int id) async {
    final rows = await db.query('notes', where: 'id = ?', whereArgs: [id], limit: 1);
    return rows.isEmpty ? null : Note.fromMap(rows.first);
  }

  Future<int> createNote({required String title, String content = '', String? imageUri}) async {
    final ts = _now;
    return db.insert('notes', {
      'title': title,
      'content': content,
      'image_uri': imageUri,
      'pinned': 0,
      'created_at': ts,
      'updated_at': ts,
    });
  }

  Future<void> updateNote(int id, {required String title, required String content, String? imageUri}) async {
    await db.update(
      'notes',
      {'title': title, 'content': content, 'image_uri': imageUri, 'updated_at': _now},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> togglePin(int id) async {
    await db.rawUpdate('UPDATE notes SET pinned = CASE pinned WHEN 1 THEN 0 ELSE 1 END WHERE id = ?', [id]);
  }

  Future<void> deleteNote(int id) async {
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> countNotes() async {
    final r = await db.rawQuery('SELECT COUNT(*) AS c FROM notes');
    return (r.first.values.first as int?) ?? 0;
  }
}
