import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_app/database/entities/todo_entity.dart';

import 'package:todo_app/services/todo_list/todo_list_service.dart';
import 'package:todo_app/ui/todo_form_page/todo_form_page.dart';

class _TodoListServiceMock extends Mock implements TodoListService{}

_before(WidgetTester tester, {_TodoListServiceMock serviceMock}) async{

  // Mock service
  serviceMock = serviceMock ?? _TodoListServiceMock();
  when(serviceMock.saveTodo(any)).thenAnswer((_) => Future.value(TodoEntity(
    id: 50,
    title: 'title test',
    subtitle: 'subtitle test'
  )));

  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(
        home: TodoFormPage(service: serviceMock),
      ),
    ),
  );

  await tester.pumpAndSettle();
}

void main() {
  group('Test todo form',() {
    testWidgets('Test init', (WidgetTester tester) async {
      await _before(tester);

      // Check title field.
      expect(find.byKey(ValueKey('titleTextFormField')), findsOneWidget);

      // Check subtitle field.
      expect(find.byKey(ValueKey('subtitleTextFormField')), findsOneWidget);

      // Check button
      expect(find.byKey(ValueKey('saveButton')), findsOneWidget);
    });
  });

    testWidgets('Tap on save Button without fill fields', (WidgetTester tester) async {
      _TodoListServiceMock serviceMock = _TodoListServiceMock();

      await _before(tester, serviceMock: serviceMock);

      // Tap on save button
      await tester.tap(find.byKey(ValueKey('saveButton')));
      await tester.pump();

      verifyNever(serviceMock.saveTodo(any));
    });

    testWidgets('Tap on save Button with filled fields', (WidgetTester tester) async {
      _TodoListServiceMock serviceMock = _TodoListServiceMock();

      await _before(tester, serviceMock: serviceMock);

      // Fill title
      await tester.enterText(find.byKey(ValueKey('titleTextFormField')), 'title test');
      await tester.pump();

      // Fill subtitle
      await  tester.enterText(find.byKey(ValueKey('subtitleTextFormField')), 'subtitle test');
      await  tester.pump();

      // Tap on save button
      await  tester.tap(find.byKey(ValueKey('saveButton')));

      verify(serviceMock.saveTodo(any)).called(1);
    });

}
