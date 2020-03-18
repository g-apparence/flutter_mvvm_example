import 'package:mvvm_builder/mvvm_builder.dart';

class TodoListModel extends MVVMModel{
  bool isLoading;
  List<Todo> todoList;

}

class Todo {
  int id;
  String title, subtitle;
  bool done;

  Todo({this.id, this.title, this.subtitle, this.done = false});
}