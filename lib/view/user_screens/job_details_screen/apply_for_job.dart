import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:hire_mate/resources/constants/app_texts_style/app_text_style.dart';
import 'package:hire_mate/resources/constants/colors/app_colors.dart';
import 'package:hire_mate/resources/widgets/custom_button.dart';
import 'package:hire_mate/resources/widgets/spin_kit.dart';
import 'package:hire_mate/routes/routes_name.dart';
import 'package:hire_mate/view_model/upload_resume/upload_resume.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class ApplyForJob extends StatefulWidget {
  final String jobid;
  const ApplyForJob({super.key, required this.jobid});

  @override
  State<ApplyForJob> createState() => _ApplyForJobState();
}

class _ApplyForJobState extends State<ApplyForJob> {
  final TextEditingController linkcontroller = TextEditingController();

  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    super.initState();
    final uploadresume = Provider.of<UploadResume>(context, listen: false);

    uploadresume.fetchUserResume(currentUserId);
  }

  @override
  Widget build(BuildContext context) {
    final uploadresume = Provider.of<UploadResume>(context);

    return ModalProgressHUD(
      inAsyncCall: uploadresume.isLoading,
      progressIndicator: const SpinkitLoading(),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: whitecolor),
          title: Text(
            "Apply for Job",
            style: AppTextStyle.commonstyle.copyWith(color: whitecolor),
          ),
          backgroundColor: themecolor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Upload your resume",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                /// Pick new resume
                GestureDetector(
                  onTap: () async {
                    await uploadresume.pickResume();
                  },
                  child: DottedBorder(
                    color: Colors.black,
                    strokeWidth: 1,
                    dashPattern: const [6, 6],
                    child: SizedBox(
                      height: 150,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Share Now",
                            style: AppTextStyle.commonstyle
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          const Icon(Icons.upload),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                /// Show selected (picked now) resume
                if (uploadresume.selectedResume != null)
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                    child: ListTile(
                      leading: const Icon(Icons.picture_as_pdf,
                          color: Colors.red, size: 40),
                      title: Text(
                        uploadresume.selectedResume!.path.split('/').last,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            uploadresume.selectedResume = null;
                          });
                        },
                      ),
                    ),
                  ),

                /// Show previously uploaded resume if exists
                if (uploadresume.resumeUrl != null)
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                    child: ListTile(
                      leading: const Icon(Icons.picture_as_pdf,
                          color: Colors.red, size: 40),
                      title: const Text(
                        'Old Resume',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.grey),
                        onPressed: () async {
                          setState(() {
                            uploadresume.deleteUserResume(currentUserId);
                          });
                        },
                      ),
                      onTap: () async {
                        final url = uploadresume.resumeUrl!;
                        await launchUrl(Uri.parse(url),
                            mode: LaunchMode.externalApplication);
                      },
                    ),
                  ),

                const SizedBox(height: 20),

                /// Link input
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: linkcontroller,
                    decoration: InputDecoration(
                      hintText: 'Enter Portfolio Link or Github Link',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// Upload Button
                CustomButton(
                  onTap: () async {
                    await uploadresume.uploadResume(context);
                  },
                  text: "Upload Resume",
                  color: themecolor,
                ),

                const SizedBox(height: 10),

                /// Save Button only when resume uploaded
                uploadresume.resumeUrl == null
                    ? const SizedBox()
                    : CustomButton(
                        onTap: () async {
                          uploadresume.setLoading(true);
                          await uploadresume.applyForJob(
                            widget.jobid,
                            "Pending",
                            "2025-4-7 12:00 PM",
                            linkcontroller.text.trim(),
                            context,
                          );
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            Routesname.custombottomView,
                            (route) => false,
                          );
                          uploadresume.setLoading(false);
                        },
                        text: "Save",
                        color: blackcolor,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
