import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/airline_review.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/review_local_data_source.dart';
import '../datasources/review_remote_data_source.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;
  final ReviewLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ReviewRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Result<Failure, List<AirlineReview>>> getReviews() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteReviews = await remoteDataSource.getReviews();
        localDataSource.cacheReviews(remoteReviews);
        return Right(remoteReviews);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    } else {
      try {
        final localReviews = await localDataSource.getCachedReviews();
        return Right(localReviews);
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Result<Failure, List<AirlineReview>>> searchReviews(String query) async {
    try {
      final reviews = await remoteDataSource.getReviews();
      final filteredReviews = reviews.where((review) =>
        review.airline.toLowerCase().contains(query.toLowerCase()) ||
        review.departureAirport.toLowerCase().contains(query.toLowerCase()) ||
        review.arrivalAirport.toLowerCase().contains(query.toLowerCase())
      ).toList();
      return Right(filteredReviews);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}