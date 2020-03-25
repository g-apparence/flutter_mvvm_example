import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:todo_app/database/entities/todo_entity.dart';
import 'package:todo_app/services/todo_list/todo_list_service.dart';
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

  TodoListPresenter(TodoListView viewInterface, TodoListService service)
    : this._service = service, super(TodoListModel(), viewInterface);

  factory TodoListPresenter.create(TodoListService service)
    => TodoListPresenter(null, service);

  @override
  Future onInit() async {
    if(_isAlreadyInit) {
      return;
    }
    this.viewModel.isLoading = true;
    return this._service.getTodoList().then((todoList){
      TodoListModelAdapter().parse(this.viewModel, todoList);
      this.viewModel.isLoading = false;
      this.refreshView();
      this._isAlreadyInit = true;
    });
  }

  void removeTodo(int index, bool remove){
    if (remove == true) {
      this._service.removeTodo(viewModel.todoList[index].id);
      this.viewModel.todoList.removeAt(index);
      this.refreshView();
    }
  }

  void addTodo(TodoEntity entity){
    if (entity == null) {
      return;
    }
    // this should use [TodoListModelAdapter] to prevent bad conversion
    this.viewModel.todoList.insert(0, Todo(
      id: entity.id,
      title: entity.title,
      subtitle: entity.subtitle,
      done: entity.done
    ));
    this.refreshView();
  }

  Future onCheckTodo(int index, bool done) async {
    if(index >= this.viewModel.todoList.length) {
      return;
    }
    this.viewModel.todoList[index].done = done;
    this.refreshView();
    // this is where you want to call your server to update de done status
    // note that you could wrap this in a debounce strategy to avoid multiple
    // updates if user clicks too fast
    await this._service.updateTodo(this.viewModel.todoList[index].id, done);

  }


}