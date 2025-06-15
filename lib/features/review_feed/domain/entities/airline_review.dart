import 'package:equatable/equatable.dart';

class AirlineReview extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String departureAirport;
  final String arrivalAirport;
  final String airline;
  final String airlineCode;
  final String flightClass;
  final DateTime travelDate;
  final DateTime reviewDate;
  final double rating;
  final String reviewText;
  final String? reviewImage;
  final int likes;
  final int comments;
  final bool isLiked;

  const AirlineReview({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.departureAirport,
    required this.arrivalAirport,
    required this.airline,
    required this.airlineCode,
    required this.flightClass,
    required this.travelDate,
    required this.reviewDate,
    required this.rating,
    required this.reviewText,
    this.reviewImage,
    required this.likes,
    required this.comments,
    required this.isLiked,
  });

  @override
  List<Object?> get props => [
    id, userId, userName, userAvatar, departureAirport, arrivalAirport,
    airline, airlineCode, flightClass, travelDate, reviewDate, rating,
    reviewText, reviewImage, likes, comments, isLiked,
  ];
}