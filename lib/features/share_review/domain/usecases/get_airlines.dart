import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../entities/airline.dart';
import '../repositories/aviation_repository.dart';

class GetAirlines {
  final AviationRepository repository;

  GetAirlines(this.repository);

  Future<Result<Failure, List<Airline>>> call({String? search}) async {
    return await repository.getAirlines(search: search);
  }
}