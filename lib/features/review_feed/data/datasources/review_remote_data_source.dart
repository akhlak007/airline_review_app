import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/errors/exceptions.dart';
import '../models/airline_review_model.dart';

abstract class ReviewRemoteDataSource {
  Future<List<AirlineReviewModel>> getReviews();
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final http.Client client;

  ReviewRemoteDataSourceImpl({required this.client});

  @override
  Future<List<AirlineReviewModel>> getReviews() async {
    // Mock data for demonstration
    return _getMockReviews();
  }

  List<AirlineReviewModel> _getMockReviews() {
    return [
      AirlineReviewModel(
        id: '1',
        userId: 'user1',
        userName: 'Dianne Russell',
        userAvatar: 'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=100&h=100&dpr=2',
        departureAirport: 'LHR',
        arrivalAirport: 'DEL',
        airline: 'Air India',
        airlineCode: 'AI',
        flightClass: 'Business Class',
        travelDate: DateTime(2023, 7, 15),
        reviewDate: DateTime(2023, 7, 20),
        rating: 5.0,
        reviewText: 'Stay tuned for a smoother, more convenient experience right at your fingertips, a smoother, more convenient smoother, more convenient experience right at your',
        reviewImage: 'https://images.pexels.com/photos/2026324/pexels-photo-2026324.jpeg?auto=compress&cs=tinysrgb&w=600',
        likes: 30,
        comments: 20,
        isLiked: false,
      ),
      AirlineReviewModel(
        id: '2',
        userId: 'user2',
        userName: 'John Smith',
        userAvatar: 'https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=100&h=100&dpr=2',
        departureAirport: 'JFK',
        arrivalAirport: 'LAX',
        airline: 'American Airlines',
        airlineCode: 'AA',
        flightClass: 'Economy Class',
        travelDate: DateTime(2023, 8, 10),
        reviewDate: DateTime(2023, 8, 12),
        rating: 4.0,
        reviewText: 'Great service and comfortable seats. The flight attendants were very helpful and the food was surprisingly good for economy class.',
        reviewImage: 'https://images.pexels.com/photos/1008155/pexels-photo-1008155.jpeg?auto=compress&cs=tinysrgb&w=600',
        likes: 15,
        comments: 8,
        isLiked: true,
      ),
    ];
  }
}