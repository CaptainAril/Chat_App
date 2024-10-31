import 'package:chat_app/screens/chat_screeen.dart';
import 'package:chat_app/screens/registration_screen.dart';
import 'package:flutter/material.dart';

import 'reusable_widgets.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Logo(),
                SizedBox(
                  height: 48.0,
                ),
                UserInputField(
                  keyboardType: TextInputType.emailAddress,
                  icon: Icons.email_rounded,
                  hint: 'Enter your Email',
                  color: Colors.lightBlueAccent,
                  onChanged: (value) {
                    // Do something with the user input
                  },
                ),
                SizedBox(
                  height: 8.0,
                ),
                UserInputField(
                  fieldType: 'password',
                  icon: Icons.lock,
                  hint: 'Enter your password',
                  color: Colors.lightBlueAccent,
                  onChanged: (value) {
                    // Do something with the user input
                  },
                ),
                SizedBox(
                  height: 24.0,
                ),
                ActionButton(
                  content: 'Log In',
                  color: Colors.lightBlueAccent,
                  onPressed: () {
                    // Go to login screen
                    //  TODO: Implement user login auth function
                    Navigator.pushNamed(context, ChatScreeen.id);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: GestureDetector(
                    child: Text(
                      'Create Account',
                      style: TextStyle(color: Colors.lightBlueAccent),
                    ),
                    onTap: () {
                      Navigator.popAndPushNamed(context, RegistrationScreen.id);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
