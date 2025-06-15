import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/review_feed_bloc.dart';
import '../bloc/review_feed_event.dart';
import '../bloc/review_feed_state.dart';
import '../widgets/featured_airline_card.dart';
import '../widgets/review_card.dart';
import '../widgets/search_bar_widget.dart';

class ReviewFeedPage extends StatefulWidget {
  const ReviewFeedPage({super.key});

  @override
  State<ReviewFeedPage> createState() => _ReviewFeedPageState();
}

class _ReviewFeedPageState extends State<ReviewFeedPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Airline Review'),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 8,
                      minHeight: 8,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(
                'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=100&h=100&dpr=2',
              ),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.shareReview);
                          },
                          icon: const Icon(Icons.share, size: 20),
                          label: const Text('Share Your Experience'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.help_outline, size: 20),
                          label: const Text('Ask A Question'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Search Bar
                  const SearchBarWidget(),
                  const SizedBox(height: 20),
                  
                  // Featured Airline Card
                  const FeaturedAirlineCard(),
                ],
              ),
            ),
          ),
          
          // Reviews List
          BlocBuilder<ReviewFeedBloc, ReviewFeedState>(
            builder: (context, state) {
              if (state is ReviewFeedLoading) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              } else if (state is ReviewFeedLoaded) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return ReviewCard(review: state.reviews[index]);
                    },
                    childCount: state.reviews.length,
                  ),
                );
              } else if (state is ReviewFeedError) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          const Icon(Icons.error_outline, size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<ReviewFeedBloc>().add(LoadReviewsEvent());
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return const SliverToBoxAdapter(child: SizedBox.shrink());
            },
          ),
          
          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 32),
          ),
        ],
      ),
    );
  }
}