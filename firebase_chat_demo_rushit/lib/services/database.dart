import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {

  /// Get UserInfo By Search
  getUserByUsername(String username) async {
    return await FirebaseFirestore.instance.collection("users")
        .where("name", isEqualTo: username).get();
  }

  getUserByUserEmail(String userEmail) async {
    return await FirebaseFirestore.instance.collection("users")
        .where("email", isEqualTo: userEmail).get();
  }

  /// Add User in User Collection in Firebase
  uploadUserInfo(Map<String, String> userMap) {
    FirebaseFirestore.instance.collection("users")
    .add(userMap).catchError((e) {
      print('Error : $e');
    });
  }

  // Create ChatRoom of 2 Users
  createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance.collection("ChatRoom")
        .doc(chatRoomId).set(chatRoomMap).catchError((e){
          print('Error : $e');
    });
  }

}