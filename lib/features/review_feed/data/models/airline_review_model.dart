import '../../domain/entities/airline_review.dart';

class AirlineReviewModel extends AirlineReview {
  const AirlineReviewModel({
    required super.id,
    required super.userId,
    required super.userName,
    required super.userAvatar,
    required super.departureAirport,
    required super.arrivalAirport,
    required super.airline,
    required super.airlineCode,
    required super.flightClass,
    required super.travelDate,
    required super.reviewDate,
    required super.rating,
    required super.reviewText,
    super.reviewImage,
    required super.likes,
    required super.comments,
    required super.isLiked,
  });

  factory AirlineReviewModel.fromJson(Map<String, dynamic> json) {
    return AirlineReviewModel(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      userAvatar: json['userAvatar'],
      departureAirport: json['departureAirport'],
      arrivalAirport: json['arrivalAirport'],
      airline: json['airline'],
      airlineCode: json['airlineCode'],
      flightClass: json['flightClass'],
      travelDate: DateTime.parse(json['travelDate']),
      reviewDate: DateTime.parse(json['reviewDate']),
      rating: json['rating'].toDouble(),
      reviewText: json['reviewText'],
      reviewImage: json['reviewImage'],
      likes: json['likes'],
      comments: json['comments'],
      isLiked: json['isLiked'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'departureAirport': departureAirport,
      'arrivalAirport': arrivalAirport,
      'airline': airline,
      'airlineCode': airlineCode,
      'flightClass': flightClass,
      'travelDate': travelDate.toIso8601String(),
      'reviewDate': reviewDate.toIso8601String(),
      'rating': rating,
      'reviewText': reviewText,
      'reviewImage': reviewImage,
      'likes': likes,
      'comments': comments,
      'isLiked': isLiked,
    };
  }
}