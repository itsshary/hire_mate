import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:hire_mate/resources/constants/colors/app_colors.dart';
import 'package:hire_mate/view/software_house/home_screen_sh/home_screen_sh.dart';
import 'package:hire_mate/view/software_house/profile_screen_sh/profile_screen_sh.dart';
import 'package:hire_mate/view/software_house/upload_job/upload_job.dart';

class BottomScreenSh extends StatefulWidget {
  const BottomScreenSh({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BottomScreenShState createState() => _BottomScreenShState();
}

class _BottomScreenShState extends State<BottomScreenSh> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreenSh(),
    const UploadJob(),
    const ProfileScreenSh()
  ];

  final List<TabItem> _navBarsItems = [
    const TabItem(
      icon: Icons.home,
      title: 'Home',
    ),
    const TabItem(
      icon: Icons.upload,
      title: 'Upload Job',
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
        padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 10.0),
        child: BottomBarFloating(
          animated: true,
          borderRadius: BorderRadius.circular(15.0),
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
