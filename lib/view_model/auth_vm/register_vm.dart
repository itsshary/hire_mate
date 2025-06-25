import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hire_mate/model/user_model/user_model.dart';
import 'package:hire_mate/resources/utilis/toast_msg.dart';
import 'package:hire_mate/routes/routes_name.dart';

class RegisterViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> registerUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String address,
    required String skill,
    required String role,
    required BuildContext context,
  }) async {
    setLoading(true);

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      String uid = userCredential.user!.uid;

      UserModel user = UserModel(
          uid: uid,
          email: email.trim(),
          firstName: firstName.trim(),
          lastName: lastName.trim(),
          image: "",
          phone: phone.trim(),
          address: address.trim(),
          skills: [skill],
          uploadResume: "",
          userstatus: "",
          appliedJobs: [],
          role: role);

      await _firestore.collection('users').doc(uid).set(user.toJson());

      ToastMessage().showToast("Registered Successfully");

      if (role == 'Hiring for Jobs') {
        Navigator.pushNamedAndRemoveUntil(
          context,
          Routesname.bottomScreenShView,
          (route) => false,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, Routesname.quizview, (route) => false,
            arguments: {
              'selectedSkill': skill,
              'id': uid,
            });
      }
    } catch (e) {
      ToastMessage().showToast(e.toString());
    } finally {
      setLoading(false);
    }
  }
}
