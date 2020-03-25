import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:todo_app/services/todo_list/todo_list_service.dart';
import 'package:todo_app/ui/stats/stats_model.dart';
import 'package:todo_app/ui/stats/stats_page.dart';


class StatsPresenter extends Presenter<StatsViewModel, StatsView> {

  final TodoListService service;

  StatsPresenter(StatsView viewInterface, this.service) : super(StatsViewModel(), viewInterface);

  @override
  Future onInit() {
    this.viewModel.completedTodo = 0;
    this.viewModel.activeTodos = 0;
    return service.getTodoList().then((res) {
      res.forEach((el) {
        if(el.done) {
          this.viewModel.completedTodo++;
        } else {
          this.viewModel.activeTodos++;
        }
      });
      refreshView();
    });
  }


}





