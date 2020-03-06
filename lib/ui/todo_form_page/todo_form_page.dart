

import 'package:flutter/material.dart';
import 'package:mvvm_builder/component_builder.dart';
import 'package:todo_app/services/todo_list_service.dart';
import 'package:todo_app/ui/todo_form_page/todo_form_model.dart';
import 'package:todo_app/ui/todo_form_page/todo_form_presenter.dart';

abstract class TodoFormView {
  bool validateFields();
  void saveFields();
}

class TodoFormPage extends StatelessWidget implements TodoFormView {

  final GlobalKey<FormState> _formKey = GlobalKey();

  final TodoListService _service;

  TodoFormPage({TodoListService service, Key key}): this._service = service, super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add todo'),
      ),
      body: MVVMPage<TodoFormPresenter, TodoFormModel>(
        key: ValueKey('todoForm'),
        presenter: TodoFormPresenter(this, this._service ?? TodoListService.instance),
        builder: (context, presenter, model){
          return model.isSending == true ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Sending...'),
                CircularProgressIndicator(),
              ],
            ),
          ) : Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 16.0,
                    ),
                    child: TextFormField(
                      key: ValueKey('titleTextFormField'),
                      decoration: InputDecoration(
                          labelText: 'title'
                      ),
                      validator: presenter.validateField,
                      onSaved: presenter.saveTitle,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 16.0,
                    ),
                    child: TextFormField(
                      key: ValueKey('subtitleTextFormField'),
                      decoration: InputDecoration(
                          labelText: 'subtitle'
                      ),
                      validator: presenter.validateField,
                      onSaved: presenter.saveSubtitle,
                    ),
                  ),
                  Center(
                    child: FlatButton(
                      key: ValueKey('saveButton'),
                      child: Text('Save',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                      ),
                      onPressed: () => model.isSending == true ? null : presenter.saveTodo().then((todo) => Navigator.of(context).pop(todo)),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool validateFields() {
    return this._formKey.currentState.validate();
  }

  @override
  void saveFields() {
    this._formKey.currentState.save();
  }
}
