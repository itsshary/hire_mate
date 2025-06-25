import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hire_mate/resources/constants/all_list/all_lists.dart';
import 'package:hire_mate/resources/widgets/job_card.dart';
import 'package:hire_mate/resources/constants/app_texts_style/app_text_style.dart';
import 'package:hire_mate/resources/constants/colors/app_colors.dart';
import 'package:hire_mate/resources/constants/time_logic/time_logic.dart';
import 'package:hire_mate/resources/widgets/build_tag_widget.dart';
import 'package:hire_mate/resources/widgets/shimmer_placeholder_widget.dart';
import 'package:hire_mate/view/user_screens/job_details_screen/job_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> listviewdata = [];
  DocumentSnapshot<Map<String, dynamic>>? value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Discover your \n dream job",
                      style: AppTextStyle.commonstyle.copyWith(fontSize: 28)),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search a job or position",
                  filled: true,
                  fillColor: whitecolor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Trending Jobs",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('jobs').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ShimmerPlaceholderList();
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return const ShimmerPlaceholderList();
                  }
                  listviewdata = snapshot.data!.docs
                      .where(
                          (jobDoc) => skills.contains(jobDoc.data()['title']))
                      .toList();
                  listviewdata = snapshot.data!.docs;
                  final topfive = listviewdata.take(5).toList();
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: topfive.map((jobDoc) {
                        final jobData = jobDoc.data();
                        return FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('users')
                                .doc(jobData["uid"])
                                .get(),
                            builder: (context, futuresnapshot) {
                              if (futuresnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const ShimmerCard();
                              }
                              final companydata = futuresnapshot.data;
                              value = companydata;
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => JobDetailsScreen(
                                        jobtitle: jobData['title'],
                                        firstname: companydata['firstName'],
                                        lastname: companydata['lastName'],
                                        image: companydata['image'],
                                        salary: jobData['salary'],
                                        location: jobData['location'],
                                        jobtype: jobData['type'],
                                        jobid: jobData['id'],
                                        employtype:
                                            jobData['selectdevelopertype'],
                                        jobposttime: jobData['createdAt'],
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
                                child: Card(
                                  shape: const CircleBorder(),
                                  child: Container(
                                    height: 200,
                                    width: 300,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Colors.green.shade600,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          ListTile(
                                            leading: Container(
                                              height: 60.0,
                                              width: 60.0,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                image: (companydata?['image']
                                                            ?.isNotEmpty ==
                                                        true)
                                                    ? DecorationImage(
                                                        image: NetworkImage(
                                                            companydata![
                                                                'image']),
                                                        fit: BoxFit.cover,
                                                      )
                                                    : const DecorationImage(
                                                        image: AssetImage(
                                                            'images/profile.png'),
                                                        fit: BoxFit.cover,
                                                      ),
                                              ),
                                            ),
                                            title: Text(
                                              '${jobData['title']} Developer',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16.0),
                                            ),
                                            subtitle: Text(
                                              companydata!['firstName'] +
                                                  companydata['lastName'],
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.0),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              const BuildTagWidget(
                                                  text: "Developer"),
                                              BuildTagWidget(
                                                  text: jobData['type'] ??
                                                      'Unknown type'),
                                              BuildTagWidget(
                                                  text: jobData[
                                                          'selectdevelopertype'] ??
                                                      'employtype'),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  jobData['location'] ??
                                                      'Unknown Location',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  "${jobData['salary'] ?? '0'}:Rs/Monthly",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 8),
                                            child: Text(
                                              formatTimeAgo(
                                                  jobData['createdAt']),
                                              style: const TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            });
                      }).toList(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Text(
                "Other Jobs",
                style: AppTextStyle.commonstyle,
              ),
              StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('jobs').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ShimmerPlaceholderList();
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return const ShimmerPlaceholderList();
                  }

                  listviewdata = snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: listviewdata.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final jobData = listviewdata[index].data();
                      return FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(jobData["uid"])
                            .get(),
                        builder: (context, futuresnapshot) {
                          if (futuresnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const ShimmerCard();
                          }
                          final companydata = futuresnapshot.data;
                          value = companydata;
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JobDetailsScreen(
                                    jobtitle: jobData['title'],
                                    firstname: companydata['firstName'],
                                    lastname: companydata['lastName'],
                                    image: companydata['image'],
                                    salary: jobData['salary'],
                                    location: jobData['location'],
                                    jobtype: jobData['type'],
                                    jobid: jobData['id'],
                                    employtype: jobData['selectdevelopertype'],
                                    jobposttime: jobData['createdAt'],
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
                            child: JobCard(
                              title: jobData['title'],
                              company: companydata!['firstName'] +
                                  companydata['lastName'],
                              location: jobData['location'],
                              imageurl: companydata['image'],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
