import 'package:flutter/material.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: 100,
              // Widget 1
            ),
          ),
          Image.asset('assets/Gardening.png',height: 300,width: 300,),
          SizedBox(
            height: 40,
          ), // SizedBox
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Sow, Grow, and Flourish with Us!',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 6,
          ), // SizedBox
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Text(
              'Join our gardening community, connect, and watch gardens thrive.',
              style: TextStyle(fontSize: 18,color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              height: 100,
              // Widget 1
            ),
          ),
        ],
      ),
    );
  }
}