import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:lets_chat/Components/Constants.dart';
import 'package:lets_chat/Components/TextFields.dart';
import 'package:lets_chat/Components/Navigator.dart';
import 'package:lets_chat/Components/FlushBar.dart';
import 'package:lets_chat/Screens/SignUp.dart';
import 'package:lets_chat/Screens/Home_Screen.dart';

class LogIn extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<LogIn> with SingleTickerProviderStateMixin {
  ///*******************************ANIMATION**********************************
  AnimationController _controller;
  Animation _animation;
  FocusNode _focusNodeEmail = FocusNode();
  FocusNode _focusNodePassword = FocusNode();

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 350.0, end: 270.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _focusNodeEmail.addListener(() {
      if (_focusNodeEmail.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });

    _focusNodePassword.addListener(() {
      if (_focusNodePassword.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();

    super.dispose();
  }

  ///****************************UI****************************************

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: maincolor,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Stack(
            children: <Widget>[
              //Container to hold 'Log In\n Welcome back' text.
              Container(
                height: 150,
                width: 1000,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    //Container to hold 'Log In' text.
                    Container(
                      margin: EdgeInsets.only(top: 60, right: 250),
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Log In',
                        style: TextStyle(
                          fontFamily: 'Futura PT',
                          fontSize: 40,
                          color: maincolor,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),

                    //Container to hold 'Welcome' text.
                    Container(
                      margin: EdgeInsets.only(top: 5, right: 190),
                      child: Text(
                        'Welcome back',
                        style: TextStyle(
                          fontFamily: 'Futura PT',
                          fontSize: 25,
                          color: maincolor,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),

              //Container to hold 'email'&'password' text fields and 'Log in'&'new user?' buttons.
              Container(
                margin: EdgeInsets.only(top: _animation.value, left: 60),
                child: Column(
                  children: [
                    //Container to hold 'email'&'password' text fields.
                    Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          //Email Textfield.
                          Textfield(
                            label: 'Email',
                            hint: 'Enter your email',
                            icon: Icons.email,
                            hideText: false,
                            email: true,
                            controller: email,
                            focusNode: _focusNodeEmail,
                          ),

                          ///****************************************************************************/
                          //Password Textfield.
                          Textfield(
                            label: 'Password',
                            hint: 'Enter your password',
                            icon: Icons.vpn_key,
                            hideText: true,
                            email: false,
                            controller: password,
                            focusNode: _focusNodePassword,
                          ),
                        ],
                      ),
                    ),

                    //Container to hold Log in button & 'new user?' button.
                    Container(
                      margin: EdgeInsets.only(top: 20, left: 20), //430
                      child: Column(
                        children: [
                          ButtonTheme(
                            minWidth: 120,
                            height: 40,
                            child: RaisedButton(
                              onPressed: () => logInAction(context),
                              child: Text(
                                'Log In',
                                style: TextStyle(
                                  fontFamily: 'Futura PT',
                                  fontSize: 22,
                                  color: maincolor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)),
                              color: fontcolor,
                            ),
                          ),
                          FlatButton(
                              onPressed: () {
                                Router().navigator(context, SigUp());
                              },
                              child: Text(
                                'New User?',
                                style: TextStyle(
                                  fontFamily: 'Futura PT',
                                  fontSize: 18,
                                  color: fontcolor,
                                ),
                                textAlign: TextAlign.center,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        resizeToAvoidBottomPadding: false,
      ),
      onWillPop: _onWillPop,
    );
  }

  ///******************************BACK END*******************************
  Future<bool> _onWillPop() {
    SystemNavigator.pop();
  }

  final email = TextEditingController();
  final password = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool showSpinner = false;

  //Method disposeEmail to remove the email controller from tree.
  void disposeEmail() {
    email.dispose();
  }

  ///**********************************************************************

  //Method disposePassword to remove the password controller from tree.
  void disposePassword() {
    password.dispose();
  }

  ///**********************************************************************

  //Method 'logInAction' triggered when the Log in button is pressed.
  void logInAction(BuildContext context) async {
    //Check if there is internet connection or not and display message error if not.
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(context,
          title: "No internet connection !",
          message: "Pleas turn on wifi or mobile data",
          icons: Icons.signal_wifi_off);
    }
    //Validate 'email' text field to make sure it's not empty.
    else if (email.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "Email field can't be empty !",
        message: 'Please enter your email.',
        icons: Icons.warning,
      );

      //Validate 'password' text field to make sure it's not empty.
    } else if (password.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "Password field can't be empty !",
        message: "Please enter your password",
        icons: Icons.warning,
      );
      email.clear();
      //Routing the user to 'Home Screen' and display loading spinner while routing.
    } else {
      setState(() {
        showSpinner = true;
      });
      //Sign the user in with firebase using 'signInWithEmailAndPassword' method.
      try {
        final newUser = await auth.signInWithEmailAndPassword(
            email: email.text, password: password.text);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', email.text);
        if (newUser != null) {
          Router().navigator(context, Home_Screen());
        }
        setState(() {
          showSpinner = false;
        });
      } catch (e) {
        setState(() {
          showSpinner = false;
        });

        //Showing error message if log in process failed.
        Warning().errorMessage(
          context,
          title: "Login failed !",
          message: "Email or password is wrong.",
          icons: Icons.warning,
        );
        email.clear();
        password.clear();
      }
    }
  }
}
