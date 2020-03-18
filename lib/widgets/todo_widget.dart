import 'package:flutter/material.dart';

typedef OnChangedStatus = void Function(bool value);

class TodoWidget extends StatelessWidget {

  final bool _done;
  final String _title, _subtitle;
  final Function _ontap;
  final OnChangedStatus _onChanged;

  TodoWidget(this._title, this._subtitle, this._done, {Key key, Function onTap, OnChangedStatus onChanged})
      : this._ontap = onTap,
        this._onChanged = onChanged,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Material(
        child: InkWell(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: ListTile(
              leading: Checkbox(
                onChanged: this._onChanged,
                value: _done,
              ),
              title: Text(this._title ?? ''),
              subtitle: Text(this._subtitle ?? ''),
            ),
          ),
          onLongPress: this._ontap,
        ),
      ),
    );
  }
}
