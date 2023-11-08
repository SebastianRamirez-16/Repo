import 'package:flutter_application_1/models/list_items.dart';
import 'package:flutter_application_1/models/shopping_list.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


//creo la clase DbHelper

class DbHelper{

  //creo una constante para la versión de la BD
  final int version = 1;

  //creo un objeto de la clase Database
  //esta clase es de sqflite
  Database? db;

  //Ahora creo la clase "openDb"
  Future<Database> openDb() async{
    //y aqui hacemos una pregunta fundamental
    //no existe la BD?
    db = await openDatabase(join(await getDatabasesPath(),

      'shopping.db'),
      onCreate: (database, version){

        database.execute('CREATE TABLE lists(id INTEGER PRIMARY KEY, name TEXT, priority INTEGER)');

        //creo la 2da tabla

        database.execute('CREATE TABLE items(id INTEGER PRIMARY KEY, idList INTEGER,'

            'name TEXT, quantity TEXT, note TEXT, FOREIGN KEY(idList) REFERENCES lists(id))');

      }, version: version);

    //no tiene else

    return db!; //--> Siempre se devuelve la BD
  }

  Future testDB() async{

    //llamo a openDb
    db = await openDb();

    //inserto valores en las tablas
    //await db!.execute('INSERT INTO lists VALUES(2, "Computadoras", 1)');
    //await db!.execute('INSERT INTO lists VALUES(1, "Impresoras", 3)');
    //await db!.execute('INSERT INTO items VALUES(0, 0, "Manzanas", "5 Kgs", "Deben ser verdes")');

    //await db!.insert("lists", {'id': 4, 'name': 'carnes', 'priority': 1});

    //Mostramos los valores (usamos el método rawQuery)
    //Pasamos los valores a una lista
    List list = await db!.rawQuery('SELECT * FROM lists');
    List item = await db!.rawQuery('SELECT * FROM items');

    //Mostramos los valores en "consola"
    print(list);
    print(item);

  }

  Future<int> insertList(ShoppingList list) async {
    int id = await db!.insert("lists", list.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<int> insertItems(ListItems item) async {
    int id = await db!.insert("items", item.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<List<ShoppingList>> getLists() async {
    final List<Map<String, dynamic>> list = await db!.rawQuery('SELECT * FROM lists');
    return List.generate(list.length, (i) {
      return ShoppingList(
        list[i]['id'],
        list[i]['name'],
        list[i]['priority'],
      );
    });
  }

}