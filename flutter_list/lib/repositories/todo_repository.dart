import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/todo.dart';

const todoListkey = 'todo_list';

class TodoRepository{
  late SharedPreferences sharedPreferences ;


  Future<List<Todo>> getTodoList() async{
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString =  sharedPreferences.getString(todoListkey)  ?? '[]';
    final List jsonDecoded =  json.decode(jsonString) as List ;
    return jsonDecoded.map((e) => Todo.fromJson(e)).toList();

  }

  void saveTodoList(List<Todo> todos){
  final JsonString = json.encode(todos);
  sharedPreferences.setString(todoListkey, JsonString);
  }
}