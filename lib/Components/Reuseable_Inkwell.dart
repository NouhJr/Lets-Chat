import 'package:flutter/material.dart';
import 'package:lets_chat/Components/Constants.dart';

class Reuseable_Inkwell extends StatelessWidget {
  Reuseable_Inkwell({this.InkTitle, this.OnPress, this.icon, this.iconColor});

  final String InkTitle;
  final Function OnPress;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: OnPress,
      child: ListTile(
        title: Text(
          InkTitle,
          style: TextStyle(
            fontFamily: 'Futura PT',
            fontSize: 20,
            color: maincolor,
          ),
        ),
        leading: Icon(
          icon,
          color: iconColor,
          size: 30,
        ),
      ),
    );
  }
}
