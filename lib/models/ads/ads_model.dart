import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

class AdsModel extends Equatable {
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
  final String userId;
  final String userImageUrl;
  final String username;
  final String userEmail;
  final String createdAt;
  const AdsModel({
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
      'userId': userId,
      'userImageUrl': userImageUrl,
      'username': username,
      'userEmail': userEmail,
      'createdAt': createdAt,
    };
  }

  factory AdsModel.fromMap(Map<String, dynamic> map) {
    return AdsModel(
      academicSpecialization: map['academicSpecialization'] ?? '',
      ageCategory: map['ageCategory'] ?? '',
      appliedUsers: List<String>.from(map['appliedUsers']),
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
      userId: map['userId'] ?? '',
      userImageUrl: map['userImageUrl'] ?? '',
      username: map['username'] ?? '',
      userEmail: map['userEmail'] ?? '',
      createdAt: map['createdAt'] ?? '',
    );
  }
  Future<List<AdsModel>> adsModelToMap(List list) async {
    List<AdsModel> adsModel = [];
    try {
      for (var adsData in list) {
        await FirebaseFirestore.instance
            .collection('ads')
            .doc(adsData)
            .get()
            .then((value) async {
          Map<String, dynamic> modelData = value.data() as Map<String, dynamic>;

          await FirebaseFirestore.instance
              .collection('users')
              .doc(modelData['userId'])
              .get()
              .then((value) async {
            Map<String, dynamic> userData =
                value.data() as Map<String, dynamic>;
            adsModel.add(
              AdsModel(
                academicSpecialization: modelData['academicSpecialization'],
                ageCategory: modelData['ageCategory'],
                appliedUsers: modelData['appliedUsers'] as List,
                city: modelData['city'],
                country: modelData['country'],
                currency: modelData['currency'],
                endDate: modelData['endDate'],
                experianceYears: modelData['experianceYears'],
                firstDescription: modelData['firstDescription'],
                gender: modelData['gender'],
                jobCategory: modelData['jobCategory'],
                jobTitle: modelData['jobTitle'],
                publishDate: modelData['publishDate'],
                salary: modelData['salary'],
                secondDescription: modelData['secondDescription'],
                userId: modelData['userId'],
                userImageUrl: userData['userImageUrl'],
                username: userData['username'],
                userEmail: userData['email'],
                createdAt:
                    (modelData['createdAt'] as Timestamp).toDate().toString(),
              ),
            );
          });
        });
      }
    } on FirebaseException catch (e) {
      print(e);
    } on PlatformException catch (e) {
      print(e);
    } catch (e) {
      print(e);
    }
    return adsModel;
  }

  String toJson() => json.encode(toMap());

  factory AdsModel.fromJson(String source) =>
      AdsModel.fromMap(json.decode(source));
}
