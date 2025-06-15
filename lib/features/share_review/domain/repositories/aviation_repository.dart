import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../entities/airline.dart';
import '../entities/airport.dart';

abstract class AviationRepository {
  Future<Result<Failure, List<Airline>>> getAirlines({String? search});
  Future<Result<Failure, List<Airport>>> getAirports({String? search});
}