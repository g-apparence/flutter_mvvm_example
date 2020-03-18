import 'package:flutter/material.dart';
import 'package:todo_app/ui/stats/stats_page.dart';
import 'package:todo_app/ui/todo_list_page/todo_list_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int currentIndex = 0;

  final List<Widget> pages = List()
    ..add(TodoListPage())
    ..add(StatsPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MVVM builder Todo app'),
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if(currentIndex != index) {
            setState(() => currentIndex = index);
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text("Todos")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            title: Text("Stats"),
          )
        ],
      )
    );
  }
}
