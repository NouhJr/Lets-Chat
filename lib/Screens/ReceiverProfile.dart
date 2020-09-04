import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:lets_chat/Components/ScaffoldAppbar.dart';
import 'package:lets_chat/Components/Constants.dart';
import 'package:lets_chat/Components/FlushBar.dart';
import 'package:lets_chat/Components/Navigator.dart';
import 'Home_Screen.dart';
import 'package:lets_chat/Screens/CreateChatRoom.dart';

class RecevierProfile extends StatefulWidget {
  RecevierProfile(
      {this.user,
      this.picture,
      this.bio,
      this.senderUser,
      this.senderEmail,
      this.userEmail,
      this.senderPicture});

  final String user;
  final String userEmail;
  final String picture;
  final String bio;

  final String senderUser;
  final String senderEmail;
  final String senderPicture;

  @override
  _RecevierProfileState createState() => _RecevierProfileState(
        userName: user,
        userPicture: picture,
        userBio: bio,
        loggedUser: senderUser,
        loggedEmail: senderEmail,
        recevierEmail: userEmail,
        loggedPicture: senderPicture,
      );
}

class _RecevierProfileState extends State<RecevierProfile> {
  _RecevierProfileState(
      {this.userName,
      this.userPicture,
      this.userBio,
      this.loggedUser,
      this.loggedEmail,
      this.recevierEmail,
      this.loggedPicture});

  final String userName;
  final String recevierEmail;
  final String userPicture;
  final String userBio;

  final String loggedUser;
  final String loggedEmail;
  final String loggedPicture;

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
        //Creating Chat room in recevier's firebase doc.
        await Firestore.instance
            .collection('users')
            .document(recevierEmail)
            .collection('Chat Rooms')
            .document(userName + '&' + loggedUser + ' Room')
            .setData({
          'sender': loggedUser,
          'recevier': userName,
          'senderPicture': loggedPicture,
          'recevierPicture': userPicture,
          'roomID': userName + '&' + loggedUser,
        });

        //Creating Chat room in sender's firebase doc.
        await Firestore.instance
            .collection('users')
            .document(loggedEmail)
            .collection('Chat Rooms')
            .document(loggedUser + '&' + userName + ' Room')
            .setData({
          'sender': loggedUser,
          'recevier': userName,
          'senderPicture': loggedPicture,
          'recevierPicture': userPicture,
          'roomID': userName + '&' + loggedUser,
        });

        Router().navigator(context, Home_Screen());
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
