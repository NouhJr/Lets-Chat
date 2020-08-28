import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lets_chat/Components/Constants.dart';
import 'Reuseable_Inkwell.dart';
import 'Navigator.dart';
import 'package:lets_chat/Screens/Main_Screen.dart';
import 'package:lets_chat/Screens/Account.dart';
import 'package:lets_chat/Screens/Home_Screen.dart';

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
  final fireStore = Firestore.instance;
  DocumentReference doc;
  FirebaseUser newUser;
  String currentuser = '';
  String currentuserEmail = '';
  String biography = '';
  String url =
      "https://firebasestorage.googleapis.com/v0/b/lets-chat-fbd0f.appspot.com/o/NoUser.jpg?alt=media&token=af77c942-d282-400f-8be3-aaa370928cbd";

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
          currentuserEmail = newUser.email;
        });
        final doc =
            await fireStore.collection('users').document(user.uid).get();
        String loggedUserName = doc['username'];
        String imageUrl = doc['picture'];
        String biofromDB = doc['bio'];
        setState(() {
          currentuser = loggedUserName;
          url = imageUrl;
          biography = biofromDB;
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
                accountName: Text(
                  currentuser,
                  style: TextStyle(
                    fontFamily: 'Futura PT',
                    fontSize: 20,
                    color: fontcolor,
                  ),
                  textAlign: TextAlign.center,
                ),
                accountEmail: Text(
                  currentuserEmail,
                  style: TextStyle(
                    fontFamily: 'Futura PT',
                    fontSize: 20,
                    color: fontcolor,
                  ),
                  textAlign: TextAlign.center,
                ),
                currentAccountPicture: GestureDetector(
                  child: new CircleAvatar(
                    backgroundImage: NetworkImage(url),
                  ),
                ),

                //Box holding first section (User Data)
                decoration: drawerBoxDecoration,
              ),

              //Drawer Body
              //Home
              Reuseable_Inkwell(
                InkTitle: 'Home',
                icon: Icons.home,
                iconColor: maincolor,
                OnPress: () {
                  Router().navigator(context, Home_Screen());
                },
              ),

              //My account
              Reuseable_Inkwell(
                InkTitle: 'My account',
                icon: Icons.person,
                iconColor: maincolor,
                OnPress: () {
                  Router().navigator(
                      context,
                      Myaccount(
                        user: currentuser,
                        picture: url,
                        bio: biography,
                      ));
                },
              ),

              //Log out.
              Reuseable_Inkwell(
                InkTitle: 'Log out',
                icon: Icons.exit_to_app,
                OnPress: () => logOutAction(context),
                iconColor: maincolor,
              ),
            ],
          ),
        ),
      ),
      body: body,
    );
  }

  void logOutAction(BuildContext context) async {
    _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    Router().navigator(context, Main_Screen());
  }
}
