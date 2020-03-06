import 'package:flutter/material.dart';
import 'package:todo_app/ui/todo_form_page/todo_form_page.dart';
import 'package:todo_app/ui/todo_list_page/todo_list_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/addTodo': (context) => TodoFormPage(),
      },
      home: TodoListPage(),
    );
  }
}
