import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:connectivity/connectivity.dart';
import 'package:lets_chat/Components/Constants.dart';
import 'package:lets_chat/Components/Navigator.dart';
import 'package:lets_chat/Components/FlushBar.dart';
import 'package:lets_chat/Screens/LogIn.dart';
import 'package:lets_chat/Screens/SignUp.dart';

class Main_Screen extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<Main_Screen> {
  ///**********************************UI*************************************
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: maincolor,
        body: Stack(
          children: <Widget>[
            //Container to hold app icon.
            Container(
              margin: EdgeInsets.only(top: 130, left: 140),
              width: 180.0,
              height: 180.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/phone.png'),
                  fit: BoxFit.fill,
                  scale: 20.0,
                ),
              ),
            ),

            //Container to hold 'Welcome to lets chat' text, login button and signUp button.
            Container(
              margin: EdgeInsets.only(top: 420),
              width: 445.0,
              height: 400.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(60.0),
                ),
                color: const Color(0xffffffff),
                border: Border.all(width: 1.0, color: const Color(0xff707070)),
              ),
            ),

            //Container to hold 'Welcome to lets chat' text.
            Container(
              margin: EdgeInsets.only(top: 480, left: 50),
              child: TypewriterAnimatedTextKit(
                text: ['Welcome to Lets Chat'],
                textStyle: TextStyle(
                  fontFamily: 'Futura PT',
                  fontSize: 30,
                  color: maincolor,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
                repeatForever: true,
                speed: Duration(milliseconds: 300),
              ),
            ),

            //container to hold two buttons.
            Container(
              margin: EdgeInsets.only(right: 10, top: 600, left: 80),
              child: Column(
                children: [
                  //Log in button.
                  ButtonTheme(
                    minWidth: 250,
                    height: 40,
                    child: RaisedButton(
                      onPressed: () => destination(LogIn()),
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

                  //Sign up button
                  ButtonTheme(
                    minWidth: 250,
                    height: 40,
                    child: RaisedButton(
                      onPressed: () => destination(SigUp()),
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
            ),
          ],
        ),
      ),
      onWillPop: _onWillPop,
    );
  }

  ///**************************************BACK END*****************************************

  //Method 'destination' trrigered when 'log in' or 'sign up' button pressed.
  void destination(var dest) async {
    //Check if there is internet connection or not and display message error if not.
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(context,
          title: "No internet connection !",
          message: "Pleas turn on wifi or mobile data",
          icons: Icons.signal_wifi_off);
    }
    //Routing the user to 'log in screen' or to 'sign up screen' based on the button the user pressed.
    else {
      Router().navigator(context, dest);
    }
  }

  Future<bool> _onWillPop() {
    SystemNavigator.pop();
  }
}
