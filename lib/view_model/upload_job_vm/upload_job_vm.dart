import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hire_mate/model/job_model/job_model.dart';
import 'package:hire_mate/model/user_model/user_model.dart';

class JobViewModel extends ChangeNotifier {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  bool _isLoading = false;
  late List<JobModel> _jobs;
  bool get isLoading => _isLoading;
  List<JobModel> get jobs => _jobs;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> uploadJob(JobModel job, String jobid) async {
    setLoading(true);
    try {
      FirebaseFirestore.instance
          .collection('jobs')
          .doc(jobid)
          .set(job.toJson());
      setLoading(false);
    } catch (e) {
      setLoading(false);
      rethrow;
    }
  }

  Future<void> applyForJob(String jobId, UserModel user) async {
    setLoading(true);
    try {
      final docRef = FirebaseFirestore.instance
          .collection('jobs')
          .doc(jobId)
          .collection('applicants')
          .doc(user.uid);

      await docRef.set(user.toJson()); // Save user details as an applicant

      setLoading(false);
    } catch (e) {
      setLoading(false);
      rethrow;
    }
  }
}
