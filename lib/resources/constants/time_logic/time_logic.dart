import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatTimeAgo(Timestamp timestamp) {
  final DateTime createdAt =
      timestamp.toDate(); // Convert Timestamp to DateTime
  final DateTime now = DateTime.now();
  final Duration difference = now.difference(createdAt);

  if (difference.inMinutes < 1) {
    return 'Just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
  } else {
    return DateFormat('dd MMM yyyy').format(createdAt); // e.g., "24 Sep 2024"
  }
}
