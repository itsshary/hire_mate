import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../resources/utilis/toast_msg.dart';

class UploadResume with ChangeNotifier {
  final String _uid = FirebaseAuth.instance.currentUser!.uid;
  String? resumeUrl;
  File? selectedResume;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> uploadPdfToImageKit(File file, String fileName) async {
    const String imageKitUrl = "https://upload.imagekit.io/api/v1/files/upload";
    const String publicApiKey =
        "private_54sywIDgv2WQFF01+kWU5HIRkpc="; // Replace with your key.

    try {
      final request = http.MultipartRequest("POST", Uri.parse(imageKitUrl));
      request.fields['fileName'] = fileName;
      request.fields['folder'] = "/resumes";
      request.fields['useUniqueFileName'] = "true";
      request.headers['Authorization'] =
          'Basic ${base64Encode(utf8.encode("$publicApiKey:"))}';

      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final decodedResponse = json.decode(responseBody);
        return decodedResponse['url'];
      } else {
        throw Exception("Failed to upload file: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("ImageKit Upload Error: $e");
      return null;
    }
  }

  Future<void> pickResume() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'], // Restrict to PDF files
    );

    if (result != null && result.files.single.path != null) {
      notifyListeners();
      selectedResume = File(result.files.single.path!);
    }
  }

  // Update Firestore with resume URL
  Future<void> uploadResume(BuildContext context) async {
    setLoading(true);
    try {
      if (selectedResume != null) {
        // Upload resume
        resumeUrl = await uploadPdfToImageKit(selectedResume!, "resume_pdf");
      }

      if (resumeUrl != null) {
        await _firestore.collection('users').doc(_uid).update({
          'resume': resumeUrl,
        });
        setLoading(false);
        ToastMessage().showToast("Resume Uploaded Successfully");
      } else {
        setLoading(false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to upload resume.")),
        );
      }
    } catch (e) {
      setLoading(false);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("An error occurred.")),
      );
    }
  }

  Future<void> applyForJob(String jobId, String status, String meetingtime,
      String ptlink, BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('jobs').doc(jobId).update({
          'appliedUsers': FieldValue.arrayUnion([
            {
              "userId": user.uid,
              "status": status,
              "meetingtime": meetingtime,
              "portfoliolink": ptlink
            }
          ]),
        });

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'appliedJobs': FieldValue.arrayUnion([jobId]),
        });

        ToastMessage().showToast("Successfully applied for the job!");
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to apply for the job.")),
        );
      }
    }
  }

  Future<void> fetchUserResume(String uid) async {
    setLoading(true);
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists && userDoc['resume'] != null) {
        resumeUrl = userDoc['resume'];
      } else {
        resumeUrl = null;
      }
    } catch (e) {
      resumeUrl = null;
    }
    setLoading(false);
    notifyListeners();
  }

  Future<void> deleteUserResume(String uid) async {
    setLoading(true);
    try {
      await _firestore.collection('users').doc(uid).update({
        'resume': FieldValue.delete(),
      });

      resumeUrl = null;
      selectedResume = null;

      ToastMessage().showToast("Resume removed from your profile.");
    } catch (e) {
      debugPrint("Error deleting resume URL: $e");
      ToastMessage().showToast("Failed to remove resume.");
    }
    setLoading(false);
    notifyListeners();
  }
}
