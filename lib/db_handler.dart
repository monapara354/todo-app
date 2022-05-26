import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo/notes.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

class Dbhelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    io.Directory? directory = await getExternalStorageDirectory();
    String path = join(directory!.path, 'notes.db');
    var db = await openDatabase(path, version: 1, onCreate: _oncreate);
    return db;
  }

  _oncreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE notes (id INTEGER PRIMARY KEY,title TEXT NOT NULL,description TEXT NOT NULL )');
  }

  Future<NotesModel> insert(NotesModel notesModel) async {
    var dbclint = await db;
    await dbclint!.insert('notes', notesModel.toMap());
    return notesModel;
  }

  Future<List<NotesModel>> getNoteList() async {
    var dbclint = await db;
    final List<Map<String, Object?>> queryR = await dbclint!.query('notes');
    return queryR.map((e) => NotesModel.fromMap(e)).toList();
  }

  Future<int> delete(int id) async {
    var dbclint = await db;
    return await dbclint!.delete('notes', where: 'id=?', whereArgs: [id]);
  }
}
