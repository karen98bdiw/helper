import 'dart:io';

import 'package:sqflite/sqflite.dart';

import 'alarm.dart';
import 'alarm.dart';

class Db {
  static final Db db = Db._internal();
  Database database;
  Db._internal();

  factory Db() {
    return db;
  }

  Future<bool> initDb() async {
    String dir = await getDatabasesPath();
    String path = dir + "/" + "alarms.db";

    bool ifExist = await databaseExists(path);

    if (!ifExist) {
      var file = await File(path).create();
      database = await openDatabase(file.path, onCreate: (db, i) async {
        print("database on create was called");
        await db.execute('''CREATE TABLE activity_types (
    activity_type_id    INTEGER NOT NULL ,
    date    TEXT(255, 0),
    PRIMARY KEY(activity_type_id AUTOINCREMENT)
)''');
      }, version: 1);
    } else {
      database = await openDatabase(path);
      print(path);
    }
  }

  Future<bool> insertAlarms(List<Alarm> alarms) async {
    alarms.forEach((element) async {
      var res = await database
          .insert("activity_types", {"date": "${element.time.toString()}"});
      print(res);
    });
  }

  Future<List<Alarm>> read() async {
    var res = await database.query("activity_types");
    List<Alarm> a = [];
    res.forEach((element) {
      a.add(Alarm(time: DateTime.parse(element["date"])));
    });

    return a;
  }
}
