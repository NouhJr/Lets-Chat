import 'package:flutter/material.dart';

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
            fontSize: 18,
            color: Color(0xf0000000),
          ),
        ),
        leading: Icon(
          icon,
          color: iconColor,
        ),
      ),
    );
  }
}
