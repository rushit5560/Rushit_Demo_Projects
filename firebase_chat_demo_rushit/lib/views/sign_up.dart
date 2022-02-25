import 'package:firebase_chat_demo_rushit/helper/helper_functions.dart';
import 'package:firebase_chat_demo_rushit/services/auth.dart';
import 'package:firebase_chat_demo_rushit/services/database.dart';
import 'package:firebase_chat_demo_rushit/views/chat_room_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/widget.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp({Key? key, required this.toggle}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;

  AuthMethods authMethods = AuthMethods();
  DatabaseMethods databaseMethods = DatabaseMethods();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController usernameFieldController = TextEditingController();
  TextEditingController emailFieldController = TextEditingController();
  TextEditingController passwordFieldController = TextEditingController();

  signMeUp() {
    if(formKey.currentState!.validate()){
      setState(() => isLoading = true); /// Loading Start

      Map<String, String> data = {
        "email": emailFieldController.text.trim().toLowerCase(),
        "name": usernameFieldController.text.trim(),
      };

      authMethods.signUpWithEmailAndPassword(
      emailFieldController.text.toLowerCase().trim(),
      passwordFieldController.text.trim(),
      ).then((value) {

        HelperFunctions.saveUserLoggedInSharedPreference(true);
        HelperFunctions.saveUserEmailInSharedPreference(emailFieldController.text.trim().toLowerCase());
        HelperFunctions.saveUserNameInSharedPreference(usernameFieldController.text.trim());
        
        /// Add User in Firebase Database
        databaseMethods.uploadUserInfo(data);

        Get.off(()=> ChatRoom());
      });

      setState(() => isLoading = false); /// Loading Close
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(context),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: usernameFieldController,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration('Username'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Field is Required!";
                          }
                          return null;
                        },
                      ),
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
                        obscureText: true,
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Text(
                          'Forgot Password?',
                          style: simpleTextStyle(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          signMeUp();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            color: Colors.blue,
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          color: Colors.white,
                        ),
                        child: const Text(
                          'Sign Up with Google',
                          style: TextStyle(color: Colors.black, fontSize: 17),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account? ",
                              style: mediumTextStyle()),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: const Text(
                                "SignIn now",
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
