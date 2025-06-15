import '../../domain/entities/airport.dart';

class AirportModel extends Airport {
  const AirportModel({
    required super.iataCode,
    required super.icaoCode,
    required super.airportName,
    super.cityName,
    super.countryName,
  });

  factory AirportModel.fromJson(Map<String, dynamic> json) {
    return AirportModel(
      iataCode: json['iata_code'] ?? '',
      icaoCode: json['icao_code'] ?? '',
      airportName: json['airport_name'] ?? '',
      cityName: json['city_name'],
      countryName: json['country_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iata_code': iataCode,
      'icao_code': icaoCode,
      'airport_name': airportName,
      'city_name': cityName,
      'country_name': countryName,
    };
  }
}