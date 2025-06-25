import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hire_mate/resources/constants/app_texts_style/app_text_style.dart';
import 'package:hire_mate/resources/constants/colors/app_colors.dart';
import 'package:hire_mate/resources/widgets/bottom_sheet.dart';
import 'package:hire_mate/resources/widgets/build_tag_widget.dart';
import 'package:hire_mate/view/user_screens/job_details_screen/apply_for_job.dart';
import '../../../resources/constants/time_logic/time_logic.dart';

class JobDetailsScreen extends StatefulWidget {
  final String jobtitle;
  final String firstname;
  final String lastname;
  final String jobtype;

  final String availableSeats;
  final String jobOverview;
  final String responsibilties;
  final String requirements;
  final String starttime;
  final String endtime;
  final String experience;
  final Timestamp jobposttime;
  final String salary;
  final String location;
  final String image;
  final String jobid;
  final String employtype;

  const JobDetailsScreen({
    super.key,
    required this.jobtitle,
    required this.firstname,
    required this.lastname,
    required this.jobposttime,
    required this.image,
    required this.availableSeats,
    required this.endtime,
    required this.starttime,
    required this.jobOverview,
    required this.requirements,
    required this.experience,
    required this.responsibilties,
    required this.salary,
    required this.location,
    required this.jobtype,
    required this.jobid,
    required this.employtype,
  });

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  List<String> jobdetails = [
    "Job Overview",
    "Responsibilities",
    "Requirements",
    "Timing",
    "Experience",
    "Available Seats",
  ];
  String selectedString = "Responsibilities";

  bool _hasApplied = false; // Track job application status

  @override
  void initState() {
    super.initState();
    _checkIfApplied();
  }

  Future<void> _checkIfApplied() async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserId)
        .get();

    if (userDoc.exists) {
      List<dynamic> appliedJobs = userDoc["appliedJobs"] ?? [];

      setState(() {
        _hasApplied = appliedJobs.contains(widget.jobid);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomSheet: _hasApplied
            ? null
            : GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ApplyForJob(jobid: widget.jobid)));
                },
                child: const BottomSheetWidget()),
        body: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: themecolor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40.0,
                      backgroundImage: widget.image.isNotEmpty
                          ? NetworkImage(widget.image)
                          : const AssetImage("images/profile.png")
                              as ImageProvider,
                    ),
                    Text(
                      "${widget.jobtitle}   Developer",
                      style:
                          AppTextStyle.commonstyle.copyWith(color: whitecolor),
                    ),
                    Text(
                      "${widget.firstname} ${widget.lastname}",
                      style: AppTextStyle.commonstyle.copyWith(
                        color: whitecolor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const BuildTagWidget(text: "Developer"),
                        BuildTagWidget(text: widget.jobtype),
                        BuildTagWidget(text: widget.employtype),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          widget.location,
                          style: AppTextStyle.commonstyle.copyWith(
                            color: whitecolor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "${widget.salary} Rs/Monthly",
                          style: AppTextStyle.commonstyle.copyWith(
                            color: whitecolor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            formatTimeAgo(widget.jobposttime),
                            style: AppTextStyle.commonstyle.copyWith(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w800,
                              color: whitecolor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Horizontal list of categories
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: jobdetails.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedString = jobdetails[index];
                        });
                      },
                      child: Text(
                        jobdetails[index],
                        style: AppTextStyle.commonstyle.copyWith(
                          fontSize: 16.0,
                          color: selectedString == jobdetails[index]
                              ? themecolor
                              : blackcolor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Display selected job details with proper alignment and scrolling
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text.rich(
                      TextSpan(
                        children: _getJobDetails(selectedString),
                      ),
                      textAlign: TextAlign.justify,
                      style: AppTextStyle.commonstyle.copyWith(fontSize: 14.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<InlineSpan> _getJobDetails(String selected) {
    switch (selected) {
      case "Job Overview":
        return [
          TextSpan(
              text: widget.jobOverview,
              style: AppTextStyle.commonstyle
                  .copyWith(fontSize: 15.0, fontWeight: FontWeight.normal)),
        ];
      case "Responsibilities":
        return [
          TextSpan(
              text: widget.responsibilties,
              style: AppTextStyle.commonstyle
                  .copyWith(fontSize: 15.0, fontWeight: FontWeight.normal)),
        ];
      case "Requirements":
        return [
          TextSpan(
              text: widget.requirements,
              style: AppTextStyle.commonstyle
                  .copyWith(fontSize: 15.0, fontWeight: FontWeight.normal)),
        ];
      case "Timing":
        return [
          TextSpan(
            text: "Start Time: ${widget.starttime}0 Am\n",
          ),
          TextSpan(text: "End Time: ${widget.endtime}0 Pm"),
        ];
      case "Experience":
        return widget.experience
            .split(',')
            .map((e) => WidgetSpan(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Experience: ",
                          style: TextStyle(fontSize: 20)),
                      Expanded(
                        child: Text(
                          e.trim(),
                          style:
                              AppTextStyle.commonstyle.copyWith(fontSize: 14.0),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList();
      case "Available Seats":
        return [
          TextSpan(
            text: "Available Seats: ${widget.availableSeats}",
            style: AppTextStyle.commonstyle.copyWith(fontSize: 18.0),
          ),
        ];
      default:
        return [
          TextSpan(text: "No details available for $selected"),
        ];
    }
  }
}
