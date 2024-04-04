import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:greenspace/Screens/ParkDetail.dart';

class Tasks extends StatefulWidget {
  const Tasks({Key? key}) : super(key: key);

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  Future<List<dynamic>> getAllParksForManagers() async {
    try {
      QuerySnapshot<Map<String, dynamic>> managersSnapshot =
      await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'Manager')
          .get();

      List<dynamic> allParks = [];

      print('Total managers found: ${managersSnapshot.size}');

      for (QueryDocumentSnapshot<Map<String, dynamic>> managerDoc
      in managersSnapshot.docs) {
        String managerUid = managerDoc['uid'];
        print('Fetching parks for manager with uid: $managerUid');

        DocumentSnapshot<Map<String, dynamic>> parksSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(managerUid).get();

        List<dynamic> parks = parksSnapshot.data()?['parks'] ?? [];
        allParks.addAll(parks);
      }

      print('Total parks fetched: ${allParks.length}');

      return allParks;
    } catch (e) {
      print('Error fetching parks for managers: $e');
      return [];
    }
  }

  Future<void> joinParkTask(String parkId) async {
    try {
      String? userName;
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        // Fetch the user's name
        DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
        userName = userSnapshot['name'];

        if (userName != null) {
          print('User name: $userName');

          // Fetch all managers
          QuerySnapshot managersSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .where('role', isEqualTo: 'Manager')
              .get();

          if (managersSnapshot.docs.isNotEmpty) {
            for (var managerDoc in managersSnapshot.docs) {
              List<dynamic>? parks = (managerDoc.data() as Map<String, dynamic>?)?['parks'] as List<dynamic>?;

              if (parks != null) {
                // Find the park by its Id in the manager's 'parks' array
                for (int i = 0; i < parks.length; i++) {
                  if (parks[i]['Id'] == parkId) {
                    print('Updating candidates array for park with Id: $parkId');

                    // Update the 'candidates' array locally
                    parks[i]['candidates'].add(userName);

                    // Update the 'parks' array in the manager document
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(managerDoc.id)
                        .update({'parks': parks});

                    print('User added to the park successfully');
                    return;
                  }
                }
              }
            }
            print('Park with Id $parkId does not exist for any manager');
          } else {
            print('No managers found');
          }
        }
      } else {
        print('User not found');
      }
    } catch (e) {
      print('Error adding user to the park: $e');
    }
  }

  // random color function, i will provide the color code and i want like 1 card to have 1 color and the next card to have another color
  Color randomColor(int index) {
    List<Color> colorList = [
      Color(0xffDBFDD6),
      Color(0xffFDD2D2),
      // Color(0xffFDD2F5),
      Color(0xffD2F5FD),
      Color(0xffF5F5D2),
      Color(0xffD2F5D2),
      // Color(0xffD2D2D2),
      Color(0xffF5F5F5),
    ];

    int uniqueSeed = index + DateTime.now().second;
    return colorList[uniqueSeed % colorList.length];
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
                FutureBuilder<List<dynamic>>(
                  future: getAllParksForManagers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      print('Error: ${snapshot.error}');
                      return Text('Error fetching data');
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      print('No data fetched');
                      return Text('No data available');
                    }

                    final parkList = snapshot.data!;
                    print('Fetched ${parkList.length} parks');

                    return SizedBox(
                      height: 630,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: parkList.length,
                        itemBuilder: (context, index) {
                          final parkData = parkList[index];

                          return Container(
                            width: 320,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            margin: EdgeInsets.only(right: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
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
                                          child: Image.asset(
                                            'assets/man.png',
                                            height: 150,
                                            width: 150,
                                          ),
                                          decoration: BoxDecoration(
                                            color: randomColor(index),
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
                                              SizedBox(height: 14),
                                              Padding(
                                                padding: const EdgeInsets.all(4.0),
                                                child: Text(
                                                  parkData['description'] ?? '',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey,
                                                  ),
                                                  maxLines: 6,
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                ),
                                              ),
                                              SizedBox(height: 14),
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
                                              SizedBox(height: 14),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: Colors.grey,
                                                          width: 2),
                                                    ),
                                                    child: CircleAvatar(
                                                      radius: 24,
                                                      backgroundColor:
                                                      Colors.white,
                                                      child: Text(
                                                        '+10',
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 25),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: Colors.black,
                                                          width: 2),
                                                    ),
                                                    child: CircleAvatar(
                                                      radius: 24,
                                                      backgroundColor: randomColor(index),
                                                      child: Text(
                                                        '+20',
                                                        style: TextStyle(
                                                            color:
                                                            Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 25),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: Colors.grey,
                                                          width: 2),
                                                    ),
                                                    child: CircleAvatar(
                                                      radius: 24,
                                                      backgroundColor:
                                                      Colors.white,
                                                      child: Text(
                                                        '+30',
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 6),
                                              Text('*These points can be converted to rewards.',style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 10,
                                              ),),
                                              SizedBox(height: 20),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      if (parkData['Id'] != null) {
                                                        joinParkTask(parkData['Id']);
                                                      } else {
                                                        print('Park ID is null');
                                                      }
                                                    },
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 14,
                                                          vertical: 12),
                                                      child: Text(
                                                        'Join Task',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: randomColor(index),
                                                      shape:
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(8),
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
