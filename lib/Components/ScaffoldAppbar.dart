import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lets_chat/Components/Constants.dart';
import 'Reuseable_Inkwell.dart';
import 'Navigator.dart';
import 'package:lets_chat/Screens/Main_Screen.dart';

class ScaffoldAppbar extends StatefulWidget {
  ScaffoldAppbar({@required this.body});
  final Widget body;

  @override
  _State createState() => _State(body: body);
}

class _State extends State<ScaffoldAppbar> {
  _State({@required this.body});
  final Widget body;

  final _auth = FirebaseAuth.instance;
  FirebaseUser newUser;
  String currentuser = '';

  @override
  void initState() {
    getUser();
    super.initState();
  }

  void getUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        newUser = user;
        setState(() {
          currentuser = newUser.email;
        });
      }
    } catch (e) {
      print(e);
    }
  }

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
                  currentuser,
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
                OnPress: () => logOutAction(context),
              ),
            ],
          ),
        ),
      ),
      body: body,
    );
  }

  void logOutAction(BuildContext context) {
    _auth.signOut();
    Router().navigator(context, Main_Screen());
  }
}
