import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManagerDashboard extends StatefulWidget {
  const ManagerDashboard({super.key});

  @override
  State<ManagerDashboard> createState() => _ManagerDashboardState();
}

class _ManagerDashboardState extends State<ManagerDashboard> {
  Future<List<dynamic>> getParksForManagers() async {
    try {
      QuerySnapshot<Map<String, dynamic>> managersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'Manager')
          .get();

      List<dynamic> allParks = [];

      for (QueryDocumentSnapshot<Map<String, dynamic>> managerDoc in managersSnapshot.docs) {
        List<dynamic> parks = managerDoc['parks'] ?? [];
        allParks.addAll(parks);
      }

      return allParks;
    } catch (e) {
      print('Error fetching parks for managers: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Color(0xfff4f4ee),
          child: Column(
            children: [
              AppBar(
                title: Center(child: Text('Parks Created')),
                backgroundColor: Color(0xfff4f4ee),
              ),
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: getParksForManagers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      print('Error: ${snapshot.error}');
                      return Center(child: Text('Error fetching data'));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No parks available'));
                    }

                    final parkList = snapshot.data!;
                    return ListView.builder(
                      itemCount: parkList.length,
                      itemBuilder: (context, index) {
                        final parkData = parkList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) {
                              //       return CompanyDetails();
                              //     },
                              //   ),
                              // );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: Card(
                                color: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.park_outlined,size: 30,),
                                          SizedBox(width: 16),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                parkData['name'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22,
                                                ),
                                              ),
                                              Text(
                                                parkData['location'],
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          // bookmark icon
                                          Spacer(),
                                          IconButton(
                                            icon: Icon(Icons.bookmark_border),
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          // date and time with icon, icon size is 12 and color is grey, text color is grey
                                          Icon(Icons.calendar_today,size: 16,color: Colors.grey,),
                                          SizedBox(width: 4),
                                          Text(
                                            parkData['date'],
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18,
                                            ),
                                          ),
                                          SizedBox(width: 32),
                                          Icon(Icons.access_time,size: 16,color: Colors.grey,),
                                          SizedBox(width: 4),
                                          Text(
                                            parkData['time'],
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Elevated Button which shows the no of candidates applied
                                      SizedBox(height: 12),
                                      Center(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (context) {
                                            //       return CandidatesList();
                                            //     },
                                            //   ),
                                            // );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            primary: Color(0xff436850),
                                            onPrimary: Colors.white,
                                            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                            child: Text(
                                              'Users:- ${parkData['candidates'].length}',
                                              style: TextStyle(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
