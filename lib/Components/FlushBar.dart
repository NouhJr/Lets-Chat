import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'Constants.dart';

class Warning {
  void errorMessage(BuildContext context,
      {@required String title, @required String message}) {
    Flushbar(
      title: title,
      message: message,
      icon: Icon(
        Icons.warning,
        size: 28,
        color: Colors.red,
      ),
      borderColor: maincolor,
      borderWidth: 5,
      duration: Duration(seconds: 3),
      borderRadius: 18,
    )..show(context);
  }
}
