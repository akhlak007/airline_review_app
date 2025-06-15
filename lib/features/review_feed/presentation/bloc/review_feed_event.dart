import 'package:equatable/equatable.dart';

abstract class ReviewFeedEvent extends Equatable {
  const ReviewFeedEvent();

  @override
  List<Object> get props => [];
}

class LoadReviewsEvent extends ReviewFeedEvent {}

class SearchReviewsEvent extends ReviewFeedEvent {
  final String query;

  const SearchReviewsEvent(this.query);

  @override
  List<Object> get props => [query];
}

class ToggleLikeEvent extends ReviewFeedEvent {
  final String reviewId;

  const ToggleLikeEvent(this.reviewId);

  @override
  List<Object> get props => [reviewId];
}