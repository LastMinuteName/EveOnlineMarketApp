import 'dart:developer';
import 'dart:io';
import 'package:eve_online_market_application/model/entity/invmarketgroups.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../entity/inv_types.dart';

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

  Future<List<InvMarketGroups>> readInvMarketGroups({int? parentGroupID}) async {
    String query = "SELECT * FROM invMarketGroups";
    String? conditions;
    Map arguments = {
      'parentGroupID': parentGroupID
    };
    List queryArguments = [];

    arguments.forEach((key, value) {
      //TODO: find a way to clean up the if chain
      if (value != null) {
        if (value == -1) {
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

    List<Map<String, dynamic>> queryResult = await dbConn.rawQuery(
      query,
      queryArguments,
    );

    List<InvMarketGroups> result = List<InvMarketGroups>.generate(queryResult.length, (i) {
      return InvMarketGroups(
          marketGroupID: queryResult[i]["marketGroupID"],
          parentGroupID: queryResult[i]["parentGroupID"],
          marketGroupName: queryResult[i]["marketGroupName"],
          description: queryResult[i]["description"],
          iconID: queryResult[i]["iconID"],
          hasTypes: queryResult[i]["hasTypes"]
      );
    });

    return result;
  }

  Future<List<InvTypes>> readInvTypesGroup(String marketGroupID) async {
    List<Map<String, dynamic>> queryResult = await dbConn.rawQuery(
      'SELECT * FROM invTypes WHERE marketGroupID = ?',
      [marketGroupID],
    );

    List<InvTypes> result = List<InvTypes>.generate(queryResult.length, (i) {
      return InvTypes(
          typeID: queryResult[i]["typeID"],
          groupID: queryResult[i]["groupID"],
          typeName: queryResult[i]["typeName"],
          description: queryResult[i]["description"],
          raceID: queryResult[i]["raceID"],
          published: queryResult[i]["published"],
          marketGroupID: queryResult[i]["marketGroupID"]
      );
    });

    return result;
  }

  Future<InvTypes> readInvTypesByTypeID(int typeId) async {
    List<Map<String, dynamic>> queryResult = await dbConn.rawQuery(
      'SELECT * FROM invTypes WHERE typeID = ?',
      [typeId],
    );

    InvTypes result = InvTypes(
      typeID: queryResult[0]["typeID"],
      groupID: queryResult[0]["groupID"],
      typeName: queryResult[0]["typeName"],
      description: queryResult[0]["description"],
      raceID: queryResult[0]["raceID"],
      published: queryResult[0]["published"],
      marketGroupID: queryResult[0]["marketGroupID"]
    );

    return result;
  }

  Future<List<InvTypes>> readInvTypesByTypeName(String typeName) async {
    List<Map<String, dynamic>> queryResult = await dbConn.rawQuery(
      '''
      SELECT * FROM invTypes 
      WHERE typeName LIKE ? AND published=1 AND marketGroupID NOT NULL 
      ORDER BY TypeName ASC''',
      ['%$typeName%'],
    );

    List<InvTypes> result = List<InvTypes>.generate(queryResult.length, (i) {
      return InvTypes(
          typeID: queryResult[i]["typeID"],
          groupID: queryResult[i]["groupID"],
          typeName: queryResult[i]["typeName"],
          description: queryResult[i]["description"],
          raceID: queryResult[i]["raceID"],
          published: queryResult[i]["published"],
          marketGroupID: queryResult[i]["marketGroupID"]
      );
    });

    return result;
  }
}