import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerJobnt extends StatelessWidget {
  const ShimmerJobnt({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListTile(
        leading: Container(width: 40, height: 40, color: Colors.grey),
        title: Container(width: 100, height: 10, color: Colors.grey),
        subtitle: Container(width: 150, height: 10, color: Colors.grey),
      ),
    );
  }
}
