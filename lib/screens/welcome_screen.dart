import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'reusable_widgets.dart';

class WelcomeScreen extends StatefulWidget {
  static const id = 'welcome_screen';
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late CurvedAnimation animation;
  late Animation colorAnimation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    pageAnimation();
    // controller.
  }

  @override
  void dispose() {
    controller.dispose();
    animation.dispose();
    super.dispose();
  }

  void pageAnimation() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );

    animation = CurvedAnimation(parent: controller, curve: Curves.bounceOut);
    colorAnimation =
        ColorTween(begin: Colors.lightBlueAccent, end: Colors.white)
            .animate(controller);
    controller.forward();

    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAnimation.value,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Logo(
                  height: animation.value * 80,
                ),
                Text(
                  'Flash Chat',
                  style: TextStyle(
                    fontSize: animation.value * 45.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.amberAccent,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            ActionButton(
              content: 'Log In',
              color: Colors.lightBlueAccent,
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            ActionButton(
              content: 'Register',
              color: Colors.blueAccent,
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
