import 'dart:async';

import 'package:todo_app/database/entities/todo_entity.dart';
import 'package:todo_app/database/repositories/todo_repository.dart';
import 'package:todo_app/services/local_storage/store_service.dart';
import 'package:todo_app/services/todo_list/todo_list_storage_adapter.dart';

import '../local_storage/local_storage_manager.dart';

/// This service is a simple singleton but we could have it initialized
/// later :
/// - in an inherited widget above our app
/// - in an inherited above a page
/// - ...
/// this service use both storage and fake remote service
/// it's like we sync our todoList from a remote server and our local
/// for demonstration we keep some default todo_ directly inside app
/// -------
/// for a better experience you can use the excellent lib RxDart to change the cache to a Subject
/// So this can be reactive
class TodoListService {

  List<TodoEntity> _cachedTodoList;

  StoreService<TodoEntity> todoStore = StoreService<TodoEntity>(
    LocalStorageManager("todolist"),
    TodolistStorageModelAdapter(),
    20
  );

  static final TodoListService instance = TodoListService._();

  TodoListService._();

  Future<List<TodoEntity>> getTodoList() async {
    if(_cachedTodoList == null) {
      await this._refreshCache();
    }
    return _cachedTodoList;
  }

  Future removeTodo(int id) async {
    return TodoListRepository.instance.removeTodo(id);
  }

  Future<TodoEntity> saveTodo(String title, String subtitle) async {
    var todo = TodoEntity(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      subtitle: subtitle,
      done: false
    );
    await TodoListRepository.instance.saveTodo(todo);
    await this.todoStore.add(todo);
    this._cachedTodoList.insert(0, todo);
    return todo;
  }

  Future updateTodo(int id, bool done) async {
    this._cachedTodoList.firstWhere((el) => el.id == id)
        ..done = done;
    await this.todoStore.save(_cachedTodoList);
  }

  Future _refreshCache() async {
    await this.todoStore.init();
    if(await this.todoStore.isFirstInit) {
      var fakeRemoteList = await TodoListRepository.instance.getTodoList();
      await this.todoStore.save(fakeRemoteList);
    }
    this._cachedTodoList = todoStore.getItems();
  }

}

