import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:wallpaperapp/config/config.dart';
import 'package:wallpaperapp/pages/homepage.dart';
import 'package:wallpaperapp/pages/sign_in_screen.dart';

void main(){
  
  runApp(MainApp());
  
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Wallpaper App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: primaryColor,
          secondaryHeaderColor: secondaryColor,
          brightness: Brightness.dark
      ),
      home: Main(),
    );
  }
}


class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {

  final FirebaseAuth _auth = FirebaseAuth.instance;


  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
//    _firebaseMessaging.getToken().then((String token) {
//      assert(token != null);
//      setState(() {
//        _homeScreenText = "Push Messaging token: $token";
//      });
//      print(_homeScreenText);
//    });
  }

  @override
  Widget build(BuildContext context) {

    // Awesome StreamBuilder

    return StreamBuilder(
      stream: _auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<FirebaseUser> snapshot){
          if(snapshot.hasData){
            FirebaseUser user = snapshot.data;
            if(user!=null){
              return HomePage();
            }
            else{
              return SignInScreen();
            }
          }
          return SignInScreen();
      },
    );
  }
}
