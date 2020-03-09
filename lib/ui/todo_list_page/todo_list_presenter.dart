import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:todo_app/database/entities/todo_entity.dart';
import 'package:todo_app/services/todo_list_service.dart';
import 'package:todo_app/ui/todo_list_page/adapters/todo_list_model_adapter.dart';
import 'package:todo_app/ui/todo_list_page/todo_list_model.dart';
import 'package:todo_app/ui/todo_list_page/todo_list_page.dart';


/// this class is the most important here
/// This is where you wrap all business logic
/// All view interactions use cases will modify model
/// Our view as to stay idiot and just bind values from the model
class TodoListPresenter extends Presenter<TodoListModel, TodoListView>{

  final TodoListService _service;
  bool _isAlreadyInit = false;

  TodoListPresenter(TodoListView viewInterface, TodoListService service) : this._service = service, super(TodoListModel(), viewInterface);

  @override
  Future onInit() {
    if(this._isAlreadyInit){
      return super.onInit();
    }

    this.viewModel.isLoading = true;
    this._service.getTodoList().then((todoList){
      TodoListModelAdapter().parse(this.viewModel, todoList);
      this.viewModel.isLoading = false;
      this.refreshView();
    });

    this._isAlreadyInit = true;
    return super.onInit();
  }

  void removeTodo(int index, bool remove){
    if (remove == true) {
      this._service.removeTodo(viewModel.todoList[index].id);
      this.viewModel.todoList.removeAt(index);
      this.refreshView();
    }
  }

  void addTodo(TodoEntity entity){
    if (entity == null){
      return;
    }
    this.viewModel.todoList.add(Todo(
      title: entity.title,
      subtitle: entity.subtitle,
    ));

    this.refreshView();
  }
}