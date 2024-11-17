import 'dart:io';
import 'package:eve_online_market_application/model/entity/inv_market_groups.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../entity/inv_types.dart';
import '../entity/map_region.dart';

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

    if(!exist) {
      /// If the database instance does not exist on the system then create
      /// one on the system from the applications assets
      try {
        await Directory(dirname(path)).create(recursive:true);
      } catch(_){}

      ByteData data = await rootBundle.load(join("assets", "databases/eve.sqlite"));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush:true);
    }

    dbConn = await openDatabase(path);
    return true;
  }

  Future<bool> _initUserDB() async {
    //if (await dbConn.query('sqlite_master', where: 'name = ?', whereArgs:['tablename']) == []) {}
    return true;
  }

  /// Retrieves the direct children of a parentGroupID entry from the invMarketGroups table
  Future<List<InvMarketGroups>> readInvMarketGroups({int? parentGroupID}) async {
    String query = "SELECT * FROM invMarketGroups";
    String? conditions;
    Map arguments = {
      'parentGroupID': parentGroupID
    };
    List queryArguments = [];

    arguments.forEach((key, value) {
      //TODO: clean up the if chain
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

  /// queries database for list of invTypes (eve online item) via marketGroupID
  /// the list that is returned will contain InvTypes that all possess the same marketGroupID
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

  /// queries database for a invType (eve online item) via typeID
  /// returns a null if nothing was found (an entry for the typeID does not exist)
  Future<InvTypes?> readInvTypesByTypeID(int typeID) async {
    List<Map<String, dynamic>> queryResult = await dbConn.rawQuery(
      'SELECT * FROM invTypes WHERE typeID = ?',
      [typeID],
    );

    if (queryResult.isEmpty) return null;

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

  /// queries database for list of invTypes (eve online item) via String typeName
  /// query will return invTypes that are most similar to the typeName used
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

  Future<Map<int, MapRegion>> readMapRegions({int? regionID}) async {
    List<Map<String, dynamic>> queryResult = regionID != null ?
    await dbConn.rawQuery(
      "SELECT * FROM mapRegions WHERE regionID = ?",
      [regionID],
    ) :
    await dbConn.rawQuery(
      "SELECT * FROM mapRegions",
    );

    Map<int, MapRegion> regionMap = {};

    for (Map<String, dynamic> element in queryResult) {
      regionMap[element["regionID"]] = MapRegion(
        regionID: element["regionID"],
        regionName: element["regionName"],
        factionID: element["factionID"],
        nebula: element["nebula"]
      );
    }

    return regionMap;
  }
}