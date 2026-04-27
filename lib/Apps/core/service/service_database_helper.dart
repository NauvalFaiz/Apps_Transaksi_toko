import 'dart:io' as io;

import 'package:flutter_mobile_modul/Apps/core/service/service_cart_db.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ServiceDatabaseHelper {
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return null;
  }

  initDatabase() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'cart.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE IF NOT EXISTS cart(id INTEGER PRIMARY KEY, id_movie VARCHAR, title TEXT, voteaverage DOUBLE, overview TEXT, quantity INTEGER, posterpath TEXT)',
    );
  }

  Future<ServiceDatabaseHelper> insert(ServiceDatabaseHelper cart) async {
    var dbClient = await database;
    if (dbClient != null) {
      await dbClient.insert(
        'cart',
        ServiceCartDb().toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return cart;
    } else {
      return cart;
    }
  }

  Future<List<ServiceCartDb>> getCartList() async {
    try {
      var dbClient = await database;
      final List<Map<String, Object?>> queryResult = await dbClient!.query(
        'cart',
      );
      return queryResult
          .map((result) => ServiceCartDb.fromMap(result))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future getCartListDetail(id) async {
    try {
      var dbClient = await database;
      final queryResult = await dbClient!.query(
        'cart',
        where: 'id = ?',
        whereArgs: [id],
      );
      return queryResult
          .map((result) => ServiceCartDb.fromMap(result))
          .toList();
    } catch (e) {
      return null;
    }
  }

  Future<int> updateQuantity(id, qty) async {
    var dbClient = await database;
    return await dbClient!.update(
      'cart',
      {"quantity": qty},
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> deleteCartItem(int id) async {
    var dbClient = await database;
    return await dbClient!.delete('cart', where: 'id = ?', whereArgs: [id]);
  }
}
