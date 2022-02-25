import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_demo_rushit/services/auth.dart';
import 'package:firebase_chat_demo_rushit/services/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/helper_functions.dart';
import '../widgets/widget.dart';
import 'chat_room_screen.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn({Key? key, required this.toggle}) : super(key: key);


  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailFieldController = TextEditingController();
  TextEditingController passwordFieldController = TextEditingController();

  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();
  QuerySnapshot? snapshotUserInfo;


  bool isLoading = false;

  signInButtonClick() {
    if(formKey.currentState!.validate()){
      setState(() {
        isLoading = true;
      });

      databaseMethods.getUserByUserEmail(emailFieldController.text.trim().toLowerCase())
      .then((value) {
        snapshotUserInfo = value;
        HelperFunctions.saveUserNameInSharedPreference(snapshotUserInfo!.docs[0].get("name"));
      });

      authMethods.signInWithEmailAndPassword(
              emailFieldController.text.trim().toLowerCase(),
              passwordFieldController.text.trim())
          .then((value) {
            if(value != null){
              databaseMethods.getUserByUserEmail(emailFieldController.text.trim().toLowerCase());
              HelperFunctions.saveUserLoggedInSharedPreference(true);
              HelperFunctions.saveUserEmailInSharedPreference(
                  emailFieldController.text.trim().toLowerCase());

              Get.off(() => ChatRoom());
            }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(context),

      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: emailFieldController,
                  style: simpleTextStyle(),
                  decoration: textFieldInputDecoration('Email'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Field is Required!";
                    } else if (!value.contains('@')) {
                      return "Enter valid email!";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: passwordFieldController,
                  style: simpleTextStyle(),
                  decoration: textFieldInputDecoration('Password'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Field is Required!";
                    } else if (value.length < 5) {
                      return "password length more then 5 character!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text('Forgot Password?',
                    style: simpleTextStyle(),
                  ),
                ),

                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    signInButtonClick();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      color: Colors.blue,
                    ),
                    child: const Text(
                        'Sign In',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    color: Colors.white,
                  ),
                  child: const Text(
                    'Sign In with Google',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 17
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have account? ", style: mediumTextStyle()),
                    GestureDetector(
                      onTap: () {
                        widget.toggle();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text("Register Now",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
