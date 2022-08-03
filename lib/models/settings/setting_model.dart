import 'package:equatable/equatable.dart';

class Setting extends Equatable {
  final bool dark;
  final String language;
  final bool firstTime;
  final bool acciptTerms;

  const Setting(
      {this.dark = false,
      this.language = 'US',
      this.firstTime = false,
      this.acciptTerms = false});

  @override
  List<Object?> get props => [dark, language, firstTime, acciptTerms];
}
