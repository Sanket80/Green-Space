
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:greenspace/Screens/AddPark.dart';
import 'package:greenspace/Screens/Sign_up.dart';
import 'package:greenspace/Widgets/text_field.dart';

import 'onBoarding.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> login() async{
    try{
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('Signing in...'),
              ],
            ),
          );
        },
      );

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      Navigator.push(context, MaterialPageRoute(builder: (context) => AddPark()));
    } catch (e) {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Flexible(child: Container(), flex: 1),
                  Image.asset('assets/logo.png',height: 300,),
                  SizedBox(height: 8),
                  Text(
                    'Unlock your Career with AI Powered Talent Match',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32),
                  TextFieldInput(textEditingController: _emailController, hintText: 'Email', textInputType: TextInputType.emailAddress, isPass: false),

                  SizedBox(height: 12),
                  TextFieldInput(textEditingController: _passwordController, hintText: 'Password', textInputType: TextInputType.visiblePassword, isPass: true),

                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        login();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff436850), // Background color
                        onPrimary: Colors.white, // Text color
                        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 38),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),


                  SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text('Don\'t have an account? '),
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(),
                            ),);
                        },
                        child: Container(
                          child: Text(
                            'Sign up',
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}