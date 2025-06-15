import 'package:equatable/equatable.dart';

class Airport extends Equatable {
  final String iataCode;
  final String icaoCode;
  final String airportName;
  final String? cityName;
  final String? countryName;

  const Airport({
    required this.iataCode,
    required this.icaoCode,
    required this.airportName,
    this.cityName,
    this.countryName,
  });

  @override
  List<Object?> get props => [iataCode, icaoCode, airportName, cityName, countryName];
}