import 'package:flutter/material.dart';
import '../../features/review_feed/presentation/pages/review_feed_page.dart';
import '../../features/share_review/presentation/pages/share_review_page.dart';

class AppRoutes {
  static const String reviewFeed = '/';
  static const String shareReview = '/share-review';
  
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case reviewFeed:
        return MaterialPageRoute(builder: (_) => const ReviewFeedPage());
      case shareReview:
        return MaterialPageRoute(
          builder: (_) => const ShareReviewPage(),
          fullscreenDialog: true,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Route not found'),
            ),
          ),
        );
    }
  }
}