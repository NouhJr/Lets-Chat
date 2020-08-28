import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lets_chat/Components/Constants.dart';

class Textfield extends StatelessWidget {
  Textfield(
      {@required this.label,
      @required this.hint,
      this.icon,
      this.hideText,
      @required this.controller,
      this.email,
      this.focusNode,
      this.maxLines}) {
    if (email) {
      type = TextInputType.emailAddress;
      length = 35;
    } else {
      type = TextInputType.text;
      length = 200;
    }
  }

  final String label;
  final String hint;
  final IconData icon;
  final bool hideText;
  final TextEditingController controller;
  final bool email;
  var type;
  int length;
  var focusNode;
  int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5, left: 10),
      width: 280,
      child: TextField(
        style: TextStyle(
          fontSize: 18,
          color: fontcolor,
        ),
        decoration: new InputDecoration(
          fillColor: maincolor,
          counter: Offstage(),
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(40),
            ),
            borderSide: BorderSide(
              color: maincolor,
            ),
          ),
          focusedBorder: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(30),
            ),
            borderSide: BorderSide(
              color: maincolor,
            ),
          ),
          labelText: label,
          labelStyle: TextStyle(
            fontSize: 18,
            color: fontcolor,
          ),
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 15,
            color: fontcolor,
          ),
          prefixIcon: Icon(
            icon,
            color: fontcolor,
            size: 25,
          ),
        ),
        keyboardType: type,
        cursorColor: fontcolor,
        obscureText: hideText,
        controller: controller,
        maxLength: length,
        maxLengthEnforced: true,
        focusNode: focusNode,
      ),
    );
  }
}
