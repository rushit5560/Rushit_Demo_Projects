import 'package:firebase_chat_demo_rushit/helper/constants.dart';
import 'package:firebase_chat_demo_rushit/helper/helper_functions.dart';
import 'package:firebase_chat_demo_rushit/services/auth.dart';
import 'package:firebase_chat_demo_rushit/services/database.dart';
import 'package:firebase_chat_demo_rushit/views/conversation_screen.dart';
import 'package:firebase_chat_demo_rushit/views/search.dart';
import 'package:firebase_chat_demo_rushit/widgets/widget.dart';
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
  DatabaseMethods databaseMethods = DatabaseMethods();

  Stream? chatRoomsStream;

  Widget chatRoomList() {
    return StreamBuilder<dynamic>(
      stream: chatRoomsStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data!.documents.length,
          itemBuilder: (context, index){
            return ChatRoomTile(
              userName: snapshot.data.documents[index].data["chatroomId"]
              .toString().replaceAll("_", "").replaceAll(Constants.myName, ""),
              chatRoomId: snapshot.data.documents[index].data["chatroomId"],
            );
          },
        ) : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameFromSharedPreference() ?? "";
    databaseMethods.getChatRooms(Constants.myName).then((value){
      setState(() {
        chatRoomsStream = value;
      });
    });
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

      body: chatRoomList(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(()=> SearchScreen());
        },
        child: const Icon(Icons.search_rounded),
      ),
    );
  }
}


class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomTile({Key? key, required this.userName, required this.chatRoomId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(()=> ConversationScreen(chatRoomId: chatRoomId));
      },
      child: Container(
        color: Colors.black26,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text(userName.substring(0,1).toUpperCase(), style: mediumTextStyle(),),
            ),
            const SizedBox(width: 8),
            Text(userName, style: mediumTextStyle()),
          ],
        ),
      ),
    );
  }
}
