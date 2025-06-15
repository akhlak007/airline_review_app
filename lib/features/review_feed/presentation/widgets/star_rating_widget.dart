import 'package:flutter/material.dart';

class StarRatingWidget extends StatelessWidget {
  final double rating;
  final double size;
  final Color? color;

  const StarRatingWidget({
    super.key,
    required this.rating,
    this.size = 20,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor()
              ? Icons.star
              : index < rating
                  ? Icons.star_half
                  : Icons.star_border,
          size: size,
          color: color ?? Colors.amber,
        );
      }),
    );
  }
}