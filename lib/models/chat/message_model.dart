import 'dart:convert';

import 'package:equatable/equatable.dart';

class MessageModel extends Equatable {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final bool seen;
  final String dateCreatedString;

  const MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.seen,
    required this.dateCreatedString,
  });

  @override
  List<Object?> get props => [
        id,
        senderId,
        receiverId,
        message,
        seen,
        dateCreatedString,
      ];

  // static List<MessageModel> messages = [
  //   MessageModel(
  //       id: 1,
  //       senderId: 1,
  //       receiverId: 2,
  //       message: 'Hey, how are you?',
  //       seen: true,
  //       dateCreated: Timestamp.now(),
  //       dateCreatedString: DateFormat('jm').format(DateTime.now())),
  //   MessageModel(
  //       id: 2,
  //       senderId: 2,
  //       receiverId: 1,
  //       message: 'I\'m good, thank you.',
  //       seen: true,
  //       dateCreated: Timestamp.now(),
  //       dateCreatedString: DateFormat('jm').format(DateTime.now())),
  //   MessageModel(
  //       id: 3,
  //       senderId: 1,
  //       receiverId: 2,
  //       message: 'I\'m good, as well. Thank you.',
  //       seen: true,
  //       dateCreated: Timestamp.now(),
  //       dateCreatedString: DateFormat('jm').format(DateTime.now())),
  //   MessageModel(
  //       id: 4,
  //       senderId: 1,
  //       receiverId: 3,
  //       message: 'Hey, how are you?',
  //       seen: true,
  //       dateCreated: Timestamp.now(),
  //       dateCreatedString: DateFormat('jm').format(DateTime.now())),
  //   MessageModel(
  //       id: 5,
  //       senderId: 3,
  //       receiverId: 1,
  //       message: 'I\'m good, thank you.',
  //       seen: true,
  //       dateCreated: Timestamp.now(),
  //       dateCreatedString: DateFormat('jm').format(DateTime.now())),
  //   MessageModel(
  //       id: 6,
  //       senderId: 1,
  //       receiverId: 5,
  //       message: 'Hey, how are you?',
  //       seen: true,
  //       dateCreated: Timestamp.now(),
  //       dateCreatedString: DateFormat('jm').format(DateTime.now())),
  //   MessageModel(
  //       id: 7,
  //       senderId: 5,
  //       receiverId: 1,
  //       message: 'I\'m good, thank you.',
  //       seen: true,
  //       dateCreated: Timestamp.now(),
  //       dateCreatedString: DateFormat('jm').format(DateTime.now())),
  //   MessageModel(
  //       id: 8,
  //       senderId: 1,
  //       receiverId: 6,
  //       message: 'Hey, how are you?',
  //       seen: true,
  //       dateCreated: Timestamp.now(),
  //       dateCreatedString: DateFormat('jm').format(DateTime.now())),
  //   MessageModel(
  //       id: 9,
  //       senderId: 6,
  //       receiverId: 1,
  //       message: 'I\'m good, thank you.',
  //       seen: true,
  //       dateCreated: Timestamp.now(),
  //       dateCreatedString: DateFormat('jm').format(DateTime.now())),
  //   MessageModel(
  //       id: 10,
  //       senderId: 1,
  //       receiverId: 7,
  //       message: 'Hey, how are you?',
  //       seen: true,
  //       dateCreated: Timestamp.now(),
  //       dateCreatedString: DateFormat('jm').format(DateTime.now())),
  //   MessageModel(
  //       id: 11,
  //       senderId: 7,
  //       receiverId: 1,
  //       message: 'I\'m good, thank you.',
  //       seen: true,
  //       dateCreated: Timestamp.now(),
  //       dateCreatedString: DateFormat('jm').format(DateTime.now())),
  // ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'seen': seen,
      'dateCreatedString': dateCreatedString,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      message: map['message'] ?? '',
      seen: map['seen'] ?? false,
      dateCreatedString: map['dateCreatedString'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source));
}
