import 'package:flutter/material.dart';

class StarRatingInput extends StatelessWidget {
  final double rating;
  final ValueChanged<double> onRatingChanged;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;

  const StarRatingInput({
    super.key,
    required this.rating,
    required this.onRatingChanged,
    this.size = 32,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            onRatingChanged((index + 1).toDouble());
          },
          child: Icon(
            index < rating ? Icons.star : Icons.star_border,
            size: size,
            color: index < rating
                ? (activeColor ?? Colors.amber[600])
                : (inactiveColor ?? Colors.grey[400]),
          ),
        );
      }),
    );
  }
}