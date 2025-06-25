import 'package:flutter/material.dart';
import 'package:hire_mate/resources/constants/colors/app_colors.dart';
import 'package:hire_mate/view/user_screens/auth_screens/login_screen.dart';
import 'package:hire_mate/view/user_screens/onboarding_screen/onboarding_screen_one/onboarding_screen_one.dart';
import 'package:hire_mate/view/user_screens/onboarding_screen/onboarding_screen_three/onboarding_screen_three.dart';
import 'package:hire_mate/view/user_screens/onboarding_screen/onboarding_screen_two/onboarding_screen_two.dart';

class CallingOnboardingScreen extends StatefulWidget {
  const CallingOnboardingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CallingOnboardingScreenState createState() =>
      _CallingOnboardingScreenState();
}

class _CallingOnboardingScreenState extends State<CallingOnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _navigateToHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const OnboardingScreenOne(),
      const OnboardingScreenTwo(),
      const OnboardingScreenThree(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: pages,
          ),
          Positioned(
            bottom: 30,
            left: 20,
            child: _currentPage < pages.length - 1
                ? TextButton(
                    onPressed: () {
                      _pageController.jumpToPage(pages.length - 1);
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(color: themecolor, fontSize: 16),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Positioned(
            bottom: 30,
            right: 20,
            child: TextButton(
              onPressed: () {
                if (_currentPage == pages.length - 1) {
                  _navigateToHome();
                } else {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                }
              },
              child: Container(
                height: 40,
                width: 90,
                decoration: BoxDecoration(
                    color: themecolor,
                    borderRadius: BorderRadius.circular(10.0)),
                child: Center(
                  child: Text(
                    _currentPage == pages.length - 1 ? 'Finish' : 'Next',
                    style: const TextStyle(color: whitecolor, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) => _buildIndicator(index == _currentPage),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 10,
      width: isActive ? 20 : 10,
      decoration: BoxDecoration(
        color: isActive ? themecolor : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
