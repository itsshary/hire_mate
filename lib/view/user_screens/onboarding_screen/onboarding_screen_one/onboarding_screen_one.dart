import 'package:flutter/material.dart';
import 'package:hire_mate/resources/constants/app_texts_style/app_text_style.dart';
import 'package:hire_mate/resources/constants/colors/app_colors.dart';

class OnboardingScreenOne extends StatefulWidget {
  const OnboardingScreenOne({super.key});

  @override
  State<OnboardingScreenOne> createState() => _OnboardingScreenOneState();
}

class _OnboardingScreenOneState extends State<OnboardingScreenOne> {
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
                        "images/img1.png",
                        width: 400,
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
                      "Make Your Dream \nCareer With Job 👍",
                      style: AppTextStyle.commonstyle.copyWith(fontSize: 34.0),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    const Text(
                        "Search jobs that match your skills and location\nFind the perfect job in just a few clicks.Save time \nand focus on the right opportunities.Your dream\n job is waiting for you."),
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
