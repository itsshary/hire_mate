import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoaderViewResponse extends StatelessWidget {
  const ShimmerLoaderViewResponse({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: Colors.grey),
              title: Container(height: 15, width: 100, color: Colors.grey),
              subtitle: Container(height: 12, width: 150, color: Colors.grey),
            ),
          ),
        );
      },
    );
  }
}
