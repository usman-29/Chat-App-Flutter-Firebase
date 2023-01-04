import 'dart:io';
import 'package:chat_app/api/apis.dart';
import 'package:chat_app/helper.dart/dialogs.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // google sign in button handler
  _handleGoogleButton() {
    // showing progress bar
    Dialogs.showProgress(context);
    _signInWithGoogle().then((user) async {
      //hiding progress bar
      Navigator.pop(context);
      if (user != null) {
        // if user exists go to home page
        if (await APIs.userExists()) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: ((_) => const HomeScreen())));
        }
        // if it is a new user then first create user then go to home page
        else {
          await APIs.createUser().then((value) => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: ((_) => const HomeScreen()))));
        }
      }
    });
  }

  // google authentication
  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      Dialogs.showSnackbar(context, 'Something went wrong (Check Internet!)');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset('assets/images/chat.png',
                  height: mq.height / 2, width: mq.width / 2),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[300],
                  borderRadius: BorderRadius.circular(50),
                ),
                child: GestureDetector(
                  onTap: () => _handleGoogleButton(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        'assets/images/google.png',
                        height: 60,
                        width: 60,
                      ),
                      const Text(
                        'Sign In With Google',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
