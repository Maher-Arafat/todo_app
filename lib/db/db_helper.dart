// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../models/tsk.dart';

class DBHelper {
  static Database? _db;
  static const int _vrsion = 1;
  static const String _tableNme = 'Tasks';
  static Future<void> initDB() async {
    if (_db != null) {
      debugPrint('Not null db');
      return;
    } else {
      try {
        String path = await getDatabasesPath() + 'task.db';
        debugPrint('in DB path');
        _db = await openDatabase(path, version: _vrsion,
            onCreate: (Database db, int version) async {
          debugPrint('creating a new');
          // When creating the db, create the table
          await db.execute('CREATE TABLE $_tableNme('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'title STRING, note TEXT, date STRING, '
              'startTime INTEGER, endTime INTEGER, '
              'remind INTEGER, repeat STRING, '
              'color INTEGER, '
              'isCompleted INTEGER)');
        });
        print('DataBase created');
      } catch (x) {
        print(x);
      }
    }
  }

  static Future<int> insert(Task? tsk) async {
    print('Insert Func Called');
    return await _db!.insert(_tableNme, tsk!.toJson());
  }

  static Future<int> delete(Task tsk) async {
    print('Delete Func Called');
    return await _db!.delete(_tableNme, where: 'id = ?', whereArgs: [tsk.id]);
  }

  static Future<int> deleteAll() async {
    print('Delete All Func Called');
    return await _db!.delete(_tableNme);
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print('Query Func Called');
    return await _db!.query(_tableNme);
  }

  static Future<int> update(int id) async {
    print('Update Func Called');
    return await _db!.rawUpdate('''
    UPDATE Tasks
    SET isCompleted = ?
    WHERE id = ?
      ''', [1, id]);
  }
}
