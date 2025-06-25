import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hire_mate/admin_panel/web_main_screen.dart';
import 'package:hire_mate/firebase_options.dart';
import 'package:hire_mate/routes/routes.dart';
import 'package:hire_mate/routes/routes_name.dart';
import 'package:hire_mate/view/user_screens/splash_screen/splash_screen.dart';
import 'package:hire_mate/view_model/auth_vm/login_vm.dart';
import 'package:hire_mate/view_model/auth_vm/register_vm.dart';
import 'package:hire_mate/view_model/quiz_vm/quiz_vm.dart';
import 'package:hire_mate/view_model/upload_job_vm/upload_job_vm.dart';
import 'package:hire_mate/view_model/upload_resume/upload_resume.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => QuizViewModel()),
        ChangeNotifierProvider(create: (_) => JobViewModel()),
        ChangeNotifierProvider(create: (_) => UploadResume()),
        ChangeNotifierProvider(create: (_) => LoginVm()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: Routesname.splashView,
        onGenerateRoute: Routes.generateRoutes,
        home: kIsWeb ? WebMainScreen() : SplashScreen(),
      ),
    );
  }
}
