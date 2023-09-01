import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:reddit_clone/features/auth/screen/login_screen.dart';
import 'package:reddit_clone/firebase_options.dart';
import 'package:reddit_clone/theme/pallete.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reddit',
      theme: Pallete.darkModeAppTheme,
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
