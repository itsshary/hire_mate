class UserModel {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String address;
  final String image;
  final String uploadResume;
  final String userstatus;
  final List<String> correctAnswers;
  final List<String> wrongAnswers;
  final List<String> skills;
  final List<String> appliedJobs;
  final String role;

  UserModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.address,
    required this.image,
    required this.uploadResume,
    required this.userstatus,
    this.correctAnswers = const [],
    this.wrongAnswers = const [],
    required this.skills,
    required this.appliedJobs,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'address': address,
      'image': image,
      'uploadResume': uploadResume,
      'userstatus': userstatus,
      'correctanswer': correctAnswers,
      'wronganswer': wrongAnswers,
      'skills': skills,
      'appliedJobs': appliedJobs,
      'role': role
    };
  }
}
