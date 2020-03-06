import 'package:todo_app/database/entities/todo_entity.dart';
import 'package:todo_app/database/repositories/todo_repository.dart';

class TodoListService {

  static final TodoListService instance = TodoListService._();

  TodoListService._();

  Future<List<TodoEntity>> getTodoList() async {
    return TodoListRepository.instance.getTodoList();
  }

  Future removeTodo(int id) async {
    return TodoListRepository.instance.removeTodo(id);
  }

  Future saveTodo(TodoEntity todo) async {
    return TodoListRepository.instance.saveTodo(todo);
  }
}