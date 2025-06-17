import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';
import '../../share_review/domain/review.dart';
import '../../share_review/presentation/share_review_viewmodel.dart';
import '../../../core/widgets/rating_stars.dart';
import '../../../core/utils/relative_time.dart';
import '../../../core/utils/date_utils.dart';
import 'media_grid.dart';

class ReviewCard extends ConsumerStatefulWidget {
  final Review review;

  const ReviewCard({super.key, required this.review});

  @override
  ConsumerState<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends ConsumerState<ReviewCard> {
  bool _isLiked = false;
  bool _showComments = false;
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkIfLiked();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _checkIfLiked() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && widget.review.id != null) {
      final repository = ref.read(reviewRepositoryProvider);
      final isLiked = await repository.isLiked(widget.review.id!, user.uid);
      setState(() {
        _isLiked = isLiked;
      });
    }
  }

  void _toggleLike() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || widget.review.id == null) return;

    final repository = ref.read(reviewRepositoryProvider);
    await repository.toggleLike(widget.review.id!, user.uid);
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  void _addComment() async {
    if (_commentController.text.trim().isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null || widget.review.id == null) return;

    final comment = ReviewComment(
      userId: user.uid,
      userName: user.displayName ?? 'Anonymous',
      text: _commentController.text.trim(),
      createdAt: DateTime.now(),
    );

    final repository = ref.read(reviewRepositoryProvider);
    await repository.addComment(widget.review.id!, comment);
    _commentController.clear();
  }

  void _share() {
    Share.share(
      '${widget.review.authorName} shared a review about ${widget.review.airline} flight from ${widget.review.departure} to ${widget.review.arrival}.\n\n${widget.review.description}',
      subject: 'Flight Review',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.review.authorName,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        RelativeTime.getRelativeTime(widget.review.createdAt),
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                RatingStars(rating: widget.review.rating, size: 16),
              ],
            ),
            const SizedBox(height: 12),

            // Flight Info
            Row(
              children: [
                Text(
                  '${widget.review.departure} → ${widget.review.arrival}',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const Spacer(),
                Text(
                  AppDateUtils.formatTravelDate(widget.review.travelDate),
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  widget.review.airline,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    widget.review.travelClass,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              widget.review.description,
              style: const TextStyle(fontSize: 14),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (widget.review.description.length > 100)
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Full Review'),
                      content: Text(widget.review.description),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text(
                  'See More',
                  style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w500),
                ),
              ),
            const SizedBox(height: 12),

            // Media
            if (widget.review.mediaUrls.isNotEmpty)
              MediaGrid(
                mediaUrls: widget.review.mediaUrls,
                mediaTypes: widget.review.mediaTypes,
              ),

            const SizedBox(height: 12),

            // Interaction Stats
            Row(
              children: [
                Text('${widget.review.likesCount} Like'),
                const SizedBox(width: 16),
                Text('${widget.review.commentsCount} Comment'),
              ],
            ),
            const Divider(),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: _toggleLike,
                    icon: Icon(
                      _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                      color: _isLiked ? Colors.deepPurple : Colors.grey,
                    ),
                    label: Text(
                      'Like',
                      style: TextStyle(
                        color: _isLiked ? Colors.deepPurple : Colors.grey,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _showComments = !_showComments;
                      });
                    },
                    icon: const Icon(Icons.comment_outlined, color: Colors.grey),
                    label: const Text('Comment', style: TextStyle(color: Colors.grey)),
                  ),
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: _share,
                    icon: const Icon(Icons.share_outlined, color: Colors.grey),
                    label: const Text('Share', style: TextStyle(color: Colors.grey)),
                  ),
                ),
              ],
            ),

            // Comments Section
            if (_showComments && widget.review.id != null) ...[
              const Divider(),
              // Add Comment
              if (FirebaseAuth.instance.currentUser != null)
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: const InputDecoration(
                          hintText: 'Write a comment...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _addComment,
                      icon: const Icon(Icons.send, color: Colors.deepPurple),
                    ),
                  ],
                ),
              // Comments List
              StreamBuilder<List<ReviewComment>>(
                stream: ref.read(reviewRepositoryProvider).getComments(widget.review.id!),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox.shrink();

                  final comments = snapshot.data!;
                  return Column(
                    children: comments.map((comment) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.person, size: 12, color: Colors.white),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        comment.userName,
                                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        RelativeTime.getRelativeTime(comment.createdAt),
                                        style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
                                      ),
                                    ],
                                  ),
                                  Text(comment.text, style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}