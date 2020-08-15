import 'package:flutter/material.dart';

class Router {
  void navigator(BuildContext context, var destination) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => destination));
  }
}
