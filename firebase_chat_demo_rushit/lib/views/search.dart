import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_chat_demo_rushit/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchFieldController = TextEditingController();
  QuerySnapshot? searchSnapshot;

  @override
  void initState() {
    super.initState();
  }

  initiateSearch() {
    databaseMethods.getUserByUsername(
        searchFieldController.text.trim()).then((value) {
      setState(() {
        searchSnapshot = value;
      });
    });
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
        return SearchTile(
          userName: searchSnapshot!.docs[0].get("name"),
          email: searchSnapshot!.docs[0].get("email"),
        );
      },
    ) 
    : Container();
  }

}


class SearchTile extends StatelessWidget {
  String userName;
  String email;

  SearchTile({Key? key, required this.userName, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(userName, style: simpleTextStyle()),
              Text(email, style: simpleTextStyle()),
            ],
          ),
          const SizedBox(width: 10),
          Container(
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
        ],
      ),
    );
  }
}
