import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hire_mate/resources/constants/all_list/all_lists.dart';
import 'package:hire_mate/resources/constants/app_texts_style/app_text_style.dart';
import 'package:hire_mate/resources/constants/colors/app_colors.dart';
import 'package:hire_mate/resources/widgets/custom_button.dart';
import 'package:hire_mate/resources/widgets/shimmer_loader_view_response.dart';
import 'package:hire_mate/view/software_house/home_screen_sh/set_meeting_screen.dart';
import 'package:hire_mate/view/software_house/home_screen_sh/view_user_cv.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewResponseScreen extends StatefulWidget {
  final String jobId;

  const ViewResponseScreen({super.key, required this.jobId});

  @override
  State<ViewResponseScreen> createState() => _ViewResponseScreenState();
}

class _ViewResponseScreenState extends State<ViewResponseScreen> {
  List<String> applicantUIDs = [];
  bool isLoading = true;
  String selectedStatus = 'Pending'; // Filter status

  @override
  void initState() {
    super.initState();
    fetchApplicants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: whitecolor),
        title: Text(
          "Applicants ($selectedStatus)",
          style: AppTextStyle.commonstyle.copyWith(color: whitecolor),
        ),
        backgroundColor: themecolor,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list, color: whitecolor),
            onSelected: (value) {
              setState(() {
                selectedStatus = value;
                isLoading = true;
              });
              fetchApplicants();
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'Pending', child: Text('Pending')),
              PopupMenuItem(value: 'Approved', child: Text('Approved')),
            ],
          )
        ],
      ),
      body: isLoading
          ? const ShimmerLoaderViewResponse()
          : applicantUIDs.isEmpty
              ? const Center(
                  child: Text("No applications found",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                )
              : ListView.builder(
                  itemCount: applicantUIDs.length,
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection("users")
                          .doc(applicantUIDs[index])
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || !snapshot.data!.exists) {
                          return const SizedBox();
                        }

                        var userData =
                            snapshot.data!.data() as Map<String, dynamic>;

                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ExpansionTile(
                            tilePadding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: themecolor,
                              child: Text(
                                userData['firstName']?[0].toUpperCase() ?? '?',
                                style: const TextStyle(
                                    color: whitecolor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            title: Text(
                              userData['firstName'] ?? 'Unknown',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              userData['email'] ?? 'No email provided',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            trailing:
                                const Icon(Icons.arrow_drop_down, size: 28),
                            children: [
                              const Divider(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Wrap(
                                      spacing: 10,
                                      runSpacing: 10,
                                      children: List.generate(
                                          userData['skills'].length, (index) {
                                        return skills.isEmpty
                                            ? const Text("No Skill Found")
                                            : Column(
                                                children: [
                                                  CircularPercentIndicator(
                                                    radius: 25.0,
                                                    lineWidth: 5.0,
                                                    animation: true,
                                                    header: Text(
                                                      userData['skills'][index],
                                                      style: const TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                    percent: int.parse(userData[
                                                                    'correctanswer']
                                                                [index]
                                                            .toString()) /
                                                        10,
                                                    center: Text(
                                                      "${userData['correctanswer'][index]}0%",
                                                      style: const TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                    progressColor:
                                                        userData['correctanswer']
                                                                    [index] <
                                                                5
                                                            ? Colors.red
                                                            : Colors.green,
                                                  ),
                                                ],
                                              );
                                      }),
                                    ),
                                    const SizedBox(height: 10),
                                    _buildInfoRow(Icons.location_city,
                                        "Location", userData['address']),
                                    GestureDetector(
                                      onTap: () {
                                        openDialer(
                                            userData['phone'].toString());
                                      },
                                      child: _buildInfoRow(Icons.phone, "Phone",
                                          userData['phone']),
                                    ),
                                    const SizedBox(height: 10),
                                    CustomButton(
                                      text: "View Resume",
                                      color: themecolor,
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewUserCv(
                                                        pdfUrl: userData[
                                                            'resume'])));
                                      },
                                    ),
                                    const SizedBox(height: 5),
                                    CustomButton(
                                      text: "Set Meeting",
                                      color: Colors.green,
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SetMeetingScreen(
                                                      jobId: widget.jobId,
                                                      userId: userData['uid'],
                                                    )));
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, color: themecolor, size: 20),
          const SizedBox(width: 8),
          Text(
            "$title: ",
            style: AppTextStyle.commonstyle
                .copyWith(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchApplicants() async {
    try {
      DocumentSnapshot jobDoc = await FirebaseFirestore.instance
          .collection('jobs')
          .doc(widget.jobId)
          .get();

      if (jobDoc.exists) {
        List<dynamic> applicants = jobDoc['appliedUsers'] ?? [];

        List<String> filteredUIDs = applicants
            .where((applicant) =>
                applicant['status'] == selectedStatus &&
                applicant['userId'] != null)
            .map<String>((applicant) => applicant['userId'] as String)
            .toList();

        setState(() {
          applicantUIDs = filteredUIDs;
          isLoading = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching applicants: $e");
      }
      setState(() => isLoading = false);
    }
  }

  void openDialer(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }
}
