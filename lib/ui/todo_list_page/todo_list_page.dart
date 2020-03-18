import 'package:flutter/material.dart';
import 'package:mvvm_builder/component_builder.dart';
import 'package:todo_app/services/todo_list/todo_list_service.dart';
import 'package:todo_app/ui/todo_list_page/todo_list_model.dart';
import 'package:todo_app/ui/todo_list_page/todo_list_presenter.dart';
import 'package:todo_app/widgets/add_button_widget.dart';
import 'package:todo_app/widgets/todo_widget.dart';

abstract class TodoListView {}

class TodoListPage extends StatelessWidget implements TodoListView {

  final TodoListService _service;

  TodoListPage({TodoListService service, Key key}): this._service = service, super(key: key);

  @override
  Widget build(BuildContext context) {
    return MVVMPage<TodoListPresenter, TodoListModel>(
      key: ValueKey('todoList'),
      presenter: TodoListPresenter(this, this._service ?? TodoListService.instance),
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
        print("=> length ${model.todoList.length}");
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
