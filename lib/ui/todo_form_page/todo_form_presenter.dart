import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:todo_app/database/entities/todo_entity.dart';
import 'package:todo_app/services/todo_list/todo_list_service.dart';
import 'package:todo_app/ui/todo_form_page/todo_form_model.dart';
import 'package:todo_app/ui/todo_form_page/todo_form_page.dart';

class TodoFormPresenter extends Presenter<TodoFormModel, TodoFormView>{

  final TodoListService _service;

  TodoFormPresenter(TodoFormView viewInterface, TodoListService service) : this._service = service, super(TodoFormModel(), viewInterface);

  @override
  Future onInit() {
    this.viewModel.isSending= false;
    return super.onInit();
  }

  String validateField(String value){
    if (value == null || value.length < 3){
      return 'This field must contain at least 3 characters';
    }

    return null;
  }

  void saveTitle(String value){
    this.viewModel.title = value;
  }

  void saveSubtitle(String value){
    this.viewModel.subtitle = value;
  }

  bool _validateFields(){
    return this.viewInterface.validateFields();
  }

  void _saveFields(){
    this.viewInterface.saveFields();
  }

  Future saveTodo() async {
    if (this.viewModel.isSending == true){
      return;
    }
    this.viewModel.isSending = true;
    if (!this._validateFields()){
      return;
    }
    this.refreshView();
    this._saveFields();
    return this._service.saveTodo(TodoEntity(
      title: this.viewModel.title,
      subtitle: this.viewModel.subtitle,
    ));
  }
}