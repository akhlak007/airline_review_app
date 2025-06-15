import '../../domain/entities/airline.dart';

class AirlineModel extends Airline {
  const AirlineModel({
    required super.iataCode,
    required super.icaoCode,
    required super.airlineName,
    super.country,
  });

  factory AirlineModel.fromJson(Map<String, dynamic> json) {
    return AirlineModel(
      iataCode: json['iata_code'] ?? '',
      icaoCode: json['icao_code'] ?? '',
      airlineName: json['airline_name'] ?? '',
      country: json['country_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iata_code': iataCode,
      'icao_code': icaoCode,
      'airline_name': airlineName,
      'country_name': country,
    };
  }
}