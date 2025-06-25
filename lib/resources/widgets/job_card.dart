import 'package:flutter/material.dart';
import 'package:hire_mate/resources/constants/colors/app_colors.dart';

class JobCard extends StatelessWidget {
  final String title;
  final String company;
  final String location;

  final String imageurl;

  const JobCard({
    super.key,
    required this.title,
    required this.company,
    required this.location,
    required this.imageurl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: shade300, // Use shade100 or define it globally
              borderRadius: BorderRadius.circular(12),
            ),
            child: imageurl.isEmpty
                ? Image.asset(
                    'images/profile.png',
                    height: 32,
                    width: 32,
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    imageurl,
                    height: 32,
                    width: 32,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                company,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "$location ",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
