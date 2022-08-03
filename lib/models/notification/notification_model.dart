import 'dart:convert';

import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final String imageUrl;
  final String username;
  final String subtitle;
  final String time;
  final String userId;

  const NotificationModel(
      {required this.imageUrl,
      required this.username,
      required this.subtitle,
      required this.time,
      required this.userId});
  @override
  List<Object?> get props => [imageUrl, username, subtitle, time, userId];

//   static List<NotificationModel> notification = [
//     NotificationModel(
//         imageUrl:
//             'https://firebasestorage.googleapis.com/v0/b/myvcv-c7726.appspot.com/o/WhatsApp%20Image%202021-07-27%20at%2010.42.24%20AM.jpeg?alt=media&token=4c0a5d02-2000-4533-9d1e-3ee99241d93f',
//         userId: '',
//         subtitle: 'Started following you.',
//         time: 'Just now',
//         username: 'Saleh Abbas')
//   ];

  Future<List<NotificationModel>> notificationModelToMap(List list) async {
    List<NotificationModel> notificationModel = [];
    for (var notificationData in list) {
      notificationModel.add(NotificationModel(
          imageUrl: notificationData[''] ?? '',
          subtitle: notificationData[''] ?? '',
          time: notificationData[''] ?? '',
          userId: notificationData[''] ?? '',
          username: notificationData[''] ?? ''));
    }
    return notificationModel;
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'username': username,
      'subtitle': subtitle,
      'time': time,
      'userId': userId,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      imageUrl: map['imageUrl'] ?? '',
      username: map['username'] ?? '',
      subtitle: map['subtitle'] ?? '',
      time: map['time'] ?? '',
      userId: map['userId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source));
}
