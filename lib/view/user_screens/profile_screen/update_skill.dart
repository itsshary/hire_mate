import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hire_mate/resources/constants/all_list/all_lists.dart';
import 'package:hire_mate/resources/constants/app_texts_style/app_text_style.dart';
import 'package:hire_mate/resources/constants/colors/app_colors.dart';
import 'package:hire_mate/resources/widgets/custom_button.dart';
import 'package:hire_mate/view/user_screens/quiz_screen/quiz_screen.dart';

class UpdateSkillScreen extends StatefulWidget {
  const UpdateSkillScreen({super.key});

  @override
  State<UpdateSkillScreen> createState() => _UpdateSkillScreenState();
}

class _UpdateSkillScreenState extends State<UpdateSkillScreen> {
  String? selectedSkill;
  final userid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: whitecolor),
        title: Text(
          'Update Skill',
          style: AppTextStyle.commonstyle.copyWith(color: whitecolor),
        ),
        backgroundColor: themecolor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                value: selectedSkill,
                hint: const Text('Select Skill'),
                items: skills.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text("$value Developer"),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSkill = newValue;
                  });
                },
              ),
              selectedSkill == null
                  ? const SizedBox()
                  : CustomButton(
                      text: "Next",
                      color: themecolor,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QuizScreen(
                                    selectedSkill: selectedSkill!,
                                    userId: userid)));
                      },
                    )
            ],
          ),
        ),
      ),
    );
  }
}
