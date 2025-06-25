import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hire_mate/resources/constants/app_texts_style/app_text_style.dart';
import 'package:hire_mate/resources/constants/colors/app_colors.dart';
import 'package:hire_mate/routes/routes_name.dart';
import 'package:hire_mate/view/user_screens/auth_screens/login_screen.dart';

class ProfileScreenSh extends StatefulWidget {
  const ProfileScreenSh({super.key});

  @override
  State<ProfileScreenSh> createState() => _ProfileScreenShState();
}

class _ProfileScreenShState extends State<ProfileScreenSh> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final String uid = _auth.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Profile",
          style: AppTextStyle.commonstyle.copyWith(color: Colors.white),
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

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              children: [
                // Profile Header Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 6,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      // Profile Image
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: shade200,
                        backgroundImage: imageUrl.isNotEmpty
                            ? NetworkImage(imageUrl)
                            : const AssetImage('images/profile.png')
                                as ImageProvider,
                      ),
                      const SizedBox(width: 16),

                      // User Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$firstName $lastName",
                              style: AppTextStyle.commonstyle.copyWith(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              email,
                              style: AppTextStyle.commonstyle.copyWith(
                                fontSize: 14.0,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              phone,
                              style: AppTextStyle.commonstyle.copyWith(
                                fontSize: 14.0,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Profile Options List
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildListTile(
                        icon: Icons.edit,
                        title: "Update Profile",
                        onTap: () => Navigator.pushNamed(
                          context,
                          Routesname.profileUpdatesh,
                        ),
                      ),
                      _buildDivider(),
                      _buildListTile(
                        icon: Icons.logout,
                        title: "Log Out",
                        iconColor: Colors.red,
                        onTap: () async {
                          await _auth.signOut();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                            (route) => false,
                          );
                        },
                      ),
                      _buildDivider(),
                      _buildListTile(
                        icon: Icons.delete,
                        title: "Delete Account",
                        iconColor: Colors.red,
                        onTap: () async {
                          try {
                            await _firestore
                                .collection('users')
                                .doc(uid)
                                .delete();
                            await _auth.currentUser?.delete();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                              (route) => false,
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Failed to delete account: $e"),
                              ),
                            );
                          }
                        },
                      ),
                      _buildDivider(),
                      _buildListTile(
                        icon: Icons.info_outline,
                        title: "About",
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Custom ListTile Widget for Cleaner Code
  Widget _buildListTile({
    required IconData icon,
    required String title,
    Color iconColor = Colors.black,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: AppTextStyle.commonstyle),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  // Divider for Separating ListTiles
  Widget _buildDivider() {
    return const Divider(height: 1, color: Colors.grey);
  }
}
