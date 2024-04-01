import 'package:flutter/material.dart';

class ParkDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> parkData;
  const ParkDetailsScreen({super.key, required this.parkData});

  @override
  State<ParkDetailsScreen> createState() => _ParkDetailsScreenState();
}

class _ParkDetailsScreenState extends State<ParkDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text('Park Details'),
          ],
        ),
      ),
    );
  }
}
