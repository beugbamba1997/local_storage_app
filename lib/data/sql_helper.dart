import 'dart:ffi';
import 'dart:io';

import 'package:local_storage_app/model/note.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlHelper {
  final String colId = 'id';
  final String colName = 'name';
  final String colDate = 'date';
  final String colNote = 'notes';
  final String colPosition = 'position';
  final String tableNote = 'notes';

  static SqlHelper _singleton = SqlHelper._internal();

  static Database? _db ;
  
  final int version = 1;
  SqlHelper._internal();

  factory SqlHelper() {
    return _singleton;
  }

  Future init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String dbPath = join(dir.path, 'notes.db');
    _db =
        await openDatabase(dbPath, version: version, onCreate: _createDB);
   
  }

  Future _createDB(Database db, int version) async {
    String query =
        'CREATE TABLE $tableNote ($colId INTEGER PRIMARY KEY autoincrement, $colName TEXT, $colDate TEXT, $colNote TEXT, $colPosition INTEGER)';
    await db.execute(query);
  }

  Future<List<Note>> getNotes() async {
    if (_db == null) await init();
    List<Map<String, dynamic>> notesList =
        await _db!.query(tableNote, orderBy: colPosition);
    List<Note> notes = [];
    for (var element in notesList) {
      notes.add(Note.fromMap(element));
    }
    return notes;
  }

  Future<int> insertNote(Note note) async {
       int result = await _db!.insert(tableNote, note.toMap());
    return result;
  }

  Future<int> updateNote(Note note) async {
    int result = await _db!.update(tableNote, note.toMap(),
        where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteeNote(Note note) async {
    int result =
        await _db!.delete(tableNote, where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  Future<int> findPosition() async {
    final String sql = 'select max($colPosition) from $tableNote';
    List<Map> queryResul = await _db!.rawQuery(sql);
    int? position = queryResul.first.values.first;
    position = (position == null) ? 0 : ++position;
    return position;
  }

  Future updatePosition(bool increment, int start, int end) async {
    String sql;
    if (increment) {
      sql =
          'update $tableNote set $colPosition = $colPosition + 1 where $colPosition >= $start and $colPosition <= $end';
    } else {
      sql =
          'update $tableNote set $colPosition = $colPosition - 1 where $colPosition >= $start and $colPosition <= $end';
    }

    await _db!.rawUpdate(sql);
  }
}
