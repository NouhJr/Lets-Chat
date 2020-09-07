import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lets_chat/Components/Constants.dart';
import 'package:lets_chat/Components/Navigator.dart';
import 'package:lets_chat/Screens/Home_Screen.dart';

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

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 660.0, end: 370.0).animate(_controller)
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: maincolor,
            leading: CircleAvatar(
              backgroundImage: NetworkImage(picture),
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
                  image: AssetImage('assets/chatbackground.png'),
                  fit: BoxFit.fill,
                  width: 1080.0,
                ),
              ),

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
                        cursorColor: Colors.grey,
                        focusNode: _focusNodeMessage,
                      ),
                    ),
                    //Container to hold send button.
                    Container(
                      margin: EdgeInsets.only(left: 15),
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
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onWillPop: null);
  }

  Future<bool> _onWillPop() {
    SystemNavigator.pop()
        .then((value) => Router().navigator(context, Home_Screen()));
  }
}
