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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Room'),
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
