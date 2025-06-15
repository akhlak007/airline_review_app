import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/airline_review_model.dart';

abstract class ReviewLocalDataSource {
  Future<List<AirlineReviewModel>> getCachedReviews();
  Future<void> cacheReviews(List<AirlineReviewModel> reviews);
}

class ReviewLocalDataSourceImpl implements ReviewLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String cachedReviewsKey = 'CACHED_REVIEWS';

  ReviewLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<AirlineReviewModel>> getCachedReviews() {
    final jsonString = sharedPreferences.getString(cachedReviewsKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return Future.value(
        jsonList.map((json) => AirlineReviewModel.fromJson(json)).toList(),
      );
    } else {
      throw const CacheException('No cached reviews found');
    }
  }

  @override
  Future<void> cacheReviews(List<AirlineReviewModel> reviews) {
    final jsonList = reviews.map((review) => review.toJson()).toList();
    return sharedPreferences.setString(
      cachedReviewsKey,
      json.encode(jsonList),
    );
  }
}