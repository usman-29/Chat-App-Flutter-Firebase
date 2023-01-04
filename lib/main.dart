import 'package:chat_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';

// global object to access screen size
late Size mq;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // screen orientation
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: ThemeData(
        // app bar theme
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
          // icons theme
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          centerTitle: true,
          elevation: 1,
          backgroundColor: Colors.white,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
