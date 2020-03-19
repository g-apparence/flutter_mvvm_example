import 'package:flutter/material.dart';
import 'package:mvvm_builder/component_builder.dart';
import 'package:todo_app/services/todo_list/todo_list_service.dart';
import 'package:todo_app/ui/todo_list_page/todo_list_model.dart';
import 'package:todo_app/ui/todo_list_page/todo_list_presenter.dart';
import 'package:todo_app/widgets/add_button_widget.dart';
import 'package:todo_app/widgets/todo_widget.dart';

/// this is the contract we can use from our presenter
abstract class TodoListView {

}

/// this is the basic implementation of our contract
class BasicTodoListView implements TodoListView {

}

/// this way we keep the presenter state through builds
/// If you want to add animations, add your Controllers here
class TodoListPageBuilder {

  final TodoListService service;
  final TodoListView todoListView;
  TodoListPresenter presenter;

  TodoListPageBuilder({this.service, @required this.todoListView}) {
    presenter = TodoListPresenter(todoListView, service ?? TodoListService.instance);
  }

  Widget build(BuildContext context) {
    return MVVMPage<TodoListPresenter, TodoListModel>(
      key: ValueKey('todoList'),
      presenter: presenter,
      builder: (context, presenter, model) {
        if (model.isLoading) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Loading...'),
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          );
        }
        return Stack(
          children: <Widget>[
            ListView.builder(
              itemCount: model.todoList.length,
              itemBuilder: (context, index) {
                return TodoWidget(
                  model.todoList[index].title,
                  model.todoList[index].subtitle,
                  model.todoList[index].done,
                  key: ValueKey('todo$index'),
                  onChanged: (done) => presenter.onCheckTodo(index, done),
                  onTap: () => _buildDialog(context, model.todoList[index].title)
                    .then((result) => presenter.removeTodo(index, result)),
                );
              },
            ),
            Positioned(
              right: 16.0,
              bottom: 16.0,
              child: AddButtonWidget(
                key: ValueKey('addButton'),
                onTap: () => Navigator.of(context)
                  .pushNamed('/addTodo')
                  .then(((todo) => presenter.addTodo(todo))
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Future<bool> _buildDialog(BuildContext context, String title){
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          key: ValueKey('alertDialog'),
          title: Text('Wants to delete : $title ?'),
          actions: <Widget>[
            FlatButton(
              key: ValueKey('doneButton'),
              child: Text('Yes'),
              onPressed: () => Navigator.pop(context, true),
            ),
            FlatButton(
              key: ValueKey('notDoneButton'),
              child: Text('No'),
              onPressed: () => Navigator.pop(context, false),
            ),
          ],
        );
      }
    );
  }
}

