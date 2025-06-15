import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../entities/airport.dart';
import '../repositories/aviation_repository.dart';

class GetAirports {
  final AviationRepository repository;

  GetAirports(this.repository);

  Future<Result<Failure, List<Airport>>> call({String? search}) async {
    return await repository.getAirports(search: search);
  }
}