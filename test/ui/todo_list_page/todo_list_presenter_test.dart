import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm_builder/component_builder.dart';
import 'package:todo_app/database/adapters/todo_list_entity_adapter.dart';
import 'package:todo_app/services/todo_list/todo_list_service.dart';
import 'package:todo_app/ui/todo_list_page/todo_list_model.dart';
import 'package:todo_app/ui/todo_list_page/todo_list_page.dart';
import 'package:todo_app/ui/todo_list_page/todo_list_presenter.dart';
import 'package:mockito/mockito.dart';

class _TodoListServiceMock extends Mock implements TodoListService{}
class _TodoListViewMock extends Mock implements TodoListView {}

void main() {
  group('TodoListPresenter tests', () {

    // create presenter with mocked service and view
    TodoListService todoService = _TodoListServiceMock();
    TodoListView view = _TodoListViewMock();
    TodoListPresenter presenter = TodoListPresenter(view, todoService);

    // mock the returned list from a file in our assets
    final String todoListJson = File('assets/mocks/todo_list.json').readAsStringSync();
    when(todoService.getTodoList()).thenAnswer((_) => Future.value(TodoListEntityAdapter().parse(todoListJson)));

    test('clicking on a todo checkbox will switch done status', () async {
      await presenter.onInit();
      expect(presenter.viewModel.todoList.length, 3);
      expect(presenter.viewModel.todoList[2].done, isFalse);
      await presenter.onCheckTodo(2, true);
      expect(presenter.viewModel.todoList[2].done, isTrue);
    });

  });
}