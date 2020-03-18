import 'package:todo_app/database/entities/todo_entity.dart';
import 'package:todo_app/ui/todo_list_page/todo_list_model.dart';

/// this is where you adapt your Entities from backend to the View Model
/// Here is a simple bind but you can for example format date directly here as you prefer not having to do it
/// in your view
class TodoListModelAdapter {

  void parse(TodoListModel model, List<TodoEntity> todoList){
    model.todoList = todoList.map((todo) => Todo(
      id: todo.id,
      title: todo.title,
      subtitle: todo.subtitle,
      done: todo.done
    )).toList();
  }
}