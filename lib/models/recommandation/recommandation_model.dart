import 'package:equatable/equatable.dart';

class RecModel extends Equatable {
  final String createOn;
  final String fromId;
  final String toId;
  final String recommandation;
  final String fromUsername;
  final String fromPhoto;

  const RecModel({
    required this.createOn,
    required this.fromId,
    required this.toId,
    required this.recommandation,
    required this.fromUsername,
    required this.fromPhoto,
  });

  @override
  List<Object?> get props => [createOn, fromId, toId, recommandation];
}
