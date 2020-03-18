import 'package:todo_app/database/entities/todo_entity.dart';
import 'package:todo_app/database/repositories/todo_repository.dart';
import 'package:todo_app/services/local_storage/store_service.dart';
import 'package:todo_app/services/todo_list/todo_list_storage_adapter.dart';

import '../local_storage/local_storage_manager.dart';

/// this service use both storage and fake remote service
/// it's like we sync our todoList from a remote server and our local
/// for demonstration we keep some default todo_ directly inside app
class TodoListService {

  StoreService<TodoEntity> todoStore = StoreService<TodoEntity>(
    LocalStorageManager("todolist"),
    TodolistStorageModelAdapter(),
    100
  );

  static final TodoListService instance = TodoListService._();

  TodoListService._() {
    this.todoStore.init();
  }

  Future<List<TodoEntity>> getTodoList() async {
    return TodoListRepository.instance.getTodoList()
      .then((res) => todoStore.getItems()..addAll(res));
  }

  Future removeTodo(int id) async {
    return TodoListRepository.instance.removeTodo(id);
  }

  Future<TodoEntity> saveTodo(TodoEntity todo) async {
    await TodoListRepository.instance.saveTodo(todo);
    await this.todoStore.add(todo);
    return todo;
  }
}