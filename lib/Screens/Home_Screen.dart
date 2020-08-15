import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lets_chat/Components/ScaffoldAppbar.dart';

class Home_Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: ScaffoldAppbar(
        body: Container(),
      ),
      onWillPop: _onWillPop,
    );
  }

  Future<bool> _onWillPop() {
    SystemNavigator.pop();
  }
}
