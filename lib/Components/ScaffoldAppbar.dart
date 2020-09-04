import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:lets_chat/Components/Constants.dart';
import 'package:lets_chat/Components/FlushBar.dart';
import 'Reuseable_Inkwell.dart';
import 'Navigator.dart';
import 'package:lets_chat/Screens/Main_Screen.dart';
import 'package:lets_chat/Screens/Account.dart';
import 'package:lets_chat/Screens/Home_Screen.dart';

class ScaffoldAppbar extends StatefulWidget {
  ScaffoldAppbar({@required this.body, this.floatingActionButton});
  final Widget body;
  final Widget floatingActionButton;
  @override
  _State createState() =>
      _State(body: body, floatingActionButton: floatingActionButton);
}

class _State extends State<ScaffoldAppbar> {
  _State({@required this.body, this.floatingActionButton});
  final Widget body;
  final Widget floatingActionButton;
  final _auth = FirebaseAuth.instance;
  final fireStore = Firestore.instance;
  DocumentReference doc;
  FirebaseUser newUser;
  String currentuser = '';
  String currentuserEmail = '';
  String biography = '';
  String url =
      "https://firebasestorage.googleapis.com/v0/b/lets-chat-fbd0f.appspot.com/o/NoUser.jpg?alt=media&token=bbe8c9eb-9439-4fc2-9b5e-ef41a6aafff7";

  @override
  void initState() {
    getUser();
    super.initState();
  }

  //Method 'getUser' to get the current signed in  user from firebase and retrive user's email, user name , bio and picture
  void getUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        newUser = user;
        setState(() {
          currentuserEmail = newUser.email;
        });
        final doc = await fireStore
            .collection('users')
            .document(currentuserEmail)
            .get();
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

  ///******************************************UI***************************************/
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
          textHeightBehavior: TextHeightBehavior(
            applyHeightToFirstAscent: true,
          ),
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
                  Router().navigator(
                      context,
                      Home_Screen(
                        user: currentuser,
                        picture: url,
                      ));
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
      floatingActionButton: floatingActionButton,
    );
  }

//Method 'logOutAction' to sign the user out from the app using firebase with 'signOut' method.
  void logOutAction(BuildContext context) async {
    //Check if there is internet connection or not and display message error if not.
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(context,
          title: "No internet connection !",
          message: "Pleas turn on wifi or mobile data",
          icons: Icons.signal_wifi_off);
    } else {
      _auth.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('email');
      Router().navigator(context, Main_Screen());
    }
  }
}
