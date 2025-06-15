import 'package:equatable/equatable.dart';

abstract class ShareReviewEvent extends Equatable {
  const ShareReviewEvent();

  @override
  List<Object?> get props => [];
}

class LoadAirlinesEvent extends ShareReviewEvent {
  final String? search;

  const LoadAirlinesEvent({this.search});

  @override
  List<Object?> get props => [search];
}

class LoadAirportsEvent extends ShareReviewEvent {
  final String? search;

  const LoadAirportsEvent({this.search});

  @override
  List<Object?> get props => [search];
}

class SubmitReviewEvent extends ShareReviewEvent {
  final Map<String, dynamic> reviewData;

  const SubmitReviewEvent(this.reviewData);

  @override
  List<Object> get props => [reviewData];
}

class ResetFormEvent extends ShareReviewEvent {}