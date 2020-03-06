import 'package:flutter/material.dart';

class TodoWidget extends StatelessWidget {

  final String _title, _subtitle;
  final Function _ontap;

  TodoWidget(String title, String subtitle, {Key key, Function onTap})
      : this._title = title, this._subtitle = subtitle, this._ontap = onTap, super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Material(
        child: InkWell(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(this._title ?? ''),
              subtitle: Text(this._subtitle ?? ''),
            ),
          ),
          onTap: this._ontap,
        ),
      ),
    );
  }
}
