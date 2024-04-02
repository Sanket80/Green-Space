import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenspace/Screens/ParkDetail.dart';

class Tasks extends StatefulWidget {
  const Tasks({Key? key}) : super(key: key);

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {

  Future<QuerySnapshot<Map<String, dynamic>>> getTaskData() async {
    return FirebaseFirestore.instance.collection('parks').get();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Color(0xfff4f4ee),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
                FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  future: getTaskData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return Text('Error fetching data');
                    }

                    if (!snapshot.hasData ||
                        snapshot.data == null ||
                        snapshot.data!.docs.isEmpty) {
                      return Text('No data available');
                    }

                    final parkList = snapshot.data!.docs;

                    return SizedBox(
                      height: 600,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: parkList.length,
                        itemBuilder: (context, index) {
                          final parkData = parkList[index].data()!;

                          return Container(
                            width: 320,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            margin: EdgeInsets.only(right: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 180,
                                          width: double.infinity,
                                          // image form asset
                                          child: Container(
                                              child: Image.asset(
                                            'assets/man.png',
                                            height: 150,
                                            width: 150,
                                          )),
                                          decoration: BoxDecoration(
                                            color: Color(0xffDBFDD6),
                                            // border radius for top left and top right only
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                parkData['moto'] ?? '',
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 2,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                parkData['name'] ?? '',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                parkData['description'] ?? '',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey,
                                                ),
                                                maxLines: 6,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.date_range,
                                                        color: Colors.grey,
                                                        size: 16,
                                                      ),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        parkData['date'] ??
                                                            '',
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.access_time,
                                                        color: Colors.grey,
                                                        size: 16,
                                                      ),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        parkData['time'] ??
                                                            '',
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.location_on,
                                                        color: Colors.grey,
                                                        size: 16,
                                                      ),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        parkData[
                                                                'location'] ??
                                                            '',
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              // 3 circular avatars in a row with text in between them
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(color: Colors.grey, width: 2),
                                                    ),
                                                    child: CircleAvatar(
                                                      radius: 24,
                                                      backgroundColor: Colors.white,
                                                      child: Text(
                                                        '+10',
                                                        style: TextStyle(color: Colors.grey),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 25),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(color: Colors.black, width: 2),
                                                    ),
                                                    child: CircleAvatar(
                                                      radius: 24,
                                                      backgroundColor: Color(0xffDBFDD6),
                                                      child: Text(
                                                        '+20',
                                                        style: TextStyle(color: Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 25),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(color: Colors.grey, width: 2),
                                                    ),
                                                    child: CircleAvatar(
                                                      radius: 24,
                                                      backgroundColor: Colors.white,
                                                      child: Text(
                                                        '+30',
                                                        style: TextStyle(color: Colors.grey),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 20),

                                              // Elevated Button
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {},
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal: 14,
                                                              vertical: 12),
                                                      child: Text(
                                                        'Join Task',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: Color(
                                                          0xff436850), // Background color
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                8), // Adjust the radius as per your preference
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
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
