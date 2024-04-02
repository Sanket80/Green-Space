import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:greenspace/Screens/AddPark.dart';
import 'package:greenspace/Screens/Login.dart';
import 'package:greenspace/Screens/Tasks.dart';
import 'package:greenspace/Widgets/text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  String selectedRole = 'User';
  bool _isLoading = false;

  Future signUp() async{
    try{
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('Signing up...'),
              ],
            ),
          );
        },
      );

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Check if the user is registering as a manager
      if (selectedRole == 'Manager') {
        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set({
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'role': selectedRole,
          'uid': FirebaseAuth.instance.currentUser!.uid,
          'parks': [],  // Initialize 'parks' as an empty array for the manager
        });
      } else {
        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set({
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'role': selectedRole,
          'uid': FirebaseAuth.instance.currentUser!.uid,
        });
      }


      if(selectedRole == 'Manager'){
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddPark()));
      }
      else{
        Navigator.push(context, MaterialPageRoute(builder: (context) => Tasks()));
      }

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
                child: Text('Close'),
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
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ), // SizedBox
              Image.asset(
                'assets/logo.png',
                height: 100,
                width: 100,
              ),
              SizedBox(
                height: 20,
              ), // SizedBox
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Create an Account',
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 6,
              ), // SizedBox
              TextFieldInput(
                  textEditingController: _nameController,
                  hintText: 'Name',
                  textInputType: TextInputType.name,
                  isPass: false),
              SizedBox(
                height: 12,
              ), // SizedBox
              TextFieldInput(
                  textEditingController: _emailController,
                  hintText: 'Email',
                  textInputType: TextInputType.emailAddress,
                  isPass: false),
              SizedBox(
                height: 12,
              ), // SizedBox
              TextFieldInput(
                  textEditingController: _phoneController,
                  hintText: 'Phone',
                  textInputType: TextInputType.phone,
                  isPass: false),
              SizedBox(
                height: 12,
              ), // SizedBox
              TextFieldInput(
                  textEditingController: _passwordController,
                  hintText: 'Password',
                  textInputType: TextInputType.visiblePassword,
                  isPass: true),
              SizedBox(
                height: 12,
              ), // SizedBox
              TextFieldInput(
                  textEditingController: _confirmPasswordController,
                  hintText: 'Confirm Password',
                  textInputType: TextInputType.visiblePassword,
                  isPass: true),
              SizedBox(
                height: 12,
              ),
              // Dropdown for selecting user type
              Container(
                color: Colors.white,
                child: DropdownButtonFormField<String>(
                  value: selectedRole,
                  onChanged: (String? value) {
                    setState(() {
                      selectedRole = value!;
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                    isDense: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.black87,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    hintText: 'Role',
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  items: <String>[
                    'Manager',
                    'User',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),

              SizedBox(
                height: 24,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    signUp();
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
                    'Register',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 56,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text('Already have an account?'),
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
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
            ],
          ),
        ),
      ),
    ));
  }
}
