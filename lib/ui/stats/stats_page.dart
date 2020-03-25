import 'package:flutter/material.dart';
import 'package:mvvm_builder/component_builder.dart';
import 'package:todo_app/database/entities/todo_entity.dart';
import 'package:todo_app/services/todo_list/todo_list_service.dart';
import 'package:todo_app/ui/stats/stats_model.dart';
import 'package:todo_app/ui/stats/stats_presenter.dart';


abstract class StatsView {

}


/// presenter is build on each page call but if you want to improve performance as we
/// are using tabs I suggest you to keep presenter as we did in the TodoListPage
class StatsPage extends StatelessWidget implements StatsView {

  @override
  Widget build(BuildContext context) {
    return MVVMPage<StatsPresenter, StatsViewModel>(
      key: ValueKey("presenter"),
      presenter: StatsPresenter(this, TodoListService.instance),
      builder: (context, presenter, model) =>
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text("Completed TODOS", textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
            Text("${model.completedTodo}", textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text("Active TODOS", textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            Text("${model.activeTodos}", textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
          ],
        )
    );
  }

}