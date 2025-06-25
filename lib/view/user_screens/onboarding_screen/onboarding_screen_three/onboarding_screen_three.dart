import 'package:flutter/material.dart';
import 'package:hire_mate/resources/constants/app_texts_style/app_text_style.dart';
import 'package:hire_mate/resources/constants/colors/app_colors.dart';

class OnboardingScreenThree extends StatefulWidget {
  const OnboardingScreenThree({super.key});

  @override
  State<OnboardingScreenThree> createState() => _OnboardingScreenThreeState();
}

class _OnboardingScreenThreeState extends State<OnboardingScreenThree> {
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
                        "images/img3.png",
                        width: 300,
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
                      "Our Mission 👍",
                      style: AppTextStyle.commonstyle.copyWith(fontSize: 34.0),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    const Text(
                        "We help you to find your dream job according to your skillset,location & preferance to build your career:"),
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
