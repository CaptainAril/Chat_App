import 'package:chat_app/screens/chat_screeen.dart';
import 'package:chat_app/screens/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'reusable_widgets.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email;
  String? password;
  String? emailErrorText;
  String? passwordErrorText;
  bool _inProgress = false;
  bool _fieldValidated = false;
  bool _initialValidationDone = false;

  void validateFields([String? message]) {
    setState(() {
      // emailErrorText = email.isEmpty ? ''
      print("Email -- $email");
      print("password --- $password");
      emailErrorText = email == null || email!.isEmpty || !email!.contains('@')
          // ||
          //     email!.split('@')[1].isEmpty ||
          //     !email!.split('@')[1].contains('.')
          ? 'Please enter a valid email'
          : (message != null && message.toLowerCase().contains('email'))
              ? message
              : null;
      passwordErrorText = password == null || password!.isEmpty
          ? 'Please enter a password'
          : (message != null && message.toLowerCase().contains('password'))
              ? message
              : (message != null &&
                      message.toLowerCase().contains('credential'))
                  ? 'Incorrect Login Credentials'
                  : null;
      ;
      _initialValidationDone = true;
      _fieldValidated = emailErrorText == null && passwordErrorText == null;
    });
    if (message != null && _fieldValidated) {
      message = message.toLowerCase().contains('network')
          ? 'Please check your network connection!'
          : "Something went wrong!";
      Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _inProgress,
        child: Center(
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
                    errorText: emailErrorText,
                    onChanged: _initialValidationDone
                        ? (value) {
                            email = value;
                            validateFields();
                          }
                        : (value) => email = value,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  UserInputField(
                    fieldType: 'password',
                    icon: Icons.lock,
                    hint: 'Enter your password',
                    color: Colors.lightBlueAccent,
                    errorText: passwordErrorText,
                    onChanged: _initialValidationDone
                        ? (value) {
                            password = value;
                            validateFields();
                          }
                        : (value) => password = value,
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  ActionButton(
                    content: 'Log In',
                    color: Colors.lightBlueAccent,
                    onPressed: () async {
                      _inProgress = true;
                      validateFields();
                      print(passwordErrorText);
                      print(emailErrorText);
                      // Go to login screen
                      //  TODO: Implement user login auth function
                      if (_fieldValidated) {
                        try {
                          UserCredential user = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: email!, password: password!);
                          print("user --- $user");

                          if (user.user != null) {
                            Navigator.pushNamed(context, ChatScreeen.id);
                          }
                        } on FirebaseAuthException catch (e) {
                          validateFields(e.toString().split('] ')[1]);
                        }
                        // } catch (e) {
                        //   print(e.toString());
                        //   Fluttertoast.showToast(
                        //     msg: e.toString(),
                        //     gravity: ToastGravity.TOP,
                        //     backgroundColor: Colors.red,
                        //   );
                        // }
                      }

                      setState(() {
                        _inProgress = false;
                      });
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
                        Navigator.popAndPushNamed(
                            context, RegistrationScreen.id);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
