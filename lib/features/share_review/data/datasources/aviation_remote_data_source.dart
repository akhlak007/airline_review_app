import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/airline_model.dart';
import '../models/airport_model.dart';

abstract class AviationRemoteDataSource {
  Future<List<AirlineModel>> getAirlines({String? search});
  Future<List<AirportModel>> getAirports({String? search});
}

class AviationRemoteDataSourceImpl implements AviationRemoteDataSource {
  final http.Client client;

  AviationRemoteDataSourceImpl({required this.client});

  @override
  Future<List<AirlineModel>> getAirlines({String? search}) async {
    try {
      final queryParameters = <String, String>{
        ApiConstants.accessKey: ApiConstants.apiKey,
        ApiConstants.limit: '100',
      };
      
      if (search != null && search.isNotEmpty) {
        queryParameters[ApiConstants.search] = search;
      }

      final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.airlines)
          .replace(queryParameters: queryParameters);

      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> airlinesJson = jsonData['data'] ?? [];
        
        return airlinesJson
            .map((json) => AirlineModel.fromJson(json))
            .where((airline) => airline.iataCode.isNotEmpty)
            .toList();
      } else {
        throw ServerException('Failed to fetch airlines: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to fetch airlines: $e');
    }
  }

  @override
  Future<List<AirportModel>> getAirports({String? search}) async {
    try {
      final queryParameters = <String, String>{
        ApiConstants.accessKey: ApiConstants.apiKey,
        ApiConstants.limit: '100',
      };
      
      if (search != null && search.isNotEmpty) {
        queryParameters[ApiConstants.search] = search;
      }

      final uri = Uri.parse(ApiConstants.baseUrl + ApiConstants.airports)
          .replace(queryParameters: queryParameters);

      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> airportsJson = jsonData['data'] ?? [];
        
        return airportsJson
            .map((json) => AirportModel.fromJson(json))
            .where((airport) => airport.iataCode.isNotEmpty)
            .toList();
      } else {
        throw ServerException('Failed to fetch airports: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Failed to fetch airports: $e');
    }
  }
}