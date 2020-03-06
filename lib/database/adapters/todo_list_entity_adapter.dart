import 'dart:convert';

import 'package:todo_app/database/entities/todo_entity.dart';

class TodoListEntityAdapter {

  List<TodoEntity> parse(String value){
    List<dynamic> dynamicTodoList = json.decode(value);
    List<TodoEntity> todoList = List();
    dynamicTodoList.forEach((key) => todoList.add(
      TodoEntity(
        id: key['id'],
        title: key['title'],
        subtitle: key['subtitle'],
      ),
    ));

    return todoList;
  }
}