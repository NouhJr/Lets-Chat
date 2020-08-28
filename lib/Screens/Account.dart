import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:lets_chat/Components/ScaffoldAppbar.dart';
import 'package:lets_chat/Components/Constants.dart';
import 'package:lets_chat/Components/Navigator.dart';
import 'package:lets_chat/Screens/EditBio.dart';
import 'package:lets_chat/Screens/ImageSelection.dart';

class Myaccount extends StatefulWidget {
  Myaccount({this.user, this.picture, this.bio});
  final String user;
  final String picture;
  final String bio;
  @override
  _MyaccountState createState() =>
      _MyaccountState(user: user, picture: picture, bio: bio);
}

class _MyaccountState extends State<Myaccount> {
  _MyaccountState({this.user, this.picture, this.bio});
  final String user;
  final String picture;
  final String bio;

  bool showSpinner = false;
  File _image;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: ScaffoldAppbar(
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Stack(
            children: [
              //Image holder container.
              Container(
                height: 200,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: subMainColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),

              //Image container.
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
                      radius: 70, backgroundImage: NetworkImage(picture)),
                ),
              ),

              //Change image button container.
              Container(
                margin: EdgeInsets.only(top: 210, left: 220),
                child: ButtonTheme(
                  child: IconButton(
                      icon: Icon(
                        FontAwesomeIcons.camera,
                        size: 30.0,
                        color: maincolor,
                      ),
                      onPressed: chooseFile),
                ),
              ),

              //Username container.
              Container(
                margin: EdgeInsets.only(top: 260, left: 110),
                child: Text(
                  user,
                  style: TextStyle(
                    fontFamily: 'Futura PT',
                    fontSize: 28,
                    color: Color(0xf0000000),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              //Edit bio button container.
              Container(
                margin: EdgeInsets.only(top: 315, left: 100),
                child: IconButton(
                    icon: Icon(
                      FontAwesomeIcons.pen,
                      size: 20.0,
                      color: maincolor,
                    ),
                    onPressed: editBio),
              ),

              //Bio label container.
              Container(
                margin: EdgeInsets.only(top: 320, left: 20),
                child: Text(
                  'Bio:',
                  style: TextStyle(
                    fontFamily: 'Futura PT',
                    fontSize: 28,
                    color: Color(0xf0000000),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              //Bio container.
              Container(
                margin: EdgeInsets.only(top: 355, left: 20),
                child: Text(
                  bio,
                  style: TextStyle(
                    fontFamily: 'Futura PT',
                    fontSize: 21,
                    color: Color(0xf0000000),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
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
      ),
    );
  }

  void editBio() {
    Router().navigator(context, Editbio());
  }
}
