import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mvvm_builder/component_builder.dart';
import 'package:todo_app/database/adapters/todo_list_entity_adapter.dart';

import 'package:todo_app/services/todo_list/todo_list_service.dart';
import 'package:todo_app/ui/todo_list_page/todo_list_page.dart';
import 'package:todo_app/widgets/todo_widget.dart';

import '../../../lib/ui/todo_list_page/todo_list_model.dart';
import '../../../lib/ui/todo_list_page/todo_list_presenter.dart';

class _TodoListServiceMock extends Mock implements TodoListService{}

class _NavigatorObserverMock extends Mock implements NavigatorObserver{}

/// this is an example if you want to test directly the presenter or use it in your tests
/// you can test methods directly and check if business logic is good in model
_getPresenter(WidgetTester tester, Widget app) {
  var page = find.byKey(ValueKey('todoList')).evaluate().first.widget as MVVMPage<TodoListPresenter, TodoListModel>;
  return page.presenter;
}


_before(WidgetTester tester, {_TodoListServiceMock serviceMock, _NavigatorObserverMock navigatorMock}) async{

  final String todoListJson = File('assets/mocks/todo_list.json').readAsStringSync();

  // Mock service
  serviceMock = serviceMock ?? _TodoListServiceMock();
  when(serviceMock.getTodoList()).thenAnswer((_) => Future.value(TodoListEntityAdapter().parse(todoListJson)));

  // Mock navigator
  navigatorMock = navigatorMock ?? _NavigatorObserverMock();

  await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
          navigatorObservers: [navigatorMock],
          routes: {
            "/addTodo": (context) => Container(key: Key("addTodoRoute")),
          },
          home: TodoListPage(service: serviceMock),
        ),
      ),
  );

  reset(navigatorMock);
  await tester.pumpAndSettle();
}

void main() {
  group('Test todo app',() {
    testWidgets('Test init', (WidgetTester tester) async {
      await _before(tester);

      // Check first element.
      expect(find.byKey(ValueKey('todo0')), findsOneWidget);
      expect(find.text('First todo'), findsOneWidget);
      expect(find.text('What do we have to do first ?'), findsOneWidget);

      // Check second element.
      expect(find.byKey(ValueKey('todo1')), findsOneWidget);
      expect(find.text('Second todo'), findsOneWidget);
      expect(find.text('What should I do ?'), findsOneWidget);

      // Check third element.
      expect(find.byKey(ValueKey('todo2')), findsOneWidget);
      expect(find.text('Third todo'), findsOneWidget);
      expect(find.text('Do it !'), findsOneWidget);

      // Check element number
      expect(find.byType(TodoWidget), findsNWidgets(3));
    });

    testWidgets('Test on element tap', (WidgetTester tester) async {
      await _before(tester);

      // tap on first element
      await tester.tap(find.byKey(ValueKey('todo0')));
      await tester.pump();

      // Check dialog is opened.
      expect(find.byKey(ValueKey('alertDialog')), findsOneWidget);
      expect(find.text('Have you done : First todo ?'), findsOneWidget);

      expect(find.byKey(ValueKey('doneButton')), findsOneWidget);
      expect(find.text('DONE'), findsOneWidget);

      expect(find.byKey(ValueKey('notDoneButton')), findsOneWidget);
      expect(find.text('NOT DONE'), findsOneWidget);
    });

    testWidgets('Test on "DONE" button tap', (WidgetTester tester) async {
      _TodoListServiceMock serviceMock = _TodoListServiceMock();
      await _before(tester, serviceMock: serviceMock);

      // tap on first element
      await tester.tap(find.byKey(ValueKey('todo0')));
      await tester.pump();

      // tap on DONE button
      await tester.tap(find.byKey(ValueKey('doneButton')));
      await tester.pump();

      // Check first element.
      expect(find.byKey(ValueKey('todo0')), findsOneWidget);

      // Check second element.
      expect(find.byKey(ValueKey('todo1')), findsOneWidget);

      // Check third element.
      expect(find.byKey(ValueKey('todo2')), findsNothing);

      // Check element number
      expect(find.byType(TodoWidget), findsNWidgets(2));

      // Check element has been deleted
      expect(find.text('First todo'), findsNothing);
      expect(find.text('What do we have to do first ?'), findsNothing);

      verify(serviceMock.removeTodo(10)).called(1);
    });

    testWidgets('Test on "NOT DONE" button tap', (WidgetTester tester) async {
      await _before(tester);

      // tap on first element
      await tester.tap(find.byKey(ValueKey('todo0')));
      await tester.pump();

      // tap on DONE button
      await tester.tap(find.byKey(ValueKey('notDoneButton')));
      await tester.pump();

      // Check first element.
      expect(find.byKey(ValueKey('todo0')), findsOneWidget);

      // Check second element.
      expect(find.byKey(ValueKey('todo1')), findsOneWidget);

      // Check third element.
      expect(find.byKey(ValueKey('todo2')), findsOneWidget);

      // Check element number
      expect(find.byType(TodoWidget), findsNWidgets(3));
    });

    testWidgets('Test on add (+) button tap', (WidgetTester tester) async {
      _NavigatorObserverMock navigatorMock = _NavigatorObserverMock();
      await _before(tester, navigatorMock: navigatorMock);

      // Tap on add (+) button
      await tester.tap(find.byKey(ValueKey('addButton')));
      await tester.pumpAndSettle();

      verify(navigatorMock.didPush(any, any)).called(1);
      // Check new page has been opened
      expect(find.byKey(Key('addTodoRoute')), findsOneWidget);
    });
  });

}
