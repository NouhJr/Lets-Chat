import 'package:flutter/material.dart';

var maincolor = const Color(0xff4e89ae);
var fontcolor = const Color(0xffffffff);
const subMainColor = Color(0xff43658b);

var drawerBoxDecoration = BoxDecoration(
    color: maincolor,
    borderRadius: BorderRadius.only(bottomRight: Radius.circular(40.0)),
    boxShadow: [
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.10),
        blurRadius: 4.0,
        spreadRadius: 1.0,
        offset: Offset(
          0,
          4.0,
        ),
      )
    ]);
