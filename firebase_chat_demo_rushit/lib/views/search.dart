import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_demo_rushit/helper/constants.dart';
import 'package:firebase_chat_demo_rushit/helper/helper_functions.dart';
import 'package:firebase_chat_demo_rushit/services/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/widget.dart';
import 'conversation_screen.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

String _myName = "";

class _SearchScreenState extends State<SearchScreen> {

  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchFieldController = TextEditingController();
  QuerySnapshot? searchSnapshot;


  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    _myName = await HelperFunctions.getUserNameFromSharedPreference() ?? "";
    setState(() {

    });
    print('_myName : ${_myName}');
  }

  initiateSearch() {
    databaseMethods.getUserByUsername(
        searchFieldController.text.trim()).then((value) {
      setState(() {
        searchSnapshot = value;
      });
    });
  }

  /// Create chat room, send user to conversation screen
  createChatRoomAndStartConversation({required String userName}) {

    print('my name : ${Constants.myName}');
    if(userName != Constants.myName) {
      String chatRoomId = getChatRoomId(userName, Constants.myName);
      /// Constants.myName = LoggedIn UserName
      /// userName = Search UserName
      List<String> users = [userName, Constants.myName];



      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatroomId": chatRoomId,
      };

      DatabaseMethods().createChatRoom(chatRoomId, chatRoomMap);
      Get.to(()=> ConversationScreen());
    } else {
      print("you cannot send message to yourself");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(context),
      body: Container(
        child: Column(
          children: [
            Container(
              color: const Color(0x54FFFFFF),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: searchFieldController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                          hintText: 'search username',
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      initiateSearch();
                    },
                    icon: const Icon(
                      Icons.search_rounded,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: searchList()),
          ],
        ),
      ),
    );
  }
  
  Widget searchList() {
    return searchSnapshot != null
    ? ListView.builder(
      itemCount: searchSnapshot!.docs.length,
      shrinkWrap: true,
      itemBuilder: (context, index){
        return searchTile(
          userName: searchSnapshot!.docs[0].get("name"),
          email: searchSnapshot!.docs[0].get("email"),
        );
      },
    ) 
    : Container();
  }

  Widget searchTile({required String userName, required String email}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: mediumTextStyle()),
              Text(email, style: mediumTextStyle()),
            ],
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              //todo
              createChatRoomAndStartConversation(userName: userName);
            },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(35),
              ),
              child: Text(
                'Message',
                style: simpleTextStyle(),
              ),
            ),
          ),
        ],
      ),
    );
  }

}





getChatRoomId(String a, String b) {
  if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)){
    return "${b}_$a";
  } else {
    return "${a}_$b";
  }
}