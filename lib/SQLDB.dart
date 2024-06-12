import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class sqlDB{

  static Database? _db;

  Future<Database?> get db async{
    if(_db == null){
      _db = await intialDB();
      return _db;
    }
    else{
      return _db;
    }
  }

  intialDB() async {
    String database_path = await getDatabasesPath();
    String path = join(database_path , 'User.db');
    Database db = await openDatabase(path , onCreate: _onCreate , version: 5 , onUpgrade: _onUpgrade);
    return db;
  }

  _onUpgrade(Database db , int oldVersion , int newVersion){
    print("onUpgrade*****************************");
  }


  _onCreate(Database database , int version) async {
    print("onCreate*****************************");


    await database.execute('''
    CREATE TABLE "user"  (
      "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "name" TEXT NOT NULL,
      "email" TEXT NOT NULL,
      "password" TEXT NOT NULL
    )
    ''');

    await database.execute('''
    CREATE TABLE "cart"  (
      "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "product_title" TEXT NOT NULL,
      "product_price" TEXT NOT NULL,
      "product_description" TEXT NOT NULL,
      "product_image" TEXT NOT NULL
    )
    ''');


    await database.execute('''
    CREATE TABLE "wishlist"  (
      "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "product_title" TEXT NOT NULL,
      "product_price" TEXT NOT NULL,
      "product_description" TEXT NOT NULL,
      "product_image" TEXT NOT NULL
    )
    ''');
  }

  // "user_id" INTEGER NOT NULL,
  // FOREIGN KEY(user_id) REFERENCES user(id)


    readData(String sql) async{
      Database? database = await db;
      List<Map> response = await database!.rawQuery(sql);
      return response;
    }

    insertData(String sql) async{
      Database? database = await db;
      int response = await database!.rawInsert(sql);
      return response;
    }

    updateData(String sql) async{
      Database? database = await db;
      int response = await database!.rawUpdate(sql);
      return response;
    }

    deleteData(String sql) async{
      Database? database = await db;
      int response = await database!.rawDelete(sql);
      return response;
    }

  }