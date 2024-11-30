import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import 'scan_qr.dart'; // Replace with your actual QR code scanning screen file path

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MobilPark',
      theme: ThemeData(
        primaryColor: const Color(0xFF1C1F2A),
        scaffoldBackgroundColor: const Color(0xFF1C1F2A),
        textTheme: const TextTheme(
          titleLarge: TextStyle(color: Colors.white, fontSize: 20),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      home: ParkingHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ParkingHomePage extends StatefulWidget {
  @override
  _ParkingHomePageState createState() => _ParkingHomePageState();
}

class _ParkingHomePageState extends State<ParkingHomePage> {
  final CollectionReference parkingSpaces =
      FirebaseFirestore.instance.collection('Parking_Spaces');

  String? latitude;
  String? longitude;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1F2A),
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.directions_car, color: Color(0xFFD7B7A5), size: 36),
            const SizedBox(width: 10),
            const Text(
              'MobilPark',
              style: TextStyle(
                color: Color(0xFFD7B7A5),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            if (latitude != null && longitude != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Latitude: $latitude',
                    style: const TextStyle(color: Colors.white70, fontSize: 20),
                  ),
                  Text(
                    'Longitude: $longitude',
                    style: const TextStyle(color: Colors.white70, fontSize: 20),
                  ),
                ],
              ),
          ],
        ),
      ),
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: parkingSpaces.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(color: Colors.white));
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    'No parking spaces available',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }

              final spaces = snapshot.data!.docs;

              return ListView.builder(
                itemCount: spaces.length,
                itemBuilder: (context, index) {
                  final space = spaces[index];
                  final capacity = space['Capacity'];
                  final occupied = space['Occupied'];
                  final spaceName = space['SpaceName'];

                  final available = capacity - occupied;

                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2F3F),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Space: $spaceName',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Available Slots: $available/$capacity',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: Colors.green,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdateSpaceScreen()),
                );
              },
              child: const Icon(Icons.qr_code_scanner, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}