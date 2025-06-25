import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:hire_mate/admin_panel/dashboard/dashboard_screen.dart';
import 'package:hire_mate/admin_panel/alljobs/all_jobs.dart';

class WebMainScreen extends StatefulWidget {
  static const String id = 'webmain';
  const WebMainScreen({super.key});

  @override
  State<WebMainScreen> createState() => _WebMainScreenState();
}

class _WebMainScreenState extends State<WebMainScreen> {
  Widget selectedScreen = const DashboardScreen();
  String _selectedRoute = DashboardScreen.id; // Track selected screen

  void chooseScreen(String item) {
    setState(() {
      _selectedRoute = item; // Update selected route
      switch (item) {
        case DashboardScreen.id:
          selectedScreen = const DashboardScreen();
          break;

        case AllJobs.id:
          selectedScreen = const AllJobs();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.deepPurple.shade500,
      sideBar: SideBar(
        activeIconColor: Colors.white,
        activeTextStyle: const TextStyle(color: Colors.white, fontSize: 16),
        activeBackgroundColor: Colors.deepPurple,
        selectedRoute: _selectedRoute,
        textStyle: const TextStyle(color: Colors.white, fontSize: 16),
        backgroundColor: Colors.deepPurple,
        onSelected: (item) => chooseScreen(item.route!),
        items: [
          _buildMenuItem("Dashboard", Icons.dashboard, DashboardScreen.id),
          _buildMenuItem("All Jobs", Icons.food_bank, AllJobs.id),
        ],
      ),
      body: selectedScreen,
    );
  }

  AdminMenuItem _buildMenuItem(String title, IconData icon, String route) {
    return AdminMenuItem(
      title: title,
      icon: icon,
      route: route,
    );
  }
}















// import 'package:flutter/material.dart';
// import 'package:flutter_admin_scaffold/admin_scaffold.dart';



// import 'package:food_cycle/admin_panel/active_donations/admin_active_donations.dart';
// import 'package:food_cycle/admin_panel/completed_donations/admin_completed_donations.dart';
// import 'package:food_cycle/admin_panel/dashboard/dashboard_screen.dart';
// import 'package:food_cycle/admin_panel/donations/all_donations.dart';
// import 'package:food_cycle/admin_panel/pending_users/pending_users.dart';
// import 'package:food_cycle/resources/constants/appcolors.dart';

// class WebMainScreen extends StatefulWidget {
//   static const String id = 'webmain';
//   const WebMainScreen({super.key});

//   @override
//   State<WebMainScreen> createState() => _WebMainScreenState();
// }

// class _WebMainScreenState extends State<WebMainScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return AdminScaffold(
//       backgroundColor: Colors.green.shade100,
//       sideBar: SideBar(
//           activeBackgroundColor: Colors.black,
          
//           textStyle: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 16),
//           backgroundColor: Appcolors.primaryColor,
//           onSelected: (item) {
//             chooseScreen(item.route);
//           },
//           items: const [
//             AdminMenuItem(
//                 title: "DashBoard",
//                 icon: Icons.dashboard,
//                 route: DashboardScreen.id),
//             AdminMenuItem(
//                 title: "Pending User's",
//                 icon: Icons.lock_clock_rounded,
//                 route: PendingUsers.id),
//             AdminMenuItem(
//                 title: "All Donation's",
//                 icon: Icons.food_bank,
//                 route: AllDonations.id),
//             AdminMenuItem(
//                 title: "All Active Donation's",
//                 icon: Icons.access_time,
//                 route: AdminActiveDonations.id),
//             AdminMenuItem(
//                 title: "Completed Donation's",
//                 icon: Icons.done,
//                 route: AdminCompletedDonations.id),
//           ],
//           selectedRoute: WebMainScreen.id),
//       body: selectedScree,
//     );
//   }

//   Widget selectedScree = const DashboardScreen();
//   chooseScreen(item) {
//     switch (item) {
//       case DashboardScreen.id:
//         setState(() {
//           selectedScree = const DashboardScreen();
//         });
//         break;
//       case PendingUsers.id:
//         setState(() {
//           selectedScree = const PendingUsers();
//         });
//         break;
//       case AllDonations.id:
//         setState(() {
//           selectedScree = const AllDonations();
//         });
//         break;
//       case AdminActiveDonations.id:
//         setState(() {
//           selectedScree = const AdminActiveDonations();
//         });
//         break;
//       case AdminCompletedDonations.id:
//         setState(() {
//           selectedScree = const AdminCompletedDonations();
//         });
//         break;

//       default:
//     }
//   }
// }
