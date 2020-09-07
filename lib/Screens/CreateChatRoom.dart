import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lets_chat/Components/Constants.dart';
import 'package:lets_chat/Components/Navigator.dart';
import 'package:lets_chat/Components/FlushBar.dart';
import 'package:lets_chat/Components/ScaffoldAppbar.dart';
import 'package:lets_chat/Screens/ReceiverProfile.dart';

class ChatRoom extends StatefulWidget {
  ChatRoom({this.currentUser, this.loggedUserEmail, this.currentUserPicture});
  final String currentUser;
  final String loggedUserEmail;
  final String currentUserPicture;

  @override
  _ChatRoomState createState() => _ChatRoomState(
      sender: currentUser,
      senderEmail: loggedUserEmail,
      senderImage: currentUserPicture);
}

class _ChatRoomState extends State<ChatRoom> {
  _ChatRoomState({this.sender, this.senderEmail, this.senderImage});
  final String sender;
  final String senderEmail;
  final String senderImage;

  @override
  Widget build(BuildContext context) {
    return ScaffoldAppbar(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Stack(
          children: [
            //Container to hold user's email text field.
            Container(
              width: 400,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: maincolor,
                borderRadius: BorderRadius.circular(40),
              ),
              child:
                  //User's user name text field.
                  TextField(
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Futura PT',
                  color: fontcolor,
                ),
                decoration: InputDecoration(
                  hintText: "Enter user's email",
                  hintStyle: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Futura PT',
                    color: Colors.grey,
                  ),
                  fillColor: maincolor,
                  border: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  contentPadding: EdgeInsets.only(
                    left: 10,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.grey,
                controller: user,
              ),
            ),

            //Container to hold 'next' button.
            Container(
              margin: EdgeInsets.symmetric(horizontal: 150, vertical: 90),
              child: ButtonTheme(
                height: 40,
                minWidth: 100,
                child: RaisedButton(
                  onPressed: nextButtonAction,
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

  final user = TextEditingController();
  final fireStore = Firestore.instance;
  bool showSpinner = false;
  String receiverUserName = '';
  String receiverPicture =
      "https://firebasestorage.googleapis.com/v0/b/lets-chat-fbd0f.appspot.com/o/NoUser.jpg?alt=media&token=bbe8c9eb-9439-4fc2-9b5e-ef41a6aafff7";
  String receiverBio = '';
  int recevierRoomsIndex = -1;
  List<dynamic> recevierRoomsIDs = [];

  void disposeEmail() {
    user.dispose();
  }

  void nextButtonAction() async {
    //Check if there is internet connection or not and display message error if not.
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(context,
          title: "No internet connection !",
          message: "Pleas turn on wifi or mobile data",
          icons: Icons.signal_wifi_off);
      //Validate 'email' text field to make sure it's not empty.
    } else if (user.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "Email field can't be empty !",
        message: 'Please enter an email.',
        icons: Icons.warning,
      );
      //Validate 'email' text field to make sure it contains '@'.
    } else if (!user.text.contains('@')) {
      Warning().errorMessage(
        context,
        title: 'Invalid email !',
        message: "Email must contain '@' ",
        icons: Icons.warning,
      );
      user.clear();

      //Validate 'email' text field to make sure it contains '.com'.
    } else if (!user.text.contains('.com')) {
      Warning().errorMessage(
        context,
        title: 'Invalid email !',
        message: "Email must contain '.com' ",
        icons: Icons.warning,
      );
      user.clear();
    } else {
      setState(() {
        showSpinner = true;
      });
      try {
        //Saving recevier user name locally in Shared Preferences.
        SharedPreferences savePrefs = await SharedPreferences.getInstance();
        savePrefs.setString('RecevierEmail', user.text);

        //getting recevier user name from Shared Preferences.
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var recevierEmail = prefs.getString('RecevierEmail');

        final doc =
            await fireStore.collection('users').document(recevierEmail).get();
        String userName = doc['username'];
        String imageUrl = doc['picture'];
        String biofromDB = doc['bio'];
        int recevierRoomsIndexFromDoc = doc['RoomsIndex'];
        List<dynamic> recevierRoomsIDsFromDoc = doc['chatRoomsIDS'];
        setState(() {
          receiverUserName = userName;
          receiverPicture = imageUrl;
          receiverBio = biofromDB;
          recevierRoomsIndex = recevierRoomsIndexFromDoc;
          recevierRoomsIDs = recevierRoomsIDsFromDoc;
        });

        //saving index of chat rooms from recevier user collection locally in Shared Preferences.
        savePrefs.setInt('RecevierRoomsIndex', recevierRoomsIndex);
        savePrefs.setStringList(
            'RecevierRoomsIDs', recevierRoomsIDs.cast<String>());

        Router().navigator(
            context,
            RecevierProfile(
              user: receiverUserName,
              senderUser: sender,
              picture: receiverPicture,
              bio: receiverBio,
              senderPicture: senderImage,
            ));
        user.clear();
      } catch (e) {
        setState(() {
          showSpinner = false;
        });
        user.clear();
        print(e.toString());
        Warning().errorMessage(
          context,
          title: "Unable to get user's info !",
          message: "Try again later",
          icons: Icons.warning,
        );
      }
    }
  }
}
