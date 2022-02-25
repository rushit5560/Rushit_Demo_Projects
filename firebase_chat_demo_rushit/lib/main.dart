import 'package:firebase_chat_demo_rushit/helper/helper_functions.dart';
import 'package:firebase_chat_demo_rushit/views/chat_room_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'helper/authenticate.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool userIsLoggedIn = false;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedFromSharedPreference()
    .then((value) {
      setState(() {
        userIsLoggedIn = value ?? false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Firebase chat application",
      theme: ThemeData(
        primaryColor: const Color(0xff145C9E),
        scaffoldBackgroundColor: const Color(0xff1F1F1F),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: userIsLoggedIn ?  ChatRoom() : Authenticate(),
    );
  }
}
