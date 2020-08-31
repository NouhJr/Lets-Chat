import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lets_chat/Components/ScaffoldAppbar.dart';
import 'package:lets_chat/Components/Constants.dart';
import 'package:lets_chat/Components/Navigator.dart';
import 'package:lets_chat/Screens/ChatScreen.dart';

class Home_Screen extends StatefulWidget {
  Home_Screen({this.user, this.picture});

  String user = 'User';
  String picture =
      "https://firebasestorage.googleapis.com/v0/b/lets-chat-fbd0f.appspot.com/o/NoUser.jpg?alt=media&token=bbe8c9eb-9439-4fc2-9b5e-ef41a6aafff7";

  @override
  _Home_ScreenState createState() =>
      _Home_ScreenState(currentuser: user, image: picture);
}

class _Home_ScreenState extends State<Home_Screen> {
  _Home_ScreenState({this.currentuser, this.image});

  final _auth = FirebaseAuth.instance;
  final fireStore = Firestore.instance;
  DocumentReference doc;
  String currentuser = '';
  String image =
      "https://firebasestorage.googleapis.com/v0/b/lets-chat-fbd0f.appspot.com/o/NoUser.jpg?alt=media&token=bbe8c9eb-9439-4fc2-9b5e-ef41a6aafff7";

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  //Method 'getUserData' to get the current signed in  user from firebase and retrive user's user name and picture.
  void getUserData() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        final doc =
            await fireStore.collection('users').document(user.uid).get();
        String loggedUserName = doc['username'];
        String imageUrl = doc['picture'];
        setState(() {
          currentuser = loggedUserName;
          image = imageUrl;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  ///**************************UI****************************
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: ScaffoldAppbar(
        //Lis view to display chats.
        body: ListView(
          children: [
            //Container to hold each chat.
            Container(
              margin: EdgeInsets.only(top: 10, left: 5, right: 5),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: maincolor,
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(image),
                  radius: 30.0,
                ),
                title: Text(
                  currentuser,
                  style: TextStyle(
                    fontFamily: 'Futura PT',
                    fontSize: 28,
                    color: fontcolor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: toChatScreen,
              ),
            ),
          ],
        ),
      ),
      onWillPop: _onWillPop,
    );
  }

  ///*********************************BACK END***********************************
  Future<bool> _onWillPop() {
    SystemNavigator.pop();
  }

  //Method 'toChatScreen' to navigate the user to chat screen when he tap on list tile.
  void toChatScreen() {
    Router().navigator(
        context, ChatScreen(userName: currentuser, userImage: image));
  }
}
