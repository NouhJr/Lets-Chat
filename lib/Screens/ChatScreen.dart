import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:lets_chat/Components/Constants.dart';
import 'package:lets_chat/Components/Navigator.dart';
import 'package:lets_chat/Components/FlushBar.dart';
import 'package:lets_chat/Screens/Home_Screen.dart';

//Create instance of Firestore.
final fireStore = Firestore.instance;

//Create variables to store sender & recevier and List to store logged user chat rooms.
List<String> loggedUserRooms;
String loggedInUser;
String recevierUser;
int msgID = -1;

class ChatScreen extends StatefulWidget {
  ChatScreen({this.userName, this.userImage});
  final String userName;
  final String userImage;

  @override
  _ChatScreenState createState() =>
      _ChatScreenState(user: userName, picture: userImage);
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  _ChatScreenState({this.user, this.picture});
  final String user;
  final String picture;

  ///**************************ANIMATION*************************************
  AnimationController _controller;
  Animation _animation;
  FocusNode _focusNodeMessage = FocusNode();

  @override
  void initState() {
    super.initState();

    getSenderAndRecevierData();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 660.0, end: 420.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _focusNodeMessage.addListener(() {
      if (_focusNodeMessage.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNodeMessage.dispose();
    super.dispose();
  }

  void getSenderAndRecevierData() async {
    //Create instance of Shared Preferences.
    SharedPreferences getPrefs = await SharedPreferences.getInstance();
    //Getting logged logged user chat rooms from Shared Preferences.
    loggedUserRooms = getPrefs.getStringList('LoggedUserRoomsIDs');
    var currentUser = getPrefs.getString('LoggedUser');

    for (var id in loggedUserRooms) {
      final roomsIDSDoc =
          await fireStore.collection('Chat Rooms').document(id).get();
      String sender = roomsIDSDoc['sender'];
      String recevier = roomsIDSDoc['recevier'];

      if (currentUser == sender) {
        setState(() {
          loggedInUser = sender;
          recevierUser = recevier;
        });
      } else if (currentUser == recevier) {
        setState(() {
          loggedInUser = recevier;
          recevierUser = sender;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      gestures: [
        GestureType.onTap,
        GestureType.onPanUpdateDownDirection,
      ],
      child: WillPopScope(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: maincolor,
              leading: CircleAvatar(
                backgroundImage: NetworkImage(picture),
                radius: 15,
              ),
              title: Text(
                user,
                style: TextStyle(
                  fontFamily: 'Futura PT',
                  fontSize: 22,
                  color: fontcolor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            body: Stack(
              children: [
                //Container to hold background image.
                Container(
                  child: Image(
                    image: AssetImage('assets/1288076.jpg'),
                    fit: BoxFit.fill,
                    width: 1080.0,
                  ),
                ),

                //Message Stream to display messages from DB on the screen.
                MessagesStream(),

                //Container to hold message textfield & send button side by side.
                Container(
                  width: 500,
                  margin: EdgeInsets.only(
                      top: _animation.value, left: 10, right: 10, bottom: 5),

                  //Row to align message textfield & send button side by side.
                  child: Row(
                    children: [
                      //Container to hold text field.
                      Container(
                        width: 320,
                        decoration: BoxDecoration(
                          color: maincolor,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child:
                            //Message text field.
                            TextField(
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Futura PT',
                            color: fontcolor,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Type a message',
                            hintStyle: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Futura PT',
                              color: fontcolor,
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
                          cursorColor: fontcolor,
                          focusNode: _focusNodeMessage,
                          controller: messageText,
                        ),
                      ),
                      //Container to hold send button.
                      Container(
                        padding: EdgeInsets.only(left: 4),
                        margin: EdgeInsets.only(left: 0.5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: maincolor,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.send,
                            size: 25.0,
                            color: fontcolor,
                          ),
                          onPressed: sendMessage,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          onWillPop: _onWillPop),
    );
  }

  Future<bool> _onWillPop() {
    Router().navigator(context, Home_Screen());
  }

  //TextEditingController to get message text from message text field.
  final messageText = TextEditingController();

  //Creat DocumentReference
  DocumentReference msgDoc;

  //Method sendMessage to store messages in fireStore.
  void sendMessage() async {
    //Check if there is internet connection or not and display message error if not.
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(context,
          title: "No internet connection !",
          message: "Pleas turn on wifi or mobile data",
          icons: Icons.signal_wifi_off);

      //Validate 'message' text field to make sure it's not empty.
    } else if (messageText.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "No message to send !",
        message: 'Please enter a message.',
        icons: Icons.warning,
      );
    } else {
      try {
        //Getting messages counter from fire store.
        final doc =
            await fireStore.collection('messages').document('MsgCounter').get();
        int counter = doc['IDCounter'];
        setState(() {
          msgID = counter;
        });

        //Creating 'messages' collection in fireStore & save data in it.
        final msgDoc = Firestore.instance.collection('messages').document();
        msgDoc.setData({
          'sender': loggedInUser,
          'recevier': recevierUser,
          'messageText': messageText.text,
          'ID': msgID + 1,
        });

        //Clearing data from text field after sending the message.
        messageText.clear();

        //Updating messages counter value in fire store.
        await fireStore
            .collection('messages')
            .document('MsgCounter')
            .updateData({
          'IDCounter': msgID + 1,
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }
}

///**********************************************************************************************************/
///**********************************************************************************************************/

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: fireStore
          .collection("messages")
          .orderBy('ID', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.documents.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final msgText = message.data['messageText'];
          final msgSender = message.data['sender'];
          final msgRecevier = message.data['recevier'];

          if (loggedInUser == msgSender && recevierUser == msgRecevier) {
            final messageBubble = MessageBubble(
              text: msgText,
              isMe: true,
            );
            messageBubbles.add(messageBubble);
          } else if (loggedInUser == msgRecevier && recevierUser == msgSender) {
            final messageBubble = MessageBubble(
              text: msgText,
              isMe: false,
            );
            messageBubbles.add(messageBubble);
          }
        }

        return ListView(
          reverse: true,
          padding: EdgeInsets.symmetric(vertical: 60),
          children: messageBubbles,
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.text, this.isMe});

  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            borderRadius: isMe
                ? BorderRadius.all(Radius.circular(15.0))
                : BorderRadius.all(Radius.circular(15.0)),
            elevation: 5.0,
            color: isMe ? Color(0xff163c41) : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black,
                  fontSize: 18.0,
                  fontFamily: 'Futura PT',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
