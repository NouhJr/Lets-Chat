import 'package:flutter/material.dart';
import 'package:lets_chat/Components/Constants.dart';
import 'package:lets_chat/Screens/LogIn.dart';
import 'package:lets_chat/Screens/SignUp.dart';
import 'package:lets_chat/Components/Navigator.dart';
import 'package:lets_chat/Components/FlushBar.dart';

class Main_Screen extends StatelessWidget {
  Main_Screen({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: maincolor,
      body: Stack(
        children: <Widget>[
          Container(),
          Transform.translate(
            offset: Offset(0.0, 286.0),
            child: Container(
              width: 360.0,
              height: 354.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(60.0),
                  topRight: Radius.circular(60.0),
                ),
                color: const Color(0xffffffff),
                border: Border.all(width: 1.0, color: const Color(0xff707070)),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(108.0, 64.0),
            child: Container(
              width: 144.0,
              height: 144.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/conversation.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(7.1, 348.0),
            child: SizedBox(
              width: 347.0,
              child: Text(
                'Welcome to Lets Chat',
                style: TextStyle(
                  fontFamily: 'Futura PT',
                  fontSize: 30,
                  color: maincolor,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            height: 85,
          ),
          //container to hold two buttons.
          Container(
            margin: EdgeInsets.only(right: 45, top: 480),
            child: Column(
              children: [
                //Button bar to align the two buttons side by side.
                ButtonBar(
                  children: [
                    //Log in button
                    ButtonTheme(
                      minWidth: 100,
                      height: 40,
                      child: RaisedButton(
                        onPressed: () {
                          Router().navigator(context, LogIn());
                        },
                        child: Text(
                          'Log In',
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
                    SizedBox(
                      width: 30,
                    ),
                    //Sign up button
                    ButtonTheme(
                      minWidth: 100,
                      height: 40,
                      child: RaisedButton(
                        onPressed: () {
                          Router().navigator(context, SigUp());
                        },
                        child: Text(
                          'Sign Up',
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
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
