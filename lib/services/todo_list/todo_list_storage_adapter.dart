import 'package:todo_app/database/entities/todo_entity.dart';
import 'package:todo_app/services/local_storage/entity_adapter.dart';

class TodolistStorageModelAdapter extends GenericEntityAdapter<TodoEntity> {

  @override
  parseMap(Map<String, dynamic> map) {
    return TodoEntity(
      id: map['id'],
      title: map['title'],
      subtitle: map['subtitle'],
      done: map['done']
    );
  }

}