import 'package:flutter/material.dart';
import 'package:lets_chat/Components/Constants.dart';
import 'package:lets_chat/Components/TextFields.dart';
import 'package:lets_chat/Components/Navigator.dart';
import 'package:lets_chat/Components/FlushBar.dart';
import 'package:lets_chat/Screens/LogIn.dart';
import 'package:lets_chat/Screens/Home_Screen.dart';

class SigUp extends StatelessWidget {
  SigUp({
    Key key,
  }) : super(key: key);
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmpassword = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff163c41),
      body: Stack(
        children: <Widget>[
          Container(
            height: 130,
            width: 5000,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
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
            margin: EdgeInsets.only(top: 200, left: 30),
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
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 420, left: 80),
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
      resizeToAvoidBottomPadding: false,
    );
  }

  void signUpAction(BuildContext context) {
    if (email.text.isEmpty || !email.text.contains('@')) {
      Warning().errorMessage(context,
          title: 'Email field error !', message: 'Please enter vaild email.');
      email.clear();
    } else if (password.text.isEmpty) {
      Warning().errorMessage(context,
          title: "Password field can't be empty !",
          message: "Please enter your password");
    } else if (confirmpassword.text.isEmpty) {
      Warning().errorMessage(context,
          title: "Confirm Password field can't be empty !",
          message: "Please cofirm your password");
      confirmpassword.clear();
    } else if (confirmpassword.text != password.text) {
      Warning().errorMessage(context,
          title: "Password dosen't match !",
          message: "Please enter the same password");
      confirmpassword.clear();
    } else {
      Router().navigator(context, Home_Screen());
    }
  }
}
