import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:greenspace/Screens/Tasks.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../Intro/intro_page1.dart';
import '../Intro/intro_page2.dart';
import '../Intro/intro_page3.dart';
import 'Login.dart';


class onBoardingScreen extends StatefulWidget {
  const onBoardingScreen({super.key});

  @override
  State<onBoardingScreen> createState() => _onBoardingScreenState();
}

class _onBoardingScreenState extends State<onBoardingScreen> {
  PageController _controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: [
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),
          Container(
            alignment: Alignment(0, 0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (!onLastPage)
                  GestureDetector(
                    onTap: () {
                      _controller.jumpToPage(2);
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (!onLastPage)
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                    effect: ExpandingDotsEffect(
                      activeDotColor: Color(0xff436850),
                      dotColor: Colors.grey,
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 5,
                    ),
                  ),
                if (onLastPage)
                  GestureDetector(
                    // onTap: () {
                    //   Navigator.push(context, MaterialPageRoute(
                    //     builder: (context) {
                    //       return Tasks();
                    //     },
                    //   ));
                    // },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                10),
                            color: Color(0xff436850),
                          ),
                          padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                          child: Text(
                            'Get Started',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Text('Already have an account?'),
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),),);
                              },
                              child: Container(
                                child: Text(
                                  ' Log in',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff436850),
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                              ),
                            )
                          ],
                        ),
                        Container(
                          height: 50,
                        )
                      ],

                    ),

                  )
                else
                  GestureDetector(
                    onTap: () {
                      _controller.nextPage(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.easeIn,
                      );
                    },
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}