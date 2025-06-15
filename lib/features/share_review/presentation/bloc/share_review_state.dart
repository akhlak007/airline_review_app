import 'package:equatable/equatable.dart';
import '../../domain/entities/airline.dart';
import '../../domain/entities/airport.dart';

abstract class ShareReviewState extends Equatable {
  const ShareReviewState();

  @override
  List<Object> get props => [];
}

class ShareReviewInitial extends ShareReviewState {}

class ShareReviewLoading extends ShareReviewState {}

class AirlinesLoaded extends ShareReviewState {
  final List<Airline> airlines;

  const AirlinesLoaded({required this.airlines});

  @override
  List<Object> get props => [airlines];
}

class AirportsLoaded extends ShareReviewState {
  final List<Airport> airports;

  const AirportsLoaded({required this.airports});

  @override
  List<Object> get props => [airports];
}

class ReviewSubmitted extends ShareReviewState {}

class ShareReviewError extends ShareReviewState {
  final String message;

  const ShareReviewError({required this.message});

  @override
  List<Object> get props => [message];
}