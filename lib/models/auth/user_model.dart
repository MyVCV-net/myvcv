import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:myvcv/models/models.dart';

class UserModel extends Equatable {
  final String id;
  final String username;
  final String email;
  final bool isJobSeeker;
  final String userImageUrl;
  final String major;
  final String businessModel;
  final String gender;
  final String dob;
  final String city;
  final String country;
  final List token;
  final List<DataModel> pitchYourselfVideoUrl;
  final List<DataModel> skillsUrl;
  final List follower;
  final List following;
  final List<DataModel> qualificationDocumentUrl;
  final List<DataModel> contactInfoData;
  final List<AdsModel> ads;
  final List<NotificationModel> notification;
  final List<UserChatModel> chatUsers;

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.isJobSeeker,
    required this.userImageUrl,
    required this.major,
    required this.businessModel,
    required this.pitchYourselfVideoUrl,
    required this.gender,
    required this.dob,
    required this.city,
    required this.country,
    required this.token,
    required this.skillsUrl,
    required this.follower,
    required this.following,
    required this.qualificationDocumentUrl,
    required this.contactInfoData,
    required this.ads,
    required this.notification,
    required this.chatUsers,
  });
  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    bool? isJobSeeker,
    String? userImageUrl,
    String? major,
    String? businessModel,
    List<DataModel>? pitchYourselfVideoUrl,
    String? gender,
    String? dob,
    String? city,
    String? country,
    List? token,
    List<DataModel>? skillsUrl,
    List? follower,
    List? following,
    List<DataModel>? qualificationDocumentUrl,
    List<DataModel>? contactInfoData,
    List<AdsModel>? ads,
    List<NotificationModel>? notification,
    List<UserChatModel>? chatUsers,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      isJobSeeker: isJobSeeker ?? this.isJobSeeker,
      userImageUrl: userImageUrl ?? this.userImageUrl,
      major: major ?? this.major,
      businessModel: businessModel ?? this.businessModel,
      pitchYourselfVideoUrl:
          pitchYourselfVideoUrl ?? this.pitchYourselfVideoUrl,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      city: city ?? this.city,
      country: country ?? this.country,
      token: token ?? this.token,
      skillsUrl: skillsUrl ?? this.skillsUrl,
      follower: follower ?? this.follower,
      following: following ?? this.following,
      qualificationDocumentUrl:
          qualificationDocumentUrl ?? this.qualificationDocumentUrl,
      contactInfoData: contactInfoData ?? this.contactInfoData,
      ads: ads ?? this.ads,
      notification: notification ?? this.notification,
      chatUsers: chatUsers ?? this.chatUsers,
    );
  }

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        isJobSeeker,
        userImageUrl,
        major,
        businessModel,
        pitchYourselfVideoUrl,
        gender,
        dob,
        city,
        country,
        token,
        skillsUrl,
        follower,
        following,
        qualificationDocumentUrl,
        contactInfoData,
        ads,
        notification,
        chatUsers,
      ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'isJobSeeker': isJobSeeker,
      'userImageUrl': userImageUrl,
      'major': major,
      'businessModel': businessModel,
      'gender': gender,
      'dob': dob,
      'city': city,
      'country': country,
      'token': token,
      'pitchYourselfVideoUrl':
          pitchYourselfVideoUrl.map((x) => x.toMap()).toList(),
      'skillsUrl': skillsUrl.map((x) => x.toMap()).toList(),
      'follower': follower,
      'following': following,
      'qualificationDocumentUrl':
          qualificationDocumentUrl.map((x) => x.toMap()).toList(),
      'contactInfoData': contactInfoData.map((x) => x.toMap()).toList(),
      'ads': ads.map((x) => x.toMap()).toList(),
      'notification': notification.map((x) => x.toMap()).toList(),
      'chatUsers': chatUsers.map((x) => x.toMap()).toList(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      isJobSeeker: map['isJobSeeker'] ?? false,
      userImageUrl: map['userImageUrl'] ?? '',
      major: map['major'] ?? '',
      businessModel: map['businessModel'] ?? '',
      pitchYourselfVideoUrl: List<DataModel>.from(
          map['pitchYourselfVideoUrl']?.map((x) => DataModel.fromMap(x))),
      gender: map['gender'] ?? '',
      dob: map['dob'] ?? '',
      city: map['city'] ?? '',
      country: map['country'] ?? '',
      token: map['token'] ?? [],
      skillsUrl: List<DataModel>.from(
          map['skillsUrl']?.map((x) => DataModel.fromMap(x))),
      follower: List.from(map['follower']),
      following: List.from(map['following']),
      qualificationDocumentUrl: List<DataModel>.from(
          map['qualificationDocumentUrl']?.map((x) => DataModel.fromMap(x))),
      contactInfoData: List<DataModel>.from(
          map['contactInfoData']?.map((x) => DataModel.fromMap(x))),
      ads: List<AdsModel>.from(map['ads']?.map((x) => AdsModel.fromMap(x))),
      notification: List<NotificationModel>.from(
        map['notification']?.map((x) => NotificationModel.fromMap(x)),
      ),
      chatUsers: List<UserChatModel>.from(
          map['chatUsers']?.map((x) => UserChatModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
