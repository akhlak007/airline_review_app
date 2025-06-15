import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecases/get_reviews.dart';
import 'review_feed_event.dart';
import 'review_feed_state.dart';

class ReviewFeedBloc extends Bloc<ReviewFeedEvent, ReviewFeedState> {
  final GetReviews getReviews;

  ReviewFeedBloc({required this.getReviews}) : super(ReviewFeedInitial()) {
    on<LoadReviewsEvent>(_onLoadReviews);
    on<SearchReviewsEvent>(_onSearchReviews);
    on<ToggleLikeEvent>(_onToggleLike);
  }

  void _onLoadReviews(
      LoadReviewsEvent event, Emitter<ReviewFeedState> emit) async {
    emit(ReviewFeedLoading());

    final failureOrReviews = await getReviews();

    failureOrReviews.fold(
      (failure) =>
          emit(ReviewFeedError(message: _mapFailureToMessage(failure))),
      (reviews) => emit(ReviewFeedLoaded(reviews: reviews)),
    );
  }

  void _onSearchReviews(
      SearchReviewsEvent event, Emitter<ReviewFeedState> emit) async {
    // Implementation for search functionality
    // For now, just reload all reviews
    add(LoadReviewsEvent());
  }

  void _onToggleLike(ToggleLikeEvent event, Emitter<ReviewFeedState> emit) {
    // Implementation for toggling like
    // This would typically involve updating the review in the repository
  }

  String _mapFailureToMessage(failure) {
    if (failure is ServerFailure) {
      return 'Server Failure';
    } else if (failure is CacheFailure) {
      return 'Cache Failure';
    } else {
      return 'Unexpected Error';
    }
  }
}
