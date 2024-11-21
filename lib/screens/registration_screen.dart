import 'package:chat_app/screens/chat_screeen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'reusable_widgets.dart';

class RegistrationScreen extends StatefulWidget {
  static const id = 'registration_screen';
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String? email;
  String? password;
  String? confirmPassword;
  String? passwordErrorText;
  String? emailErrorText;
  String? confirmPasswordErrorText;
  bool _initialValidationDone = false;
  bool _buttonDisable = false;
  bool _inProgress = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void validateFields([String? message]) {
    setState(() {
      // emailErrorText = email.isEmpty ? ''
      print("Email -- $email");
      print("password --- $password");
      print("confirmPassword --- $confirmPassword");
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
              : null;
      ;
      confirmPasswordErrorText =
          confirmPassword == null || confirmPassword!.isEmpty
              ? 'Please confirm your password'
              : 'l';

      print(confirmPasswordErrorText);

      confirmPasswordErrorText =
          confirmPassword != null && password != confirmPassword
              ? 'Passwords do not match!'
              : null;
      _initialValidationDone = true;
      _buttonDisable = emailErrorText != null ||
          passwordErrorText != null ||
          confirmPasswordErrorText != null;
    });
    if (message != null && !_buttonDisable) {
      message = message.toLowerCase().contains('network')
          ? 'Please check your network connection'
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
                    errorText: emailErrorText,
                    color: Colors.blueAccent,
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
                    errorText: passwordErrorText,
                    color: Colors.blueAccent,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: _initialValidationDone
                        ? (value) {
                            password = value;
                            validateFields();
                          }
                        : (value) => password = value,
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  UserInputField(
                    fieldType: 'password',
                    icon: Icons.lock,
                    hint: 'Confirm your password',
                    color: Colors.blueAccent,
                    errorText: confirmPasswordErrorText,
                    onChanged: _initialValidationDone
                        ? (value) {
                            confirmPassword = value;
                            validateFields();
                          }
                        : (value) => confirmPassword = value,
                    // onSubmitted: (value) => validatePassword(value),
                  ),
                  SizedBox(
                    height: 24.0,
                  ),
                  ActionButton(
                    content: 'Register',
                    color: Colors.blueAccent,
                    // disabled: _buttonDisable,
                    onPressed: () async {
                      _inProgress = true;
                      validateFields();
                      if (_buttonDisable == false) {
                        // Go to login screen
                        try {
                          UserCredential user = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: email!, password: password!);
                          print("user --- $user");
                          if (user.user != null) {
                            Navigator.pushReplacementNamed(
                                context, ChatScreeen.id);
                          }
                        } on FirebaseAuthException catch (e) {
                          print('error >>><>>> $e');
                          print(e.credential);
                          print(e.message);
                          print(e.code);

                          // if (e.code.contains('email')) {
                          //   emailErrorText = e.message;
                          // } else if (e.code.contains('password')) {
                          //   passwordErrorText = e.message;
                          // }
                          validateFields(e.message);
                        } catch (e) {
                          print(e);
                          Fluttertoast.showToast(
                            msg: e.toString(),
                            gravity: ToastGravity.TOP,
                            backgroundColor: Colors.red,
                          );
                        }
                      }
                      setState(() {
                        _inProgress = false;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
