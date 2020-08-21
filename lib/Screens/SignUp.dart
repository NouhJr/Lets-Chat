import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
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
  AnimationController _controller;
  Animation _animation;

  FocusNode _focusNodeEmail = FocusNode();
  FocusNode _focusNodePassword = FocusNode();
  FocusNode _focusNodeConfirmpassword = FocusNode();

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 270.0, end: 140.0).animate(_controller)
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

    _focusNodeConfirmpassword.addListener(() {
      if (_focusNodeConfirmpassword.hasFocus) {
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
    _focusNodeConfirmpassword.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: const Color(0xff163c41),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Stack(
            children: <Widget>[
              Container(
                height: 130,
                width: 5000,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 45, right: 200),
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
                    Container(
                      margin: EdgeInsets.only(top: 5, right: 220),
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
              Container(
                margin: EdgeInsets.only(top: _animation.value, left: 30),
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

                    ///****************************************************************************/
                    //ConfirmPassword Textfield.
                    Textfield(
                      label: 'Confirm Password',
                      hint: 'Enter your password again',
                      icon: Icons.vpn_key,
                      hideText: true,
                      email: false,
                      controller: confirmpassword,
                      focusNode: _focusNodeConfirmpassword,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 490, left: 80),
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
        resizeToAvoidBottomPadding: false,
      ),
      onWillPop: _onWillPop,
    );
  }

  Future<bool> _onWillPop() {
    SystemNavigator.pop();
  }

  final email = TextEditingController();
  final password = TextEditingController();
  final confirmpassword = TextEditingController();
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
  void disposeconfirmPassword() {
    confirmpassword.dispose();
  }

  ///**********************************************************************

  void signUpAction(BuildContext context) async {
    if (email.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "Email field can't be empty !",
        message: 'Please enter your email.',
        icons: Icons.warning,
      );
    } else if (!email.text.contains('@')) {
      Warning().errorMessage(
        context,
        title: 'Invalid email !',
        message: "Email must contain '@' ",
        icons: Icons.warning,
      );
      email.clear();
      password.clear();
      confirmpassword.clear();
    } else if (!email.text.contains('.com')) {
      Warning().errorMessage(
        context,
        title: 'Invalid email !',
        message: "Email must contain '.com' ",
        icons: Icons.warning,
      );
      email.clear();
      password.clear();
      confirmpassword.clear();
    } else if (password.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "Password field can't be empty !",
        message: "Please enter your password",
        icons: Icons.warning,
      );
      email.clear();
    } else if (password.text.length < 6) {
      Warning().errorMessage(
        context,
        title: "Invalid password length !",
        message: "Password length must be 6 characters or more",
        icons: Icons.warning,
      );
      password.clear();
    } else if (confirmpassword.text.isEmpty) {
      Warning().errorMessage(
        context,
        title: "Confirm Password field can't be empty !",
        message: "Please cofirm your password",
        icons: Icons.warning,
      );
    } else if (confirmpassword.text != password.text) {
      Warning().errorMessage(
        context,
        title: "Password dosen't match !",
        message: "Please enter the same password",
        icons: Icons.warning,
      );
      confirmpassword.clear();
    } else {
      setState(() {
        showSpinner = true;
      });
      try {
        final newUser = await auth.createUserWithEmailAndPassword(
            email: email.text, password: password.text);
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
