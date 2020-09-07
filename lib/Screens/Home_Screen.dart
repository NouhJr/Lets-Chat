import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lets_chat/Streams/ChatRoomsStream.dart';
import 'package:lets_chat/Components/ScaffoldAppbar.dart';
import 'package:lets_chat/Components/Constants.dart';
import 'package:lets_chat/Components/Navigator.dart';
import 'package:lets_chat/Screens/CreateChatRoom.dart';

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
  String currentUserEmail = '';
  String image =
      "https://firebasestorage.googleapis.com/v0/b/lets-chat-fbd0f.appspot.com/o/NoUser.jpg?alt=media&token=bbe8c9eb-9439-4fc2-9b5e-ef41a6aafff7";

  int index = -1;
  List<dynamic> loggedUserRoomsIDs = [];
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
        String email = user.email;
        final doc =
            await fireStore.collection('users').document(user.email).get();
        String loggedUserName = doc['username'];
        String imageUrl = doc['picture'];
        int indexFromDoc = doc['RoomsIndex'];
        List<dynamic> loggedUserRoomsIDsFromDoc = doc['chatRoomsIDS'];
        setState(() {
          currentuser = loggedUserName;
          image = imageUrl;
          currentUserEmail = email;
          index = indexFromDoc;
          loggedUserRoomsIDs = loggedUserRoomsIDsFromDoc;
        });

        //saving index of chat rooms from logged user collection locally in Shared Preferences.
        SharedPreferences savePrefs = await SharedPreferences.getInstance();
        savePrefs.setString('LoggedUser', currentuser);
        savePrefs.setInt('LoggedUserRoomsIndex', index);
        savePrefs.setStringList(
            'LoggedUserRoomsIDs', loggedUserRoomsIDs.cast<String>());
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
        body: Room(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Router().navigator(
                context,
                ChatRoom(
                  currentUser: currentuser,
                  loggedUserEmail: currentUserEmail,
                  currentUserPicture: image,
                ));
          },
          backgroundColor: maincolor,
          elevation: 1.0,
          child: Icon(
            Icons.add_comment,
            size: 35.0,
          ),
        ),
      ),
      onWillPop: _onWillPop,
    );
  }

  ///*********************************BACK END***********************************
  Future<bool> _onWillPop() {
    SystemNavigator.pop();
  }
}
