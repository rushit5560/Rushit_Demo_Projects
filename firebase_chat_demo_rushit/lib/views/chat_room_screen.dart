import 'package:firebase_chat_demo_rushit/helper/constants.dart';
import 'package:firebase_chat_demo_rushit/helper/helper_functions.dart';
import 'package:firebase_chat_demo_rushit/services/auth.dart';
import 'package:firebase_chat_demo_rushit/views/search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helper/authenticate.dart';


class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  AuthMethods authMethods = AuthMethods();

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameFromSharedPreference() ?? "";
    setState(() {});

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Room Screen'),
        actions: [
          GestureDetector(
            onTap: () {
              authMethods.signOut();
              Get.off(()=> Authenticate());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Icon(Icons.exit_to_app_rounded)),
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(()=> SearchScreen());
        },
        child: const Icon(Icons.search_rounded),
      ),
    );
  }
}
