import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/airline.dart';
import '../../domain/entities/airport.dart';
import '../../domain/repositories/aviation_repository.dart';
import '../datasources/aviation_remote_data_source.dart';

class AviationRepositoryImpl implements AviationRepository {
  final AviationRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AviationRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Result<Failure, List<Airline>>> getAirlines({String? search}) async {
    if (await networkInfo.isConnected) {
      try {
        final airlines = await remoteDataSource.getAirlines(search: search);
        return Right(airlines);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Result<Failure, List<Airport>>> getAirports({String? search}) async {
    if (await networkInfo.isConnected) {
      try {
        final airports = await remoteDataSource.getAirports(search: search);
        return Right(airports);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}