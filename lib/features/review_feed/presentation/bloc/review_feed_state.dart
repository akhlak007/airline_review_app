import 'package:equatable/equatable.dart';
import '../../domain/entities/airline_review.dart';

abstract class ReviewFeedState extends Equatable {
  const ReviewFeedState();

  @override
  List<Object> get props => [];
}

class ReviewFeedInitial extends ReviewFeedState {}

class ReviewFeedLoading extends ReviewFeedState {}

class ReviewFeedLoaded extends ReviewFeedState {
  final List<AirlineReview> reviews;

  const ReviewFeedLoaded({required this.reviews});

  @override
  List<Object> get props => [reviews];
}

class ReviewFeedError extends ReviewFeedState {
  final String message;

  const ReviewFeedError({required this.message});

  @override
  List<Object> get props => [message];
}