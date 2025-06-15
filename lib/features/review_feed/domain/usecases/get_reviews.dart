import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../entities/airline_review.dart';
import '../repositories/review_repository.dart';

class GetReviews {
  final ReviewRepository repository;

  GetReviews(this.repository);

  Future<Result<Failure, List<AirlineReview>>> call() async {
    return await repository.getReviews();
  }
}