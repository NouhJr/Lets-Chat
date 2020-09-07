import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lets_chat/Components/ScaffoldAppbar.dart';
import 'package:lets_chat/Components/Constants.dart';
import 'package:lets_chat/Components/FlushBar.dart';
import 'package:lets_chat/Components/Navigator.dart';
import 'package:lets_chat/Screens/CreateChatRoom.dart';
import 'package:lets_chat/Screens/ChatScreen.dart';

class RecevierProfile extends StatefulWidget {
  RecevierProfile(
      {this.user, this.picture, this.bio, this.senderUser, this.senderPicture});

  final String user;
  final String picture;
  final String bio;

  final String senderUser;
  final String senderPicture;

  @override
  _RecevierProfileState createState() => _RecevierProfileState(
        userName: user,
        userPicture: picture,
        userBio: bio,
        loggedUser: senderUser,
        loggedPicture: senderPicture,
      );
}

class _RecevierProfileState extends State<RecevierProfile> {
  _RecevierProfileState(
      {this.userName,
      this.userPicture,
      this.userBio,
      this.loggedUser,
      this.loggedPicture});

  final String userName;
  final String userPicture;
  final String userBio;

  final String loggedUser;
  final String loggedPicture;

  DocumentReference doc;
  final fireStore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return ScaffoldAppbar(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Stack(
          children: [
            //Image holder container.
            Container(
              height: 200,
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: subMainColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),

            //Image container.
            Container(
              margin: EdgeInsets.only(top: 95, left: 130),
              decoration: BoxDecoration(
                border: Border.all(
                  color: maincolor,
                  width: 5,
                ),
                shape: BoxShape.circle,
              ),
              child: GestureDetector(
                child: new CircleAvatar(
                    radius: 70, backgroundImage: NetworkImage(userPicture)),
              ),
            ),

            //Username container.
            Container(
              margin: EdgeInsets.only(top: 260, left: 130),
              child: Text(
                userName,
                style: TextStyle(
                  fontFamily: 'Futura PT',
                  fontSize: 28,
                  color: Color(0xf0000000),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            //Bio label container.
            Container(
              margin: EdgeInsets.only(top: 395, left: 10),
              child: Text(
                'Biography:',
                style: TextStyle(
                  fontFamily: 'Futura PT',
                  fontSize: 25,
                  color: Color(0xf0000000),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            //Bio container.
            Container(
              margin: EdgeInsets.only(top: 430, left: 10),
              child: Text(
                userBio,
                style: TextStyle(
                  fontFamily: 'Futura PT',
                  fontSize: 21,
                  color: Color(0xf0000000),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            //'Next' button container.
            Container(
              margin: EdgeInsets.only(top: 590, left: 160),
              child: ButtonTheme(
                height: 40,
                minWidth: 100,
                child: RaisedButton(
                  onPressed: action,
                  child: Text(
                    'Next',
                    style: TextStyle(
                      fontFamily: 'Futura PT',
                      fontSize: 22,
                      color: fontcolor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  color: maincolor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool showSpinner = false;

  void action() async {
    //Check if there is internet connection or not and display message error if not.
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(context,
          title: "No internet connection !",
          message: "Pleas turn on wifi or mobile data",
          icons: Icons.signal_wifi_off);
    } else {
      setState(() {
        showSpinner = true;
      });
      try {
        //Creating 'Chat room' collection in firebase.
        final doc = Firestore.instance.collection('Chat Rooms').document();
        doc.setData({
          'sender': loggedUser,
          'recevier': userName,
          'senderPicture': loggedPicture,
          'recevierPicture': userPicture,
        });

        //saving doc id into variable.
        String id = doc.documentID;

        //Create instance of Shared Preferences.
        SharedPreferences prefs = await SharedPreferences.getInstance();

        //getting sender&recevier rooms indices from Shared Preferences.
        var senderRoomsIndex = prefs.getInt('LoggedUserRoomsIndex');
        var recevierRoomsIndex = prefs.getInt('RecevierRoomsIndex');

        //getting sender&recevier chat rooms ids from Shared Preferences.
        var senderChatRooms = prefs.getStringList('LoggedUserRoomsIDs');
        var recevierChatRooms = prefs.getStringList('RecevierRoomsIDs');

        //getting sender&recevier emails from Shared Preferences.
        var senderEmail = prefs.getString('email');
        var recevierEmail = prefs.getString('RecevierEmail');

        //Updating sender&recevier chat rooms list.
        senderChatRooms.insert(senderRoomsIndex + 1, id);
        recevierChatRooms.insert(recevierRoomsIndex + 1, id);

        //Updating sender chat room ids in firestore.
        await fireStore.collection('users').document(senderEmail).updateData({
          'RoomsIndex': senderRoomsIndex + 1,
          'chatRoomsIDS': senderChatRooms.cast<dynamic>(),
        });

        //Updating recevier chat room ids in firestore.
        await fireStore.collection('users').document(recevierEmail).updateData({
          'RoomsIndex': recevierRoomsIndex + 1,
          'chatRoomsIDS': recevierChatRooms.cast<dynamic>(),
        });

        Router().navigator(
            context, ChatScreen(userName: userName, userImage: userPicture));
        setState(() {
          showSpinner = false;
        });
      } catch (e) {
        setState(() {
          showSpinner = false;
        });
        Warning().errorMessage(context,
            title: "Unable to create chat room !",
            message: "Try again later",
            icons: Icons.error);
        Router().navigator(context, ChatRoom());
      }
    }
  }
}
