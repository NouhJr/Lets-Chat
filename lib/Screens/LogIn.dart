import 'package:flutter/material.dart';
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
  AnimationController _controller;
  Animation _animation;

  FocusNode _focusNodeEmail = FocusNode();
  FocusNode _focusNodePassword = FocusNode();

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 270.0, end: 160.0).animate(_controller)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: maincolor,
      body: Stack(
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
                Container(
                  margin: EdgeInsets.only(top: 5, right: 140),
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
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 430, left: 120),
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
      resizeToAvoidBottomPadding: false,
    );
  }
}

final email = TextEditingController();
final password = TextEditingController();

//Method disposeEmail to remove the email controller from tree.
void disposeEmail() {
  email.dispose();
  //super.dispose();
}

///**********************************************************************

//Method disposePassword to remove the password controller from tree.
void disposePassword() {
  password.dispose();
  //super.dispose();
}

///**********************************************************************

void logInAction(BuildContext context) {
  if (email.text.isEmpty) {
    Warning().errorMessage(context,
        title: "Email field can't be empty !",
        message: 'Please enter your email.');
    email.clear();
  } else if (!email.text.contains('@')) {
    Warning().errorMessage(context,
        title: 'Email field error !', message: 'Please enter vaild email.');
  } else if (password.text.isEmpty) {
    Warning().errorMessage(context,
        title: "Password field can't be empty !",
        message: "Please enter your password");
  } else {
    Router().navigator(context, Home_Screen());
  }
}
