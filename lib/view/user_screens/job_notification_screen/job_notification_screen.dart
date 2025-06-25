import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hire_mate/resources/constants/app_texts_style/app_text_style.dart';
import 'package:hire_mate/resources/constants/colors/app_colors.dart';
import 'package:hire_mate/view/user_screens/job_details_screen/job_details_screen.dart';
import 'package:hire_mate/view/user_screens/job_notification_screen/widgets/shimmer_jobnt.dart';
import 'package:intl/intl.dart';

class JobNotificationScreen extends StatefulWidget {
  const JobNotificationScreen({super.key});

  @override
  State<JobNotificationScreen> createState() => _JobNotificationScreenState();
}

class _JobNotificationScreenState extends State<JobNotificationScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Applied Jobs",
            style: AppTextStyle.commonstyle.copyWith(color: whitecolor)),
        backgroundColor: themecolor,
        elevation: 0,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _firestore.collection('users').doc(uid).snapshots(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!userSnapshot.hasData || userSnapshot.data == null) {
            return const Center(child: Text("No jobs applied yet."));
          }

          final userData = userSnapshot.data!.data();
          final appliedJobs = List<String>.from(userData?['appliedJobs'] ?? []);

          if (appliedJobs.isEmpty) {
            return const Center(child: Text("No jobs applied yet."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: appliedJobs.length,
            itemBuilder: (context, index) {
              return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: _firestore
                    .collection('jobs')
                    .doc(appliedJobs[index])
                    .snapshots(),
                builder: (context, jobSnapshot) {
                  if (jobSnapshot.connectionState == ConnectionState.waiting) {
                    return const ShimmerJobnt();
                  }

                  if (!jobSnapshot.hasData || jobSnapshot.data == null) {
                    return const ListTile(title: Text("Job not found."));
                  }

                  final jobData = jobSnapshot.data!.data();
                  final List<dynamic> appliedUsers =
                      jobData?['appliedUsers'] ?? [];

                  final appliedUserEntry = appliedUsers.firstWhere(
                    (user) => user['userId'] == uid,
                    orElse: () => null,
                  );
                  if (appliedUserEntry == null) {
                    return const ListTile(
                        title: Text("Application data not found."));
                  }

                  final String jobStatus =
                      appliedUserEntry['status'] ?? 'Pending';

                  String meetingTimeString = appliedUserEntry['meetingtime'];

                  DateFormat inputFormat = DateFormat("yyyy-MM-dd HH:mm");

                  DateTime meetingDateTime =
                      inputFormat.parse(meetingTimeString);

                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(meetingDateTime);
                  String formattedTime =
                      DateFormat('hh:mm a').format(meetingDateTime);

                  return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: _firestore
                        .collection('users')
                        .doc(jobData!['uid'])
                        .snapshots(),
                    builder: (context, companySnapshot) {
                      if (companySnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const ShimmerJobnt();
                      }

                      if (!companySnapshot.hasData ||
                          companySnapshot.data == null) {
                        return const ListTile(
                            title: Text("Company not found."));
                      }

                      final companyData = companySnapshot.data!.data();
                      final companyImage = companyData?['image'] ?? "";
                      final jobTitle = jobData['title'] ?? 'No Title';
                      final companyName =
                          '${companyData?['firstName'] ?? ''} ${companyData?['lastName'] ?? ''}';

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ExpansionTile(
                            iconColor: themecolor,
                            collapsedIconColor: themecolor,
                            title: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => JobDetailsScreen(
                                      jobtitle: jobData['title'],
                                      firstname: companyData!['firstName'],
                                      lastname: companyData['lastName'],
                                      jobposttime: jobData['createdAt'],
                                      image: companyData['image'],
                                      salary: jobData['salary'],
                                      location: jobData['location'],
                                      jobtype: jobData['type'],
                                      jobid: jobData['id'],
                                      employtype:
                                          jobData['selectdevelopertype'],
                                      availableSeats: jobData['seats'],
                                      endtime: jobData['endTime'],
                                      experience: jobData['experience'],
                                      jobOverview: jobData['about'],
                                      requirements: jobData['requirements'],
                                      responsibilties:
                                          jobData['responsibilities'],
                                      starttime: jobData['startTime'],
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: companyImage.isNotEmpty
                                        ? NetworkImage(companyImage)
                                        : const AssetImage("images/profile.png")
                                            as ImageProvider,
                                    radius: 30,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(jobTitle,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                        Text(companyName,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    jobStatus == 'Approved'
                                        ? Icons.check_circle
                                        : Icons.pending_actions,
                                    color: jobStatus == 'Approved'
                                        ? Colors.green
                                        : Colors.orange,
                                  ),
                                ],
                              ),
                            ),
                            children: jobStatus == 'Approved'
                                ? [
                                    ListTile(
                                      leading: const Icon(Icons.lock_clock,
                                          color: themecolor),
                                      title: Text(
                                          "Meeting Time: $formattedTime\nDate: $formattedDate",
                                          style: const TextStyle(fontSize: 14)),
                                    ),
                                    const ListTile(
                                      leading: Icon(Icons.message,
                                          color: themecolor),
                                      title: Text(
                                          "Congratulations! You are selected for the job."),
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: const Text("View Details",
                                          style: TextStyle(color: Colors.blue)),
                                    ),
                                  ]
                                : [],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
