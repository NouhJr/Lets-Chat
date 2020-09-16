import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lets_chat/Components/Constants.dart';
import 'package:lets_chat/Components/Navigator.dart';
import 'package:lets_chat/Screens/ChatScreen.dart';

class Room extends StatefulWidget {
  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> {
  //Creating instance of Firestore.
  final fireStore = Firestore.instance;
  //Creating DocumentReference.
  DocumentReference doc;
  //variable 'hasData' of type bool.
  bool hasData = false;

  List<ChatRoomTile> tilesData = [];

  //Method 'createChatRooms' of type void to get create chat rooms.
  void createChatRooms() async {
    //Creating Shared Preferences.
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //getting logged user name & logged user email & logged user rooms ids.
    var loggedUserName = prefs.getString('LoggedUser');
    var loggedUserRoomsIDs = prefs.getStringList('LoggedUserRoomsIDs');

    if (loggedUserRoomsIDs.isNotEmpty) {
      setState(() {
        hasData = true;
      });
    }

    try {
      for (var id in loggedUserRoomsIDs) {
        final doc = await fireStore.collection('Chat Rooms').document(id).get();
        String sender = doc['sender'];
        String recevier = doc['recevier'];
        String senderImage = doc['senderPicture'];
        String recevierImage = doc['recevierPicture'];

        if (loggedUserName == sender) {
          final tile = ChatRoomTile(
            user: recevier,
            image: recevierImage,
          );
          setState(() {
            tilesData.add(tile);
          });
        } else if (loggedUserName == recevier) {
          final tile = ChatRoomTile(
            user: sender,
            image: senderImage,
          );
          setState(() {
            tilesData.add(tile);
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    createChatRooms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return hasData
        ? ListView.builder(
            itemCount: tilesData.length,
            itemBuilder: (context, i) => Column(children: <Widget>[
              tilesData[i],
              Divider(
                color: maincolor,
                indent: 80.0,
                endIndent: 30.0,
                thickness: 0.8,
              ),
            ]),
          )
        : Container();
  }
}

//Class 'ChatRoomTile' to create list tiles with chat room data.
class ChatRoomTile extends StatelessWidget {
  ChatRoomTile({this.user, this.image});
  final String user;
  final String image;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(image),
        radius: 25.0,
      ),
      title: Text(
        user,
        style: TextStyle(
          fontFamily: 'Futura PT',
          fontSize: 22,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: () {
        Router()
            .navigator(context, ChatScreen(userName: user, userImage: image));
      },
    );
  }
}
