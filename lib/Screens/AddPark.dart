import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:greenspace/Screens/ManagerDashboard.dart';
import 'package:greenspace/Widgets/text_field.dart';

class AddPark extends StatefulWidget {
  const AddPark({super.key});

  @override
  State<AddPark> createState() => _AddParkState();
}

class _AddParkState extends State<AddPark> {
  TextEditingController _parkNameController = TextEditingController();
  TextEditingController _parkLocationController = TextEditingController();
  TextEditingController _parkDescriptionController = TextEditingController();
  TextEditingController _parkSizeController = TextEditingController();
  TextEditingController _parkcontactController = TextEditingController();
  TextEditingController _parkMotoController = TextEditingController();
  TextEditingController _date = TextEditingController();
  TextEditingController _time = TextEditingController();
  String? helpCategory;
  int _selectedIndex = 1;

  // add Park to the database
  Future addPark() async {
    User? user = FirebaseAuth.instance.currentUser;
    try {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('Adding Park...'),
              ],
            ),
          );
        },
      );

      String managerUid = user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(managerUid).update({
        'parks': FieldValue.arrayUnion([
          {
            'name': _parkNameController.text,
            'location': _parkLocationController.text,
            'description': _parkDescriptionController.text,
            'size': _parkSizeController.text,
            'contact': _parkcontactController.text,
            'moto': _parkMotoController.text,
            'date': _date.text,
            'time': _time.text,
            'helpCategory': helpCategory,
            'candidates': [],  // Initialize an empty array for candidates
            // unique id for the park
            'Id': DateTime.now().millisecondsSinceEpoch.toString(),
          }
        ]),
      });


      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Park added successfully'),
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      height: 60,
                      width: 60,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Park Details',
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ), // SizedBox
                TextFieldInput(
                    textEditingController: _parkNameController,
                    hintText: 'Name',
                    textInputType: TextInputType.name,
                    isPass: false),
                SizedBox(
                  height: 12,
                ), // SizedBox
                TextFieldInput(
                    textEditingController: _parkLocationController,
                    hintText: 'Location',
                    textInputType: TextInputType.streetAddress,
                    isPass: false),
                SizedBox(
                  height: 12,
                ), // SizedBox
                Container(
                  color: Colors.white,
                  child: DropdownButtonFormField<String>(
                    value: helpCategory,
                    onChanged: (String? value) {
                      setState(() {
                        helpCategory = value!;
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                      isDense: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: Colors.grey,
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
                      hintText: 'Help Category',
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    items: <String>[
                      'Seeds',
                      'Plants',
                      'Fertilizers',
                      'Volunteers',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                TextFieldInput(textEditingController: _parkMotoController, hintText: 'Help Moto', textInputType: TextInputType.text, isPass: false),
                SizedBox(
                  height: 12,
                ),
                // Big Text Field for Description
                Container(
                  color: Colors.white,
                  child: TextField(
                    controller: _parkDescriptionController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      isDense: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      hintText: 'Description',
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),// SizedBox
                TextFieldInput(
                    textEditingController: _parkSizeController,
                    hintText: 'Park Size',
                    textInputType: TextInputType.number,
                    isPass: false),
                SizedBox(
                  height: 12,
                ), // SizedBox
                TextFieldInput(
                    textEditingController: _parkcontactController,
                    hintText: 'Contact No',
                    textInputType: TextInputType.phone,
                    isPass: false),
                SizedBox(
                  height: 12,
                ), // SizedBox

                // date and time text field in one row
                Row(
                  children: [
                    Expanded(
                      child: TextFieldInput(
                          textEditingController: _date,
                          hintText: 'Date',
                          textInputType: TextInputType.datetime,
                          isPass: false),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: TextFieldInput(
                          textEditingController: _time,
                          hintText: 'Time',
                          textInputType: TextInputType.datetime,
                          isPass: false),
                    ),
                  ],
                ),

                SizedBox(
                  height: 24,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      addPark();
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
                      'Add Park',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: GNav(
            selectedIndex: _selectedIndex,
            backgroundColor: Colors.black,
            activeColor: Colors.white,
            color: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            gap: 8,
            padding: EdgeInsets.all(12),
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
                onPressed: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManagerDashboard(),
                    ),
                  );
                },
              ),
              GButton(
                icon: Icons.add,
                text: 'Add Park',
                onPressed: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
              ),
              GButton(
                icon: Icons.chat,
                text: 'Chat',
                onPressed: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => ChatBot(),
                  //   ),
                  // );
                },
              ),
              GButton(
                icon: Icons.person,
                text: 'Jobs',
                onPressed: () {
                  setState(() {
                    _selectedIndex = 3;
                  });
                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
