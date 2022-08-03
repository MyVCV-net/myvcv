import 'package:equatable/equatable.dart';

class SearchModel extends Equatable {
  final String id;
  final String imageUrl;
  final String name;
  final String major;
  final String number;
  final String deadline;
  final bool isJob;

  const SearchModel(this.id, this.imageUrl, this.name, this.major, this.number,
      this.deadline, this.isJob);

  @override
  List<Object?> get props =>
      [id, imageUrl, name, major, number, deadline, isJob];
}
