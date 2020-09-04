import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity/connectivity.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:lets_chat/Components/ScaffoldAppbar.dart';
import 'package:lets_chat/Components/Constants.dart';
import 'package:lets_chat/Components/FlushBar.dart';

class Editbio extends StatefulWidget {
  @override
  _EditbioState createState() => _EditbioState();
}

class _EditbioState extends State<Editbio> {
  final fireStore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  final bio = TextEditingController();

  void bioDispose() {
    bio.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ScaffoldAppbar(
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Center(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 15, bottom: 10),
                  child: Text(
                    'Edit Bio',
                    style: TextStyle(
                      fontFamily: 'Futura PT',
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(10),
                  elevation: 1.0,
                  color: maincolor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      maxLines: 8,
                      decoration: InputDecoration.collapsed(
                          hintText: "Enter your bio",
                          hintStyle: TextStyle(
                            fontFamily: 'Futura PT',
                            fontSize: 15,
                            color: fontcolor,
                          )),
                      style: TextStyle(
                        fontSize: 18,
                        color: fontcolor,
                      ),
                      cursorColor: fontcolor,
                      controller: bio,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: ButtonTheme(
                    minWidth: 85,
                    height: 30,
                    child: RaisedButton(
                      onPressed: changeBio,
                      child: Text(
                        'Submit',
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
      ),
    );
  }

  Future changeBio() async {
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
      try {
        final user = await _auth.currentUser();
        if (user != null) {
          await fireStore.collection('users').document(user.email).updateData({
            'bio': bio.text,
          });
        }
        Warning().errorMessage(context,
            title: "Biography updated !",
            message: "updated successfully",
            icons: Icons.done);
      } catch (e) {
        Warning().errorMessage(context,
            title: "unable to update bio !",
            message: "Pleas try again later",
            icons: Icons.error);
      }
    }
  }
}
