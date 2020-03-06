import 'package:todo_app/database/entities/todo_entity.dart';
import 'package:todo_app/ui/todo_list_page/todo_list_model.dart';

class TodoListModelAdapter{
  void parse(TodoListModel model, List<TodoEntity> todoList){
    model.todoList = todoList.map((todo) => Todo(
      id: todo.id,
      title: todo.title,
      subtitle: todo.subtitle,
    )).toList();
  }
}