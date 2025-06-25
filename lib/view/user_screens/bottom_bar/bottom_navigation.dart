import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:hire_mate/resources/constants/colors/app_colors.dart';
import 'package:hire_mate/view/user_screens/home_screen/home_screen.dart';
import 'package:hire_mate/view/user_screens/job_notification_screen/job_notification_screen.dart';
import 'package:hire_mate/view/user_screens/profile_screen/profile_screen.dart';

class CustomBottomBar extends StatefulWidget {
  const CustomBottomBar({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const JobNotificationScreen(),
    const ProfileScreen(),
  ];

  final List<TabItem> _navBarsItems = [
    const TabItem(
      icon: Icons.home,
      title: 'Home',
    ),
    const TabItem(
      icon: Icons.notifications,
      title: 'Notifications',
    ),
    const TabItem(
      icon: Icons.person,
      title: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
            left: 15.0, right: 15.0, bottom: 5.0, top: 0.0),
        child: BottomBarFloating(
          animated: true,
          borderRadius: BorderRadius.circular(30.0),
          items: _navBarsItems,
          backgroundColor: themecolor,
          color: Colors.white,
          colorSelected: Colors.amber,
          indexSelected: _currentIndex,
          onTap: (int index) => setState(() {
            _currentIndex = index;
          }),
        ),
      ),
    );
  }
}
