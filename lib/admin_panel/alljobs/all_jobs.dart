import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AllJobs extends StatefulWidget {
  static const String id = 'AllJobs';
  const AllJobs({super.key});

  @override
  State<AllJobs> createState() => _AllJobsState();
}

class _AllJobsState extends State<AllJobs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Jobs",
            style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection("jobs").get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "No jobs found.",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            );
          }

          var jobs = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                var job = jobs[index].data();
                var docId = jobs[index].id;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job['title'] ?? 'No Title',
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Job Type: ${job['type']}",
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Salary: ${job['salary'] ?? 'Not Disclosed'}',
                          style: const TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.black54),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => JobDetailsScreen(
                                              jobId: job['id'],
                                              jobTitle: job['title'],
                                              userid: job['uid'],
                                            )));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[700],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text("View Details",
                                  style: TextStyle(color: Colors.white)),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _confirmDelete(docId),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(String docId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Job"),
          content: const Text("Are you sure you want to delete this job?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection("jobs")
                    .doc(docId)
                    .delete()
                    .then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Job deleted successfully")),
                  );
                  Navigator.pop(context);
                  setState(() {});
                });
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

class JobDetailsScreen extends StatelessWidget {
  final String jobTitle;
  final String jobId;
  final String userid;

  const JobDetailsScreen(
      {super.key,
      required this.jobTitle,
      required this.jobId,
      required this.userid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          jobTitle,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('jobs').doc(jobId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Job details not found"));
          }
          var job = snapshot.data!.data() as Map<String, dynamic>;

          return FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userid)
                  .get(),
              builder: (context, usersnapshot) {
                if (usersnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!usersnapshot.hasData || usersnapshot.data == null) {
                  return const Center(child: Text("Job details not found"));
                }
                var userdata =
                    usersnapshot.data!.data() as Map<String, dynamic>;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (userdata['image'] != null)
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  userdata['image'],
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.business,
                                          size: 100, color: Colors.grey),
                                ),
                              ),
                            ),

                          const SizedBox(height: 10),

                          // Company Name
                          Center(
                            child: Text(
                              userdata['firstName'] + userdata['lastName'] ??
                                  'N/A',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Job Title
                          Text(
                            job['title'] ?? 'N/A',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 10),
                          buildDetailRow(Icons.info, "About", job['about']),
                          buildDetailRow(Icons.monetization_on, "Salary",
                              "\$${job['salary']}"),
                          buildDetailRow(Icons.people, "Seats", job['seats']),
                          buildDetailRow(Icons.work, "Responsibilities",
                              job['responsibilities']),
                          buildDetailRow(
                              Icons.star, "Experience", job['experience']),
                          buildDetailRow(Icons.access_time, "Start Time",
                              job['startTime']),
                          buildDetailRow(
                              Icons.access_time, "End Time", job['endTime']),
                          buildDetailRow(Icons.category, "Type", job['type']),
                          buildDetailRow(Icons.developer_mode, "Developer Type",
                              job['selectDeveloperType']),
                          buildDetailRow(
                              Icons.list, "Requirements", job['requirements']),
                          buildDetailRow(
                              Icons.location_on, "Location", job['location']),
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }

  Widget buildDetailRow(IconData icon, String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.deepPurple, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: "$label: ",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                children: [
                  TextSpan(
                    text: value ?? 'N/A',
                    style: const TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
