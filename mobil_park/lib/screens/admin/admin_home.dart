import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobil_park/screens/admin/admin_add_space.dart';

class AdminHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF252839),
      appBar: AppBar(
        title: Text(
          'Parking Slots Overview',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Parking_Spaces').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No parking spaces available.',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            );
          }

          final parkingSpaces = snapshot.data!.docs;

          // Count total and occupied spaces
          int totalCapacity = 0;
          int totalOccupied = 0;

          for (var space in parkingSpaces) {
            totalCapacity += (space['Capacity'] ?? 0) as int;
            totalOccupied += (space['Occupied'] ?? 0) as int;
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Occupied: $totalOccupied / $totalCapacity',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0, // Reduced spacing
                    mainAxisSpacing: 10.0, // Reduced spacing
                  ),
                  itemCount: parkingSpaces.length,
                  itemBuilder: (context, index) {
                    final space = parkingSpaces[index];
                    final spaceName = space['SpaceName'] ?? 'Unknown';
                    final capacity = space['Capacity'] ?? 0;
                    final occupied = space['Occupied'] ?? 0;

                    final isFull = occupied == capacity;

                    return Padding(
                      padding: const EdgeInsets.all(8.0), // Add padding around each item
                      child: Container(
                        decoration: BoxDecoration(
                          color: isFull ? Colors.redAccent : Color.fromARGB(255, 165, 141, 127),
                          borderRadius: BorderRadius.circular(8), // Reduced radius for smaller corners
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 6,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isFull ? Icons.car_repair : Icons.car_rental,
                              size: 39, // Smaller icon size
                              color: Colors.white70,
                            ),
                            SizedBox(height: 5), // Smaller space between icon and text
                            Text(
                              spaceName,
                              style: TextStyle(
                                fontSize: 24, // Smaller font size for name
                                fontWeight: FontWeight.bold,
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Capacity: $capacity',
                              style: TextStyle(
                                fontSize: 21, // Smaller font size
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Occupied: $occupied',
                              style: TextStyle(
                                fontSize: 21, // Smaller font size
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              isFull ? 'Full' : 'Available',
                              style: TextStyle(
                                fontSize: 21, // Smaller font size
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 26.0, horizontal: 29.0), // Padding for the FloatingActionButton
        child: FloatingActionButton(
          backgroundColor: Color(0xFFD7B7A5),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddSpaceScreen()),
            );
          },
          child: Icon(Icons.add, color: Colors.black),
        ),
      ),
    );
  }
}
