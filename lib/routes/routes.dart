import 'package:flutter/material.dart';
import 'package:hire_mate/routes/routes_name.dart';
import 'package:hire_mate/view/software_house/bottom_screen_sh/bottom_screen_sh.dart';
import 'package:hire_mate/view/software_house/home_screen_sh/home_screen_sh.dart';
import 'package:hire_mate/view/software_house/profile_screen_sh/profile_screen_sh.dart';
import 'package:hire_mate/view/software_house/update_profile_sh/update_profile_sh.dart';
import 'package:hire_mate/view/software_house/upload_job/upload_job.dart';
import 'package:hire_mate/view/user_screens/auth_screens/login_screen.dart';
import 'package:hire_mate/view/user_screens/auth_screens/rejister_screen.dart';
import 'package:hire_mate/view/user_screens/bottom_bar/bottom_navigation.dart';
import 'package:hire_mate/view/user_screens/home_screen/home_screen.dart';
import 'package:hire_mate/view/user_screens/job_notification_screen/job_notification_screen.dart';
import 'package:hire_mate/view/user_screens/onboarding_screen/calling_onboarding_screen/calling_onboarding_screen.dart';
import 'package:hire_mate/view/user_screens/onboarding_screen/onboarding_screen_one/onboarding_screen_one.dart';
import 'package:hire_mate/view/user_screens/onboarding_screen/onboarding_screen_three/onboarding_screen_three.dart';
import 'package:hire_mate/view/user_screens/onboarding_screen/onboarding_screen_two/onboarding_screen_two.dart';
import 'package:hire_mate/view/user_screens/profile_screen/profile_screen.dart';
import 'package:hire_mate/view/user_screens/quiz_screen/quiz_screen.dart';
import 'package:hire_mate/view/user_screens/splash_screen/splash_screen.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case Routesname.splashView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashScreen());
      case Routesname.homeView:
        return MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen());
      case Routesname.loginView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen());
      case Routesname.signUpView:
        return MaterialPageRoute(
            builder: (BuildContext context) => RegisterScreen());
      case Routesname.custombottomView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const CustomBottomBar());
      case Routesname.profileViewSh:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ProfileScreenSh());
      case Routesname.uploadingJobView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const UploadJob());
      case Routesname.profilescreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ProfileScreen());
      case Routesname.jobNotificationscreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const JobNotificationScreen());
      case Routesname.callingonboardingscreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => CallingOnboardingScreen());
      case Routesname.onBoardingScreenOne:
        return MaterialPageRoute(
            builder: (BuildContext context) => const OnboardingScreenOne());
      case Routesname.onBoardingScreenTwo:
        return MaterialPageRoute(
            builder: (BuildContext context) => const OnboardingScreenTwo());
      case Routesname.onBoardingScreenThree:
        return MaterialPageRoute(
            builder: (BuildContext context) => const OnboardingScreenThree());
      case Routesname.bottomScreenShView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const BottomScreenSh());
      case Routesname.homeScreenViewsh:
        return MaterialPageRoute(
            builder: (BuildContext context) => const HomeScreenSh());

      case Routesname.profileUpdatesh:
        return MaterialPageRoute(
          builder: (BuildContext context) {
            return const UpdateProfileSh();
          },
        );

      case Routesname.quizview:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (BuildContext context) => QuizScreen(
            selectedSkill: args['selectedSkill'],
            userId: args['id'],
          ),
        );
      default:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Scaffold(
                  body: Center(
                    child: Text("No Routes Defined"),
                  ),
                ));
    }
  }
}
