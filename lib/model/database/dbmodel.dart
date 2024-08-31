import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbModel with ChangeNotifier{
  late Database dbConn;

  Future<String> initDB() async {
    await _loadEveDB();
    await _initUserDB();
    return "DB Loaded";
  }

  Future<bool> _loadEveDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "eve.db");

    final exist = await databaseExists(path);

    if(exist) {
      log("db already exists");
    } else {
      log("creating a copy from assets");

      try {
        await Directory(dirname(path)).create(recursive:true);
      } catch(_){}

      ByteData data = await rootBundle.load(join("assets", "databases/eve.sqlite"));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush:true);

      log("db copied");
    }

    dbConn = await openDatabase(path);
    return true;
  }

  Future<bool> _initUserDB() async {
    //if (await dbConn.query('sqlite_master', where: 'name = ?', whereArgs:['tablename']) == []) {}
    return true;
  }

  Future<List> readInvMarketGroups({String? parentGroupID}) async {
    String query = "SELECT * FROM invMarketGroups";
    String? conditions;
    Map arguments = {
      'parentGroupID': parentGroupID
    };
    List queryArguments = [];

    arguments.forEach((key, value) {
      //TODO: find a way to clean up the if chain
      if (value != null) {
        if (value == "NULL") {
          if (conditions == null) {
            conditions = "WHERE $key IS NULL";
          }
          else {
            conditions = "$conditions AND $key IS NULL";
          }
        }
        else {
          if (conditions == null) {
            conditions = "WHERE $key = ?";
          }
          else {
            conditions = "$conditions AND $key = ?";
          }

          queryArguments.add(value);
        }
      }
    });

    query = "$query $conditions";

    return await dbConn.rawQuery(
      query,
      queryArguments,
    );
  }

  Future<List> readInvTypesGroup(String marketGroupID) async {
    return await dbConn.rawQuery(
      'SELECT * FROM invTypes WHERE marketGroupID = ?',
      [marketGroupID],
    );
  }

  Future<void> readInvTypes(int typeId) async {
    List<Map> result = await dbConn.rawQuery(
      'SELECT * FROM invTypes WHERE typeID = ?',
      [typeId],
    );

    log(result as String);
  }
}