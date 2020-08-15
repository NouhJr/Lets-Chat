import 'package:flutter/material.dart';
import 'package:lets_chat/Components/Constants.dart';
import 'Reuseable_Inkwell.dart';

class ScaffoldAppbar extends StatelessWidget {
  ScaffoldAppbar({@required this.body});
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
        elevation: 0.1,
        title: Text(
          'Lets Chat',
          style: TextStyle(
            fontFamily: 'Futura PT',
            fontSize: 28,
            color: fontcolor,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Container(
          width: 50,
          color: Color(0xffffffff),
          child: new ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                //Data goes here
                accountName: null,
                accountEmail: Text(
                  'omarnouh@gmail.com',
                  style: TextStyle(
                    fontFamily: 'Futura PT',
                    fontSize: 18,
                    color: fontcolor,
                  ),
                ),
                // User Picture
                currentAccountPicture: GestureDetector(
                  child: new CircleAvatar(
                    backgroundColor: Color(0xffffffff),
                    child: Icon(Icons.person, color: maincolor),
                  ),
                ),

                //Box holding first section (User Data)
                decoration: drawerBoxDecoration,
              ),

              //Drawer Body
              Reuseable_Inkwell(
                InkTitle: 'My account',
                icon: Icons.person,
              ),
              Reuseable_Inkwell(
                InkTitle: 'About',
                icon: Icons.help,
              ),

              Reuseable_Inkwell(
                InkTitle: 'Log out',
                icon: Icons.exit_to_app,
              ),
            ],
          ),
        ),
      ),
      body: body,
    );
  }
}
