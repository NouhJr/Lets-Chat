import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lets_chat/Components/Constants.dart';
import 'package:lets_chat/Components/TextFields.dart';
import 'package:lets_chat/Components/Navigator.dart';
import 'package:lets_chat/Components/FlushBar.dart';
import 'package:lets_chat/Screens/LogIn.dart';
import 'package:lets_chat/Screens/Home_Screen.dart';

class SigUp extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<SigUp> with SingleTickerProviderStateMixin {
  ///******************************ANIMATION*************************************
  AnimationController _controller;
  Animation _animation;
  FocusNode _focusNodeEmail = FocusNode();
  FocusNode _focusNodePassword = FocusNode();
  FocusNode _focusNodeuserName = FocusNode();

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 300.0, end: 200.0).animate(_controller)
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

    _focusNodeuserName.addListener(() {
      if (_focusNodeuserName.hasFocus) {
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
    _focusNodeuserName.dispose();

    super.dispose();
  }

  ///*************************************UI***************************************
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: const Color(0xff163c41),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Stack(
            children: <Widget>[
              //Container to hold 'Sign Up\n Welcome' text.
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
                    //Container to hold 'Sign Up' text.
                    Container(
                      margin: EdgeInsets.only(top: 60, right: 250),
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontFamily: 'Futura PT',
                          fontSize: 35,
                          color: maincolor,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),

                    //Container to hold 'Welcome' text.
                    Container(
                      margin: EdgeInsets.only(top: 5, right: 270),
                      child: Text(
                        'Welcome',
                        style: TextStyle(
                          fontFamily: 'Futura PT',
                          fontSize: 22,
                          color: maincolor,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),

              //Container to hold 'email', 'user name'&'password' text fields and 'Sign Up'&'Already have account?' buttons.
              Container(
                margin: EdgeInsets.only(top: _animation.value, left: 60),
                child: Column(
                  children: [
                    //Container to hold 'email', 'user name'&'password' text fields
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
                          //User name Textfield.
                          Textfield(
                            label: 'User Name',
                            hint: 'Enter your user name',
                            icon: Icons.account_circle,
                            hideText: false,
                            email: false,
                            controller: userName,
                            focusNode: _focusNodeuserName,
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
                    //Container to hold 'Sign Up'&'Already have account?' buttons.
                    Container(
                      margin: EdgeInsets.only(top: 20, left: 20),
                      child: Column(
                        children: [
                          ButtonTheme(
                            minWidth: 120,
                            height: 40,
                            child: RaisedButton(
                              onPressed: () => signUpAction(context),
                              child: Text(
                                'Sign Up',
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
                              Router().navigator(context, LogIn());
                            },
                            child: Text(
                              'Already have account?',
                              style: TextStyle(
                                fontFamily: 'Futura PT',
                                fontSize: 18,
                                color: fontcolor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
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

  ///**********************************BACK END************************************
  Future<bool> _onWillPop() {
    SystemNavigator.pop();
  }

  final email = TextEditingController();
  final password = TextEditingController();
  final userName = TextEditingController();
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
  //Method disposePassword to remove the password controller from tree.
  void disposeuserName() {
    userName.dispose();
  }

  ///**********************************************************************

  //Method 'signUpAction' triggered when the Sign up button is pressed.
  void signUpAction(BuildContext context) async {
    //Check if there is internet connection or not and display message error if not.
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(context,
          title: "No internet connection !",
          message: "Pleas turn on wifi or mobile data",
          icons: Icons.signal_wifi_off);

      //Validate 'email' text field to make sure it's not empty.
    } else if (email.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "Email field can't be empty !",
        message: 'Please enter your email.',
        icons: Icons.warning,
      );

      //Validate 'email' text field to make sure it contains '@'.
    } else if (!email.text.contains('@')) {
      Warning().errorMessage(
        context,
        title: 'Invalid email !',
        message: "Email must contain '@' ",
        icons: Icons.warning,
      );
      email.clear();
      password.clear();
      userName.clear();

      //Validate 'email' text field to make sure it contains '.com'.
    } else if (!email.text.contains('.com')) {
      Warning().errorMessage(
        context,
        title: 'Invalid email !',
        message: "Email must contain '.com' ",
        icons: Icons.warning,
      );
      email.clear();
      password.clear();
      userName.clear();

      //Validate 'password' text field to make sure it's not empty.
    } else if (password.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "Password field can't be empty !",
        message: "Please enter your password",
        icons: Icons.warning,
      );
      email.clear();

      //Validate 'password' text field to make sure it's more than 6 characters in length.
    } else if (password.text.length < 6) {
      Warning().errorMessage(
        context,
        title: "Invalid password length !",
        message: "Password length must be 6 characters or more",
        icons: Icons.warning,
      );
      email.clear();
      userName.clear();
      password.clear();

      //Routing the user to 'Home Screen' and display loading spinner while routing.
    } else {
      setState(() {
        showSpinner = true;
      });

      //Create new user with firebase using 'createUserWithEmailAndPassword' method.
      try {
        final newUser = await auth.createUserWithEmailAndPassword(
            email: email.text, password: password.text);
        await Firestore.instance
            .collection('users')
            .document(newUser.user.uid)
            .setData({
          'username': userName.text,
          'picture':
              'https://firebasestorage.googleapis.com/v0/b/lets-chat-fbd0f.appspot.com/o/NoUser.jpg?alt=media&token=af77c942-d282-400f-8be3-aaa370928cbd',
          'bio': '',
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', email.text);
        if (newUser != null) {
          Router().navigator(context, Home_Screen());
        }
        setState(() {
          showSpinner = false;
        });
      } catch (e) {
        print(e);
      }
    }
  }
}
