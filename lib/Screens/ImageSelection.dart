import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:connectivity/connectivity.dart';
import 'package:lets_chat/Components/Constants.dart';
import 'package:lets_chat/Components/FlushBar.dart';
import 'package:lets_chat/Components/Navigator.dart';
import 'package:lets_chat/Screens/Account.dart';

class Selection extends StatefulWidget {
  Selection({@required this.picture, this.user});
  final File picture;
  final String user;

  @override
  _SelectionState createState() =>
      _SelectionState(picture: picture, user: user);
}

class _SelectionState extends State<Selection> {
  _SelectionState({@required this.picture, this.user});
  final File picture;
  final String user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Image selection',
          style: TextStyle(
            fontFamily: 'Futura PT',
            fontSize: 22,
            color: fontcolor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: maincolor,
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Center(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 15, bottom: 10),
                child: Text(
                  'Selected image',
                  style: TextStyle(
                    fontFamily: 'Futura PT',
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              picture != null
                  ? Image.file(
                      picture,
                      height: 150,
                    )
                  : Container(height: 150),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: ButtonTheme(
                  minWidth: 85,
                  height: 30,
                  child: RaisedButton(
                    onPressed: uploadFile,
                    child: Text(
                      'Upload image',
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
      ),
    );
  }

  bool showSpinner = false;
  Future uploadFile() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(context,
          title: "No internet connection !",
          message: "Pleas turn on wifi or mobile data",
          icons: Icons.signal_wifi_off);
    } else {
      setState(() {
        showSpinner = true;
      });
      String fileName = Path.basename(picture.path);
      StorageReference storageReference =
          FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = storageReference.putFile(picture);
      await uploadTask.onComplete;

      Router().navigator(
          context,
          Myaccount(
            picture: picture,
            user: user,
          ));
      setState(() {
        showSpinner = false;
      });
    }
  }
}
