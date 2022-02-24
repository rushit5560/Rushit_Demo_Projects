import 'package:flutter/material.dart';

import '../widgets/widget.dart';

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
                ),
                TextFormField(
                  controller: passwordFieldController,
                  style: simpleTextStyle(),
                  decoration: textFieldInputDecoration('Password'),
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
                Container(
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
