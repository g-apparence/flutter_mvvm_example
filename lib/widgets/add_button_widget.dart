import 'package:flutter/material.dart';

class AddButtonWidget extends StatelessWidget {

  final Function _onTap;

  AddButtonWidget({Key key, Function onTap}): this._onTap = onTap, super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Icon(Icons.add,
          color: Colors.white,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100.0),
      ),
      onPressed: this._onTap,
    );
  }
}
