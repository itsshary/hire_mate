import 'package:flutter/material.dart';
import 'package:hire_mate/resources/constants/app_texts_style/app_text_style.dart';
import 'package:hire_mate/resources/constants/colors/app_colors.dart';

class OnboardingScreenTwo extends StatefulWidget {
  const OnboardingScreenTwo({super.key});

  @override
  State<OnboardingScreenTwo> createState() => _OnboardingScreenTwoState();
}

class _OnboardingScreenTwoState extends State<OnboardingScreenTwo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              flex: 5,
              child: Container(
                decoration: const BoxDecoration(
                  color: themecolor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(
                        "images/img2.png",
                        width: 330,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ],
                ),
              )),
          Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Hire!  The Best Develoer's for Job 👍",
                      style: AppTextStyle.commonstyle.copyWith(fontSize: 32.0),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    const Text(
                        "Hire the Developer's that match your skills and location Find the perfect and Best Developers in just a few clicks.Save time and focus on the right opportunities."),
                    const SizedBox(
                      height: kToolbarHeight * 0.9,
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
