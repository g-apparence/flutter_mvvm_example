import 'package:flutter/services.dart';
import 'package:todo_app/database/adapters/todo_list_entity_adapter.dart';
import 'package:todo_app/database/entities/todo_entity.dart';

class TodoListRepository {

  List<TodoEntity> _todoList;

  static final TodoListRepository instance = TodoListRepository._();

  TodoListRepository._();

  Future<List<TodoEntity>> getTodoList() async {
    await this._initList();
    return Future.delayed(Duration(seconds: 2), () => this._todoList);
  }

  Future removeTodo(int id) async {
    await this._initList();
  }

  Future<TodoEntity> saveTodo(TodoEntity todo) async{
    await this._initList();
    this._todoList.add(todo);
    return Future.delayed(Duration(seconds: 2), () => todo);
  }

  Future _initList() async {
    if (this._todoList == null) {
      this._todoList = TodoListEntityAdapter().parse(
          await rootBundle.loadString('assets/mocks/todo_list.json'));
    }
  }
}