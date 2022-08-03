import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserChatModel extends Equatable {
  final String userId;
  final String userImageUrl;
  final String username;

  const UserChatModel({
    required this.userId,
    required this.userImageUrl,
    required this.username,
  });

  @override
  List<Object?> get props => [
        userId,
        userImageUrl,
        username,
      ];

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userImageUrl': userImageUrl,
      'username': username,
    };
  }

  factory UserChatModel.fromMap(Map<String, dynamic> map) {
    return UserChatModel(
      userId: map['userId'] ?? '',
      userImageUrl: map['userImageUrl'] ?? '',
      username: map['username'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserChatModel.fromJson(String source) =>
      UserChatModel.fromMap(json.decode(source));

  Future<List<UserChatModel>> userChatModelToMap(List list) async {
    List<UserChatModel> chatModel = [];
    for (var chatUserData in list) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(chatUserData)
          .get()
          .then((DocumentSnapshot chatUsersSnapshot) async {
        Map<String, dynamic> chatUsersData =
            chatUsersSnapshot.data()! as Map<String, dynamic>;
        // FirebaseFirestore.instance
        //     .collection('chat')
        //     .where('senderId', isEqualTo: chatUserData)
        //     .where('receiverID', isEqualTo: chatUserData)
        //     .orderBy('dateCreated')
        //     .limit(1)
        //     .get()
        //     .then((value) => print(value));
        chatModel.add(UserChatModel(
          userId: chatUserData,
          userImageUrl: chatUsersData['userImageUrl'],
          username: chatUsersData['username'],
        ));
      });
    }
    return chatModel;
  }
}
