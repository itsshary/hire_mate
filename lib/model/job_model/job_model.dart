import 'package:cloud_firestore/cloud_firestore.dart';

class JobModel {
  final String id;
  final String title;
  final String about;
  final String uid;
  final String salary;
  final String responsibilities;
  final String requirements;
  final String location;
  final String seats;
  final String type;
  final String selectdevelopertype;
  final String experience;
  final dynamic appliedUsers;
  final String startTime;
  final String endTime;
  final Timestamp createdAt;

  JobModel({
    required this.id,
    required this.title,
    required this.about,
    required this.salary,
    required this.responsibilities,
    required this.requirements,
    required this.location,
    required this.seats,
    required this.uid,
    required this.type,
    required this.selectdevelopertype,
    required this.experience,
    required this.appliedUsers,
    required this.startTime,
    required this.endTime,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'about': about,
      'salary': salary,
      'responsibilities': responsibilities,
      'requirements': requirements,
      'location': location,
      'seats': seats,
      'type': type,
      'uid': uid,
      'selectdevelopertype': selectdevelopertype,
      'experience': experience,
      'appliedUsers': appliedUsers,
      'startTime': startTime,
      'endTime': endTime,
      'createdAt': createdAt,
    };
  }

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'],
      title: json['title'],
      about: json['about'],
      salary: json['salary'],
      responsibilities: json['responsibilities'],
      requirements: json['requirements'],
      uid: json['uid'],
      location: json['location'],
      seats: json['seats'],
      type: json['type'],
      selectdevelopertype: json['selectdevelopertype'],
      experience: json['experience'],
      appliedUsers: json['appliedUsers'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      createdAt: json['createdAt'],
    );
  }
}
