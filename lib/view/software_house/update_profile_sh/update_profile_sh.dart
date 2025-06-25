import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:hire_mate/resources/constants/colors/app_colors.dart';
import 'package:hire_mate/resources/widgets/custom_button.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileSh extends StatefulWidget {
  const UpdateProfileSh({super.key});

  @override
  State<UpdateProfileSh> createState() => _UpdateProfileShState();
}

class _UpdateProfileShState extends State<UpdateProfileSh> {
  final TextEditingController _location = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  File? _selectedImage;
  String? _uploadedImageUrl;
  String? _existingImageUrl;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Fetch existing user data from Firestore
  Future<void> _fetchUserData() async {
    try {
      final userDoc = await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final data = userDoc.data();
        if (data != null) {
          _location.text = data['address'] ?? '';
          _phone.text = data['phone'] ?? '';
          _existingImageUrl = data['image'] ?? '';
          setState(() {}); // Update the UI
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching user data: $e");
      }
    }
  }

  // ImageKit upload function (same as before)
  Future<String?> uploadFileToImageKit(File file, String fileName) async {
    const String imageKitUrl = "https://upload.imagekit.io/api/v1/files/upload";
    const String publicApiKey =
        "private_54sywIDgv2WQFF01+kWU5HIRkpc="; // Replace with your key.

    try {
      final request = http.MultipartRequest("POST", Uri.parse(imageKitUrl));
      request.fields['fileName'] = fileName;
      request.fields['folder'] = "/uploads";
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
      if (kDebugMode) {
        print("ImageKit Upload Error: $e");
      }
      return null;
    }
  }

  // Select image
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Update Firestore profile
  Future<void> _updateProfile() async {
    try {
      // Upload the image if selected
      if (_selectedImage != null) {
        _uploadedImageUrl =
            await uploadFileToImageKit(_selectedImage!, "profile_image");
      }

      // Update Firestore
      await _firestore.collection('users').doc(uid).update(
        {
          'address': _location.text.trim(),
          'phone': _phone.text.trim(),
          'image': _uploadedImageUrl ?? _existingImageUrl ?? "",
        },
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Profile updated!")));
    } catch (e) {
      if (kDebugMode) {
        print("Error updating profile: $e");
      }
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update profile.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BackButton(
                    color: Colors.white,
                    onPressed: () => Navigator.pop(context),
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(shade200),
                    ),
                  )
                ],
              ),
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  backgroundColor: shade100,
                  radius: 70,
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!)
                      : (_existingImageUrl != null &&
                              _existingImageUrl!.isNotEmpty
                          ? NetworkImage(_existingImageUrl!)
                          : null),
                  child: (_selectedImage == null &&
                          (_existingImageUrl == null ||
                              _existingImageUrl!.isEmpty))
                      ? const Icon(
                          Icons.camera_alt,
                          color: blackcolor,
                          size: 35,
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _phone,
                decoration: InputDecoration(
                  fillColor: shade100,
                  hintText: 'Enter New Phone Number',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: _location,
                decoration: InputDecoration(
                  fillColor: shade100,
                  hintText: 'Enter New Location',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              CustomButton(
                text: "Update Profile",
                color: themecolor,
                onTap: _updateProfile,
              )
            ],
          ),
        ),
      ),
    );
  }
}
