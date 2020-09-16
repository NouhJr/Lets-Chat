import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:lets_chat/Components/Constants.dart';
import 'package:lets_chat/Components/Navigator.dart';
import 'package:lets_chat/Components/FlushBar.dart';
import 'package:lets_chat/Screens/ReceiverProfile.dart';

//Create instance of fire store.
final fireStore = Firestore.instance;

class SearchedUsers extends StatefulWidget {
  SearchedUsers({this.query});
  final String query;
  @override
  _SearchedUsersState createState() => _SearchedUsersState(searchQuery: query);
}

class _SearchedUsersState extends State<SearchedUsers> {
  _SearchedUsersState({this.searchQuery});
  final String searchQuery;

  //Method 'initState' to initialize the state of this class.
  @override
  void initState() {
    super.initState();
    searchByEmail();
  }

  //List 'tiles' of type 'SearchedUserTiles' to hold SearchedUserTiles.
  List<SearchedUserTiles> tiles = [];

  //Method 'searchByEmail' to get searched user data from fire store.
  void searchByEmail() async {
    try {
      final doc =
          await fireStore.collection('users').document(searchQuery).get();
      String userName = doc['username'];
      String imageUrl = doc['picture'];

      final tile = SearchedUserTiles(
        user: userName,
        image: imageUrl,
        email: searchQuery,
      );
      setState(() {
        tiles.add(tile);
      });
      SharedPreferences prfs = await SharedPreferences.getInstance();
      prfs.setStringList('RecentSearch', tiles.cast<String>());
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: tiles.length,
      itemBuilder: (context, i) => Column(children: <Widget>[
        tiles[i],
      ]),
    );
  }
}

//Class 'SearchedUserTiles' to create list tiles with searched user's data.
class SearchedUserTiles extends StatefulWidget {
  SearchedUserTiles({
    this.user,
    this.image,
    this.email,
  });
  final String user;
  final String image;
  final String email;

  @override
  _SearchedUserTilesState createState() => _SearchedUserTilesState(
        searchedUser: user,
        searchedUserImage: image,
        searchedUserEmail: email,
      );
}

class _SearchedUserTilesState extends State<SearchedUserTiles> {
  _SearchedUserTilesState({
    this.searchedUser,
    this.searchedUserImage,
    this.searchedUserEmail,
  });
  final String searchedUser;
  final String searchedUserImage;
  final String searchedUserEmail;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(searchedUserImage),
        radius: 25.0,
      ),
      title: Text(
        searchedUser,
        style: TextStyle(
          fontFamily: 'Futura PT',
          fontSize: 22,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTapAction,
    );
  }

  String receiverUserName = '';
  String receiverPicture =
      "https://firebasestorage.googleapis.com/v0/b/lets-chat-fbd0f.appspot.com/o/NoUser.jpg?alt=media&token=bbe8c9eb-9439-4fc2-9b5e-ef41a6aafff7";
  String receiverBio = '';
  int recevierRoomsIndex = -1;
  List<dynamic> recevierRoomsIDs = [];

  void onTapAction() async {
    //Check if there is internet connection or not and display message error if not.
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      Warning().errorMessage(context,
          title: "No internet connection !",
          message: "Pleas turn on wifi or mobile data",
          icons: Icons.signal_wifi_off);
    } else {
      try {
        //Creating instances of SharedPreferences.
        SharedPreferences savePrefs = await SharedPreferences.getInstance();
        SharedPreferences prefs = await SharedPreferences.getInstance();

        //getting recevier user name from Shared Preferences.
        var sender = prefs.getString('LoggedUser');
        var senderImage = prefs.getString('LoggedUserImage');

        final doc = await fireStore
            .collection('users')
            .document(searchedUserEmail)
            .get();
        String userName = doc['username'];
        String imageUrl = doc['picture'];
        String biofromDB = doc['bio'];
        int recevierRoomsIndexFromDoc = doc['RoomsIndex'];
        List<dynamic> recevierRoomsIDsFromDoc = doc['chatRoomsIDS'];

        setState(() {
          receiverUserName = userName;
          receiverPicture = imageUrl;
          receiverBio = biofromDB;
          recevierRoomsIndex = recevierRoomsIndexFromDoc;
          recevierRoomsIDs = recevierRoomsIDsFromDoc;
        });

        //saving index of chat rooms from recevier user collection locally in Shared Preferences.
        savePrefs.setInt('RecevierRoomsIndex', recevierRoomsIndex);
        savePrefs.setStringList(
            'RecevierRoomsIDs', recevierRoomsIDs.cast<String>());

        Router().navigator(
            context,
            RecevierProfile(
              user: receiverUserName,
              senderUser: sender,
              picture: receiverPicture,
              bio: receiverBio,
              senderPicture: senderImage,
            ));
      } catch (e) {
        print(e.toString());
        Warning().errorMessage(
          context,
          title: "Unable to get user's info !",
          message: "Try again later",
          icons: Icons.warning,
        );
      }
    }
  }
}
