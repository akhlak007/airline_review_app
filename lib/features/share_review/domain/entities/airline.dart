import 'package:equatable/equatable.dart';

class Airline extends Equatable {
  final String iataCode;
  final String icaoCode;
  final String airlineName;
  final String? country;

  const Airline({
    required this.iataCode,
    required this.icaoCode,
    required this.airlineName,
    this.country,
  });

  @override
  List<Object?> get props => [iataCode, icaoCode, airlineName, country];
}