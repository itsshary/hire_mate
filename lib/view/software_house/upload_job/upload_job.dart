import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hire_mate/model/job_model/job_model.dart';
import 'package:hire_mate/resources/constants/app_texts_style/app_text_style.dart';
import 'package:hire_mate/resources/constants/colors/app_colors.dart';
import 'package:hire_mate/resources/widgets/spin_kit.dart';
import 'package:hire_mate/view_model/upload_job_vm/upload_job_vm.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:time_range/time_range.dart';
import 'package:hire_mate/resources/constants/all_list/all_lists.dart';
import 'package:hire_mate/resources/widgets/custom_button.dart';
import 'package:hire_mate/resources/widgets/input_decoration.dart';

class UploadJob extends StatefulWidget {
  const UploadJob({super.key});

  @override
  State<UploadJob> createState() => _UploadJobState();
}

class _UploadJobState extends State<UploadJob> {
  final TextEditingController jobabout = TextEditingController();
  final TextEditingController jobSalary = TextEditingController();
  final TextEditingController keyResponsibilty = TextEditingController();
  final TextEditingController jobRequirements = TextEditingController();
  final TextEditingController jobLocation = TextEditingController();
  final TextEditingController availableJobSeats = TextEditingController();
  String? _selectJobType;
  String? _selectJobExperience;
  String? selectedDevlopertype;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String? selectjobtitle;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final jobViewModel = Provider.of<JobViewModel>(context);
    return ModalProgressHUD(
      inAsyncCall: jobViewModel.isLoading,
      progressIndicator: const SpinkitLoading(),
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Upload Job",
              style: AppTextStyle.commonstyle.copyWith(color: whitecolor),
            ),
            backgroundColor: themecolor,
          ),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    DropdownButtonFormField(
                      decoration:
                          CustomInputDecoration(hintText: "Select Skill"),
                      value: selectjobtitle,
                      items: skills.map((skill) {
                        return DropdownMenuItem(
                            value: skill, child: Text("$skill Developer"));
                      }).toList(),
                      onChanged: (newValue) {
                        selectjobtitle = newValue!;
                      },
                      validator: (value) =>
                          value == null ? "Please select a Job Title" : null,
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: jobabout,
                      maxLines: 10,
                      maxLength: 1000,
                      decoration: CustomInputDecoration(
                          hintText: 'Enter Job Overview of Your Job'),
                      validator: (value) => value!.isEmpty
                          ? "Please Enter Your Job Job Overview"
                          : null,
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      maxLines: 10,
                      maxLength: 1000,
                      controller: keyResponsibilty,
                      decoration: CustomInputDecoration(
                          hintText: 'Enter Key Responsibilities'),
                      validator: (value) => value!.isEmpty
                          ? "Please Enter Your Job Key Responsibilities"
                          : null,
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      maxLines: 10,
                      maxLength: 1000,
                      controller: jobRequirements,
                      decoration: CustomInputDecoration(
                          hintText: 'Enter Job Requirements'),
                      validator: (value) => value!.isEmpty
                          ? "Please Enter Your Job Requirements"
                          : null,
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: jobSalary,
                      keyboardType: TextInputType.number,
                      decoration:
                          CustomInputDecoration(hintText: 'Enter Job Salary'),
                      validator: (value) => value!.isEmpty
                          ? "Please Enter Your Job Salary"
                          : null,
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: jobLocation,
                      keyboardType: TextInputType.text,
                      decoration:
                          CustomInputDecoration(hintText: 'Enter Job Location'),
                      validator: (value) => value!.isEmpty
                          ? "Please Enter Your Job Location"
                          : null,
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: availableJobSeats,
                      keyboardType: TextInputType.number,
                      decoration:
                          CustomInputDecoration(hintText: 'Enter Job Seats'),
                      validator: (value) =>
                          value!.isEmpty ? "Please Enter Your Job Seats" : null,
                    ),
                    const SizedBox(height: 10.0),
                    DropdownButtonFormField<String>(
                      decoration:
                          CustomInputDecoration(hintText: "Select Job Type"),
                      value: _selectJobType,
                      items: jobtypes.map((role) {
                        return DropdownMenuItem(value: role, child: Text(role));
                      }).toList(),
                      onChanged: (newValue) {
                        _selectJobType = newValue;
                        setState(() {});
                      },
                      validator: (value) =>
                          value == null ? "Please select a Job Type" : null,
                    ),
                    const SizedBox(height: 10.0),
                    DropdownButtonFormField<String>(
                      decoration: CustomInputDecoration(
                          hintText: "Select Job Experience"),
                      value: _selectJobExperience,
                      items: jobExperience.map((role) {
                        return DropdownMenuItem(value: role, child: Text(role));
                      }).toList(),
                      onChanged: (newValue) {
                        _selectJobExperience = newValue;
                        setState(() {});
                      },
                      validator: (value) =>
                          value == null ? "Please select Job Experience" : null,
                    ),
                    const SizedBox(height: 10.0),
                    DropdownButtonFormField<String>(
                      decoration: CustomInputDecoration(
                          hintText: "Select Developer Type"),
                      value: selectedDevlopertype,
                      items: developerType.map((role) {
                        return DropdownMenuItem(value: role, child: Text(role));
                      }).toList(),
                      onChanged: (newValue) {
                        selectedDevlopertype = newValue;
                        setState(() {});
                      },
                      validator: (value) =>
                          value == null ? "Please select Developer Type" : null,
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      "Select Job Timing",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10.0),
                    TimeRange(
                      fromTitle: const Text(
                        'Start Time',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.deepPurple,
                        ),
                      ),
                      toTitle: const Text(
                        'End Time',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.deepPurple,
                        ),
                      ),
                      titlePadding: 20,
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      activeTextStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      borderColor: Colors.deepPurple,
                      backgroundColor: Colors.grey.shade200,
                      activeBackgroundColor: Colors.deepPurple,
                      firstTime: const TimeOfDay(hour: 9, minute: 00),
                      lastTime: const TimeOfDay(hour: 18, minute: 00),
                      timeStep: 60,
                      timeBlock: 60,
                      onRangeCompleted: (range) {
                        setState(() {
                          startTime = range!.start;
                          endTime = range.end;
                        });
                      },
                    ),
                    const SizedBox(height: 10.0),
                    CustomButton(
                      text: 'Upload Job',
                      color: Colors.deepPurple,
                      onTap: () async {
                        if (_formKey.currentState!.validate() &&
                            startTime != null &&
                            endTime != null) {
                          jobViewModel.setLoading(
                              true); // Start loading only when validation passes
                          final job = JobModel(
                            id: DateTime.now()
                                .microsecondsSinceEpoch
                                .toString(),
                            title: selectjobtitle!,
                            about: jobabout.text,
                            salary: jobSalary.text,
                            responsibilities: keyResponsibilty.text,
                            requirements: jobRequirements.text,
                            location: jobLocation.text,
                            seats: availableJobSeats.text,
                            uid: FirebaseAuth.instance.currentUser!.uid
                                .toString(),
                            type: _selectJobType!,
                            selectdevelopertype: selectedDevlopertype!,
                            experience: _selectJobExperience!,
                            startTime:
                                "${startTime!.hour}:${startTime!.minute}",
                            endTime: "${endTime!.hour}:${endTime!.minute}",
                            appliedUsers: [],
                            createdAt: Timestamp.now(),
                          );

                          try {
                            await jobViewModel.uploadJob(job, job.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Job uploaded successfully!')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          } finally {
                            jobViewModel.setLoading(
                                false); // Ensure loading stops in both success and error cases
                          }
                        } else {
                          // Reset loading if validation fails
                          jobViewModel.setLoading(false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Please fill in all required fields.')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
