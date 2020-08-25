import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lets_chat/Components/ScaffoldAppbar.dart';
import 'package:lets_chat/Components/Constants.dart';
import 'package:lets_chat/Components/Navigator.dart';
import 'package:lets_chat/Screens/ImageSelection.dart';

class Myaccount extends StatefulWidget {
  Myaccount({this.user, this.picture});
  final String user;
  final File picture;
  @override
  _MyaccountState createState() =>
      _MyaccountState(user: user, picture: picture);
}

class _MyaccountState extends State<Myaccount> {
  _MyaccountState({this.user, this.picture});
  final String user;
  final File picture;
  String image = 'assets/NoUser.jpg';
  File _image;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: ScaffoldAppbar(
        body: Stack(
          children: [
            Container(
              height: 200,
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: subMainColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 95, left: 105),
              decoration: BoxDecoration(
                border: Border.all(
                  color: maincolor,
                  width: 5,
                ),
                shape: BoxShape.circle,
              ),
              child: GestureDetector(
                child: new CircleAvatar(
                  radius: 70,
                  backgroundImage: (picture != null)
                      ? FileImage(picture)
                      : AssetImage(image),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 280, left: 20),
              child: Text(
                'Email: $user',
                style: TextStyle(
                  fontFamily: 'Futura PT',
                  fontSize: 22,
                  color: Color(0xf0000000),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 380, left: 20),
              child: Text(
                'Change picture:',
                style: TextStyle(
                  fontFamily: 'Futura PT',
                  fontSize: 22,
                  color: Color(0xf0000000),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 370, left: 185),
              child: ButtonTheme(
                minWidth: 85,
                height: 30,
                child: RaisedButton(
                  onPressed: chooseFile,
                  child: Text(
                    'Choose image',
                    style: TextStyle(
                      fontFamily: 'Futura PT',
                      fontSize: 18,
                      color: fontcolor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  color: maincolor,
                ),
              ),
            ),
          ],
        ),
      ),
      onWillPop: _onWillPop,
    );
  }

  Future<bool> _onWillPop() {
    SystemNavigator.pop();
  }

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
    Router().navigator(
        context,
        Selection(
          picture: _image,
          user: user,
        ));
  }
}
