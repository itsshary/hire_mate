import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hire_mate/view/software_house/bottom_screen_sh/bottom_screen_sh.dart';
import 'package:hire_mate/view/user_screens/bottom_bar/bottom_navigation.dart';

class LoginVm extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> loginUser(
      String email, String password, BuildContext context) async {
    try {
      setLoading(true);
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User? user = userCredential.user;
      if (user != null) {
        String uid = user.uid;

        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(uid).get();

        if (userDoc.exists) {
          String role = userDoc['role'];

          if (role == 'Hiring for Jobs') {
            Navigator.pushReplacement(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(
                builder: (context) => const BottomScreenSh(),
              ),
            );
            setLoading(false);
          } else if (role == 'Join for Jobs') {
            Navigator.pushReplacement(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(
                builder: (context) => const CustomBottomBar(),
              ),
            );
            setLoading(false);
          }
        } else {
          setLoading(false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User role not found')),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      setLoading(false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Login failed')),
      );
    }
  }
}
