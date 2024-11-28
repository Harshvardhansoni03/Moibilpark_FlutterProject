import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobil_park/screens/client/client_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'University Parking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ParkingHomePage(),
    );
  }
}

class ParkingHomePage extends StatefulWidget {
  @override
  _ParkingHomePageState createState() => _ParkingHomePageState();
}

class _ParkingHomePageState extends State<ParkingHomePage> {
  // Firebase Firestore collection reference
  final CollectionReference parkingSpaces =
      FirebaseFirestore.instance.collection('Parking_Spaces');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parking Spaces'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Navigate to the Profile Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: parkingSpaces.snapshots(), // Stream data from Firebase
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No parking spaces available'));
          }

          final spaces = snapshot.data!.docs;

          return ListView.builder(
            itemCount: spaces.length,
            itemBuilder: (context, index) {
              final space = spaces[index];
              final capacity = space['Capacity'];
              final occupied = space['Occupied'];
              final spaceName = space['SpaceName'];

              // Calculate available slots
              final available = capacity - occupied;

              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text('Space: $spaceName'),
                  subtitle: Text('Available Slots: $available/$capacity'),
                  trailing: Icon(
                    available > 0 ? Icons.check_circle : Icons.cancel,
                    color: available > 0 ? Colors.green : Colors.red,
                  ),
                  onTap: available > 0
                      ? () {
                          // Navigate to booking page or show details
                          _showBookingDialog(context, space.id, available);
                        }
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Booking dialog to reserve a parking space
  void _showBookingDialog(BuildContext context, String spaceId, int available) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Reserve Parking Space'),
          content: Text('Do you want to reserve this space?'),
          actions: [
            TextButton(
              onPressed: () async {
                // Reserve parking space (update Firestore)
                await parkingSpaces.doc(spaceId).update({
                  'Occupied': FieldValue.increment(1),
                });
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }
}

// Example Profile Page

