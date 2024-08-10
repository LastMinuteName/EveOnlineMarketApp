import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbModel with ChangeNotifier{
  late Database dbConn;

  Future<String> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "eve.db");

    final exist = await databaseExists(path);

    if(exist) {
      print("db already exists");
    } else {
      print("creating a copy from assets");

      try {
        await Directory(dirname(path)).create(recursive:true);
      } catch(_){}

      ByteData data = await rootBundle.load(join("assets", "databases/eve.sqlite"));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush:true);

      print("db copied");
    }

    dbConn = await openDatabase(path);
    return "DB Loaded";
  }

  Future<void> getByTypeId(int typeId) async {
    List<Map> result = await dbConn.rawQuery(
      'SELECT * FROM invTypes WHERE typeID = ?',
      [typeId],
    );

    print(result);
  }
}