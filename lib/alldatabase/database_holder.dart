
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlfildnodepractice/model/todo_model.dart';

class DatabaseHolder{

   static Database? _database;

   Future <Database?> get db async{
      if(_database !=null){
         return _database;
      }
      _database=initilaisDatabase();

      return _database;
   }

   initilaisDatabase()async {

      Directory dbpath = await getApplicationDocumentsDirectory();

      String path=join(dbpath.path,"todos.db");

     return openDatabase(path,version: 2,onCreate:_onCreate
      );

  }

  _onCreate(Database db, int version)async{

     await db.execute('''
        CREATE TABLE todos(
        id INTEGER PRIMARY KEY,
        title TEXT,
        description TEXT,
        datetime TEXT
        
        )
        
        ''');

  }
  Future addTodoMathod( TodoModel todoModel) async{

      Database? database=await db;
      
     return database!.insert("todos", todoModel.toJson() );

  }

  Future<List<TodoModel>?> getTodomathod() async{

      Database? database =await db;
      var data= await database!.query("todos",orderBy: "id");

      List<TodoModel> todomodels=data.map((todomodel) => TodoModel.fromJson(todomodel)).toList();

      return todomodels;
      

  }


}