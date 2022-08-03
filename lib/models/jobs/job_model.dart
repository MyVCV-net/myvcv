import 'dart:convert';
import 'package:equatable/equatable.dart';

class JobModel extends Equatable {
  final String academicSpecialization;
  final String ageCategory;
  final List appliedUsers;
  final String city;
  final String country;
  final String currency;
  final String endDate;
  final String experianceYears;
  final String firstDescription;
  final String gender;
  final String jobCategory;
  final String jobTitle;
  final String publishDate;
  final String salary;
  final String secondDescription;
  final String jobId;
  final String userId;
  final String userImageUrl;
  final String username;
  final String userEmail;
  final String createdAt;

  const JobModel({
    required this.academicSpecialization,
    required this.ageCategory,
    required this.appliedUsers,
    required this.city,
    required this.country,
    required this.currency,
    required this.endDate,
    required this.experianceYears,
    required this.firstDescription,
    required this.gender,
    required this.jobCategory,
    required this.jobTitle,
    required this.publishDate,
    required this.salary,
    required this.secondDescription,
    required this.jobId,
    required this.userId,
    required this.userImageUrl,
    required this.username,
    required this.userEmail,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        academicSpecialization,
        ageCategory,
        appliedUsers,
        city,
        country,
        currency,
        endDate,
        experianceYears,
        firstDescription,
        gender,
        jobCategory,
        jobTitle,
        publishDate,
        salary,
        secondDescription,
        jobId,
        userId,
        userImageUrl,
        username,
        userEmail,
        createdAt,
      ];

  Map<String, dynamic> toMap() {
    return {
      'academicSpecialization': academicSpecialization,
      'ageCategory': ageCategory,
      'appliedUsers': appliedUsers,
      'city': city,
      'country': country,
      'currency': currency,
      'endDate': endDate,
      'experianceYears': experianceYears,
      'firstDescription': firstDescription,
      'gender': gender,
      'jobCategory': jobCategory,
      'jobTitle': jobTitle,
      'publishDate': publishDate,
      'salary': salary,
      'secondDescription': secondDescription,
      'jobId': jobId,
      'userId': userId,
      'userImageUrl': userImageUrl,
      'username': username,
      'userEmail': userEmail,
      'createdAt': createdAt,
    };
  }

  factory JobModel.fromMap(Map<String, dynamic> map) {
    return JobModel(
      academicSpecialization: map['academicSpecialization'] ?? '',
      ageCategory: map['ageCategory'] ?? '',
      appliedUsers: List.from(map['appliedUsers']),
      city: map['city'] ?? '',
      country: map['country'] ?? '',
      currency: map['currency'] ?? '',
      endDate: map['endDate'] ?? '',
      experianceYears: map['experianceYears'] ?? '',
      firstDescription: map['firstDescription'] ?? '',
      gender: map['gender'] ?? '',
      jobCategory: map['jobCategory'] ?? '',
      jobTitle: map['jobTitle'] ?? '',
      publishDate: map['publishDate'] ?? '',
      salary: map['salary'] ?? '',
      secondDescription: map['secondDescription'] ?? '',
      jobId: map['jobId'] ?? '',
      userId: map['userId'] ?? '',
      userImageUrl: map['userImageUrl'] ?? '',
      username: map['username'] ?? '',
      userEmail: map['userEmail'] ?? '',
      createdAt: map['createdAt'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory JobModel.fromJson(String source) =>
      JobModel.fromMap(json.decode(source));

  JobModel copyWith({
    String? academicSpecialization,
    String? ageCategory,
    List? appliedUsers,
    String? city,
    String? country,
    String? currency,
    String? endDate,
    String? experianceYears,
    String? firstDescription,
    String? gender,
    String? jobCategory,
    String? jobTitle,
    String? publishDate,
    String? salary,
    String? secondDescription,
    String? jobId,
    String? userId,
    String? userImageUrl,
    String? username,
    String? userEmail,
    String? createdAt,
  }) {
    return JobModel(
      academicSpecialization:
          academicSpecialization ?? this.academicSpecialization,
      ageCategory: ageCategory ?? this.ageCategory,
      appliedUsers: appliedUsers ?? this.appliedUsers,
      city: city ?? this.city,
      country: country ?? this.country,
      currency: currency ?? this.currency,
      endDate: endDate ?? this.endDate,
      experianceYears: experianceYears ?? this.experianceYears,
      firstDescription: firstDescription ?? this.firstDescription,
      gender: gender ?? this.gender,
      jobCategory: jobCategory ?? this.jobCategory,
      jobTitle: jobTitle ?? this.jobTitle,
      publishDate: publishDate ?? this.publishDate,
      salary: salary ?? this.salary,
      secondDescription: secondDescription ?? this.secondDescription,
      jobId: jobId ?? this.jobId,
      userId: userId ?? this.userId,
      userImageUrl: userImageUrl ?? this.userImageUrl,
      username: username ?? this.username,
      userEmail: userEmail ?? this.userEmail,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
