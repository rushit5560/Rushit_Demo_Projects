import 'package:firebase_chat_demo_rushit/views/sign_in.dart';
import 'package:firebase_chat_demo_rushit/views/sign_up.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;

  void toggleView() {
    setState(() {
     showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showSignIn) {
      return SignIn(toggle: toggleView);
    } else {
      return SignUp(toggle: toggleView);
    }
  }
}
