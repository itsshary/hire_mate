import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hire_mate/resources/constants/app_texts_style/app_text_style.dart';
import 'package:hire_mate/resources/constants/colors/app_colors.dart';
import 'package:hire_mate/resources/utilis/toast_msg.dart';
import 'package:hire_mate/view/user_screens/auth_screens/login_screen.dart';
import 'package:hire_mate/view/user_screens/profile_screen/update_profile_screen.dart';
import 'package:hire_mate/view/user_screens/profile_screen/update_skill.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String uid = FirebaseAuth.instance.currentUser!.uid.toString();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: whitecolor),
          title: Text(
            "Profile",
            style: AppTextStyle.commonstyle.copyWith(color: whitecolor),
          ),
          backgroundColor: themecolor,
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: _firestore.collection('users').doc(uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text("An error occurred"));
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text("User data not found"));
            }

            final userData = snapshot.data!;
            final String firstName = userData['firstName'] ?? '';
            final String lastName = userData['lastName'] ?? '';
            final String email = userData['email'] ?? '';
            final String phone = userData['phone'] ?? '';
            final String imageUrl = userData['image'] ?? '';
            List skills = userData['skills'] ?? [];
            List correctAnswers = userData['correctanswer'] ?? [];

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(
                      imageUrl, firstName, lastName, email, phone),
                  const Divider(height: 30),
                  _buildSkillSection(skills, correctAnswers),
                  const SizedBox(height: 20),
                  _buildOptionsList(uid, skills.length),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileHeader(String imageUrl, String firstName, String lastName,
      String email, String phone) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey.shade300,
          backgroundImage: imageUrl.isNotEmpty
              ? NetworkImage(imageUrl)
              : const AssetImage('images/profile.png') as ImageProvider,
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$firstName $lastName",
                style: AppTextStyle.commonstyle
                    .copyWith(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                email,
                style: AppTextStyle.commonstyle.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Text(
                phone,
                style: AppTextStyle.commonstyle
                    .copyWith(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSkillSection(List skills, List correctAnswers) {
    return skills.isEmpty
        ? const Center(child: Text("No skills found"))
        : Wrap(
            spacing: 10,
            children: List.generate(skills.length, (index) {
              double progress = correctAnswers.isNotEmpty
                  ? (int.parse(correctAnswers[index].toString()) / 10)
                  : 0.0;
              return Column(
                children: [
                  CircularPercentIndicator(
                    radius: 30,
                    lineWidth: 5,
                    animation: true,
                    percent: progress,
                    center: Text("${(progress * 100).toInt()}%"),
                    progressColor: progress < 0.5 ? Colors.red : Colors.green,
                  ),
                  const SizedBox(height: 5),
                  Text(skills[index],
                      style: AppTextStyle.commonstyle.copyWith(fontSize: 14)),
                ],
              );
            }),
          );
  }

  Widget _buildOptionsList(String uid, int skillCount) {
    return Expanded(
      child: ListView(
        children: [
          _buildListTile(Icons.person, "Update Profile", () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UpdateProfileScreen(uid: uid)));
          }),
          _buildListTile(Icons.update, "Update Skill", () {
            if (skillCount < 3) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UpdateSkillScreen()));
            } else {
              ToastMessage().showToast("You can update only three skills");
            }
          }),
          _buildListTile(Icons.logout, "Log Out", () {
            _logout();
          }),
          _buildListTile(Icons.delete, "Delete Account", () async {
            await _deleteAccount(uid);
          }),
        ],
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, VoidCallback onTap) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon,
              color: title == 'Delete Account' ? Colors.red : themecolor),
          title: Text(title,
              style: AppTextStyle.commonstyle.copyWith(
                  color: title == 'Delete Account' ? Colors.red : themecolor)),
          trailing:
              const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          onTap: onTap,
        ),
        const Divider(),
      ],
    );
  }

  Future<void> _logout() async {
    setState(() => isLoading = true);
    await _auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
    setState(() => isLoading = false);
  }

  Future<void> _deleteAccount(String uid) async {
    setState(() => isLoading = true);
    try {
      await _firestore.collection('users').doc(uid).delete();
      await _auth.currentUser?.delete();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to delete account: $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }
}
