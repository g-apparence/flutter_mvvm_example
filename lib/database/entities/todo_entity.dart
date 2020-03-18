import 'dart:convert';

class TodoEntity {
  int id;
  String title;
  String subtitle;
  bool done;

  TodoEntity({this.id, this.title, this.subtitle, this.done = false});

  toJson() => {
      "id": this.id,
      "title": this.title,
      "subtitle": this.subtitle,
      "done": this.done,
  };
}