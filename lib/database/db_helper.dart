import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();

  static final DBHelper getinstance = DBHelper._();

  static const String TABLE_USER = 'user_reg';
  static const String COLUMN_USER_ID = 'user_id';
  static const String COLUMN_USER_NAME = 'user_name';
  static const String COLUMN_USER_AGE = 'user_age';
  static const String COLUMN_USER_ADDRESS = 'user_address';
  static const String COLUMN_USER_DOB = 'user_dob';

  Database? _database;

  Future<Database> getDB() async {
    _database ??= await openDB();
    return _database!;
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbpath = join(appDir.path, "user_db.db");
    return await openDatabase(dbpath, version: 1,
        onCreate: (db, version) async {
      await db.execute("CREATE TABLE $TABLE_USER ("
          "$COLUMN_USER_ID INTEGER PRIMARY KEY , "
          "$COLUMN_USER_NAME TEXT, "
          "$COLUMN_USER_AGE TEXT, "
          "$COLUMN_USER_ADDRESS TEXT, "
          "$COLUMN_USER_DOB TEXT"
          ")");
    });
  }

  /// Insert user data
  Future<bool> addUserInfo({
    required String name,
    required String age,
    required String address,
    required String dob,
  }) async {
    var db = await getDB();
    int rowsEffected = await db.insert(TABLE_USER, {
      COLUMN_USER_NAME: name,
      COLUMN_USER_AGE: age,
      COLUMN_USER_ADDRESS: address,
      COLUMN_USER_DOB: dob,
    });
    return rowsEffected > 0;
  }

  /// Fetch user data
  Future<List<Map<String, dynamic>>> getUserInfo() async {
    var db = await getDB();
    List<Map<String, dynamic>> data = await db.query(TABLE_USER);
    return data;
  }

  ///upadate user data

  Future<bool> updateUserInfo(
      {required int userid,
      required String name,
      required String age,
      required String address,
      required String dob}) async {
    var db = await getDB();
    int rowEffected = await db.update(
      TABLE_USER,
      {
        COLUMN_USER_NAME: name,
        COLUMN_USER_AGE: age,
        COLUMN_USER_ADDRESS: address,
        COLUMN_USER_DOB: dob,
      },
      where: "$COLUMN_USER_ID = ?",
      whereArgs: [userid],
    );
    return rowEffected > 0;
  }

  ///delete user data
  Future<bool> deleteUserInfo({required int userid}) async {
    var db = await getDB();
    int rowEffected = await db.delete(
      TABLE_USER,
      where: "$COLUMN_USER_ID=?",
      whereArgs: ['$userid'],
    );
    return rowEffected > 0;
  }
}
