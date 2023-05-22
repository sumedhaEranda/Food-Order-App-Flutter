import 'dart:io'as io;
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../Controller/CartProvider.dart';
import '../UI/Model/CartModel.dart';




class DBhelper {
  static Database? _db;
  final cartp = cartProvider();
  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
  }

  Future initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "cart.db");

    var theDb = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS CartTb(
        product_name TEXT,
        item_price REAL,
        item_image_url TEXT,
        quantity INTEGER
        );
        ''');
      print("TABLE CREATED");
    });

    return theDb;
  }

  Future<bool> insert(Cart cart) async {
    var dbClient = await db;
    String name = cart.productname;
    var count = await dbClient!
        .rawQuery("SELECT COUNT(*) FROM CartTb WHERE product_name =?", [name]);
    int? exists = Sqflite.firstIntValue(count);
    if (exists == 0) {
       dbClient!.insert('CartTb', cart.toMap());
       final batch=dbClient.batch();
         batch.insert('CartTb', cart.toMap());
    await batch.commit(noResult: true);
      double price =cart.productprice;
      cartp.addtotalprice(price);
      return true;
    } else {
      return false;
    }
  }


  Future<List<Cart>> getAllCategories() async {
    print('*** Executing getAllCategories in db helper');
    var result =
        await _db?.rawQuery('SELECT * FROM CartTb ORDER BY product_name ASC');
    // var result = await db?.query('CartTb',
    //     columns: ['product_name', 'categoryName', 'categoryColor', 'categoryIcon']);
    List<Cart> list =
        result!.isNotEmpty ? result.map((e) => Cart.fromMap(e)).toList() : [];
    return list;
  }

  Future<Future<int>> deletepoduct(String pName) async {
    var dbClient = await db;
    return dbClient!
        .delete('CartTb', where: 'product_name=?', whereArgs: [pName]);

  }
}
