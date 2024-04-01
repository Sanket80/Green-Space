import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Tasks extends StatefulWidget {
  const Tasks({Key? key}) : super(key: key);

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  Future<DocumentSnapshot<Map<String, dynamic>>> getTaskData() async {
    return FirebaseFirestore.instance.collection('parks').doc('33TUdn1jrpfqxvkV0J04yfWZde43').get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Color(0xfff4f4ee),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      height: 60,
                      width: 60,
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Tasks',
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: getTaskData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Display a loading indicator
                    }

                    if (snapshot.hasError) {
                      return Text('Error fetching data'); // Display an error message
                    }

                    if (!snapshot.hasData || snapshot.data == null || snapshot.data!.data() == null) {
                      return Text('No data available'); // Display a message if no data is available
                    }

                    final parkData = snapshot.data!.data()!;

                    return Card(
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          parkData['name'] ?? '',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          parkData['moto'] ?? '',
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(Icons.group_add_rounded, size: 34),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Icon(Icons.date_range),
                                  SizedBox(width: 6),
                                  Text(parkData['date'] ?? ''),
                                  SizedBox(width: 20),
                                  Icon(Icons.access_time),
                                  SizedBox(width: 6),
                                  Text(parkData['time'] ?? ''),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Icon(Icons.location_on),
                                  SizedBox(width: 6),
                                  Text(parkData['location'] ?? ''),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Icon(Icons.phone),
                                  SizedBox(width: 6),
                                  Text(parkData['contact'] ?? ''),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
