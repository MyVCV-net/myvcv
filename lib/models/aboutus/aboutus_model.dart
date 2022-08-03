import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class AboutUsModel extends Equatable {
  final String description;

  const AboutUsModel({required this.description});
  AboutUsModel copyWith({String? description}) {
    return AboutUsModel(description: description ?? this.description);
  }

  factory AboutUsModel.fromDocumnetSnapshot(DocumentSnapshot doc) {
    return AboutUsModel(description: doc['desc']);
  }

  @override
  List<Object?> get props => [description];

  Map<String, dynamic> toMap() {
    return {
      'description': description,
    };
  }

  factory AboutUsModel.fromMap(Map<String, dynamic> map) {
    return AboutUsModel(
      description: map['description'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AboutUsModel.fromJson(String source) =>
      AboutUsModel.fromMap(json.decode(source));
}
