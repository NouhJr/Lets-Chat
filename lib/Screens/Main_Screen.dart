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
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
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
                    topRight: Radius.circular(60.0),
                  ),
                  color: const Color(0xffffffff),
                  border:
                      Border.all(width: 1.0, color: const Color(0xff707070)),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(108.0, 64.0),
              child: Container(
                width: 120.0,
                height: 120.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/chat.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(7.1, 348.0),
              child: SizedBox(
                width: 347.0,
                child: TypewriterAnimatedTextKit(
                  text: ['Welcome to Lets Chat'],
                  textStyle: TextStyle(
                    fontFamily: 'Futura PT',
                    fontSize: 30,
                    color: maincolor,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                  repeatForever: true,
                  speed: Duration(milliseconds: 300),
                ),
              ),
            ),
            SizedBox(
              height: 85,
            ),
            //container to hold two buttons.
            Container(
              margin: EdgeInsets.only(right: 10, top: 450, left: 60),
              child: Column(
                children: [
                  //Button bar to align the two buttons side by side.
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

  void destination(var dest) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(context,
          title: "No internet connection !",
          message: "Pleas turn on wifi or mobile data",
          icons: Icons.signal_wifi_off);
    } else {
      Router().navigator(context, dest);
    }
  }

  Future<bool> _onWillPop() {
    SystemNavigator.pop();
  }
}
