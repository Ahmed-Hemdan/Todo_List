import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/Screens/HomeScreen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      
      duration: 500,
      splashTransition: SplashTransition.fadeTransition,
      splash: const Icon(
        Icons.playlist_add_check_outlined,
        
        size: 130,
      ),
      nextScreen:  HomeScreen(),
    );
  }
}
