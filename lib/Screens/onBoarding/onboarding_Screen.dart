// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:introduction_slider/introduction_slider.dart';
import 'package:tasali/Screens/SignIn_Screen/SignIn_Screen.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IntroductionSlider(
          onDone: Sign_In(),
          items: [
            IntroductionSliderItem(
              image: Image.asset(
                'assets/4.png',
                width: 140,
              ),
              backgroundColor: Colors.white,
              title: "Funny Videos",
              description: "This is a description ",
            ),
            IntroductionSliderItem(
              image: Image.asset(
                'assets/1.png',
                width: 200,
              ),
              backgroundColor: Colors.white,
              title: "Memes",
              description: "This is a description ",
            ),
            IntroductionSliderItem(
              backgroundColor: Colors.white,
              image: Image.asset(
                'assets/2.png',
                width: 210,
              ),
              title: "Jokes",
              description: "This is a description of",
            ),
          ],
          scrollDirection: Axis.horizontal,
          isScrollable: true,
          skip: Text("SKIP"),
          next: Text("NEXT"),
          done: Text("DONE"),
          selectedDotColor: Colors.red,
          unselectedDotColor: Colors.blue,
          dotSize: 10.0,
        ),
      ),
    );
  }
}
