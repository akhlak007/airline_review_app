import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../entities/airline_review.dart';

abstract class ReviewRepository {
  Future<Result<Failure, List<AirlineReview>>> getReviews();
  Future<Result<Failure, List<AirlineReview>>> searchReviews(String query);
}