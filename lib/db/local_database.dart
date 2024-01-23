// ignore_for_file: non_constant_identifier_names

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Database? _database;
List WholeDataList = [];

class LocalDatabase {
  Future get database async {
    if (_database != null) return _database;
    _database = await _initializeDB('Local.db');
    return _database;
  }

  Future _initializeDB(String filepath) async {                     
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, filepath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE Localdata(id INTEGER PRIMARY KEY,
name TEXT,
place TEXT,
mail TEXT,
phone TEXT,
image TEXT
)
''');
  }

  Future addData(
      {String? name,
      String? phone,
      String? place,
      String? mail,                     
      String? image}) async {
    final db = await database;
    final row = {
      'name': name,
      'place': place,
      'mail': mail,
      'phone': phone,
      'image': image
    };
    await db.insert("Localdata", row);
    return 'added';
  }

  Future readData() async {
    final db = await database;
    final alldata = await db!.query("LocalData");
    WholeDataList = alldata;
    return WholeDataList;
  }

  Future deleteData({id}) async {
    final db = await database;
    await db!.delete("Localdata", where: 'id=?', whereArgs: [id]);
    return 'succefully deleted';
  }

  Future updateDB(
      {int? id,
      String? name,
      String? phone,
      String? place,
      String? mail,
      String? image}) async {
    final db = await database;
    int rowsUpdated = await db!.update(
      "Localdata",
      {
        'name': name,
        'place': place,
        'phone': phone,
        'image': image,
        'mail': mail
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    return rowsUpdated;
  }
}