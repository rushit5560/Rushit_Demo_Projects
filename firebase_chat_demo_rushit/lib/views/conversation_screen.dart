import 'dart:async';
import 'package:firebase_chat_demo_rushit/helper/constants.dart';
import 'package:firebase_chat_demo_rushit/services/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/widget.dart';


class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  const ConversationScreen({Key? key, required this.chatRoomId}) : super(key: key);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  DatabaseMethods databaseMethods = DatabaseMethods();
  final messageFieldController = TextEditingController();
  StreamController<dynamic> controller = StreamController<dynamic>();
  Stream? chatMessagesStream;

  Widget chatMessageList() {
    return StreamBuilder<dynamic>(
      stream: chatMessagesStream,
      builder: (context, snapshot) {
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data!.doc.length,
          itemBuilder: (context, index) {
            return MessageTile(
                    message: snapshot.data!.doc[index].data["message"],
                    isSendByMe: snapshot.data!.doc[index].data["sendBy"] == Constants.myName,
                  );
                },
        ) : Container();
      },
    );

  }

  sendMessage() {
    if(messageFieldController.text.isNotEmpty){
      Map<String, dynamic> messageMap = {
        "message": messageFieldController.text.trim(),
        "sendBy": Constants.myName,
        "time": DateTime.now().microsecondsSinceEpoch
      };
      print('messageMap : $messageMap');
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageFieldController.clear();
    }
  }

  @override
  void initState() {
    chatMessagesStream = controller.stream;
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessagesStream = value;
        // print('chatMessagesStream : $chatMessagesStream');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(context),
      body: Container(
        child: Stack(
          children: [
            chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: const Color(0x54FFFFFF),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: messageFieldController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                            hintText: 'Message...',
                            hintStyle: TextStyle(color: Colors.white54),
                            border: InputBorder.none),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        sendMessage();
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  const MessageTile({Key? key, required this.message, required this.isSendByMe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: Get.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: isSendByMe ? Colors.blueAccent : Colors.black45,
          borderRadius: isSendByMe
              ? const BorderRadius.only(
                  topRight: Radius.circular(23),
                  topLeft: Radius.circular(23),
                  bottomLeft: Radius.circular(23),
                )
              : const BorderRadius.only(
                  topRight: Radius.circular(23),
                  topLeft: Radius.circular(23),
                  bottomRight: Radius.circular(23),
                ),
        ),
        child: Text(
          message,
          style: mediumTextStyle(),
        ),
      ),
    );
  }
}
