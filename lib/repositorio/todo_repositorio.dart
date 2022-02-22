import 'dart:convert';

import 'package:lista_tarefa/modelos/todos.dart';
import 'package:shared_preferences/shared_preferences.dart';

const todoListKey = 'todo_list';

class TodoRepositorio {
  late SharedPreferences sharedPreferences;

  Future<List<Todo>> getTodoList() async {  //lendo a lista armazenada anterior mente
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(todoListKey) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => Todo.fromJson(e)).toList();
  }


  void saveTodoList(List<Todo> todos){
    final String jsonString = json.encode(todos);
    sharedPreferences.setString(todoListKey, jsonString);   
  }
}