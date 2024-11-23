import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobil_park/screens/admin/admin_add_space.dart';

class AdminHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF252839),
      appBar: AppBar(
        backgroundColor: Color(0xFFD7B7A5),
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
                style: TextStyle(color: Colors.white, fontSize: 18),
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
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemCount: parkingSpaces.length,
                  itemBuilder: (context, index) {
                    final space = parkingSpaces[index];
                    final spaceName = space['SpaceName'] ?? 'Unknown';
                    final capacity = space['Capacity'] ?? 0;
                    final occupied = space['Occupied'] ?? 0;

                    final isFull = occupied == capacity;

                    return Container(
                      decoration: BoxDecoration(
                        color: isFull ? Colors.redAccent : Color(0xFFD7B7A5),
                        borderRadius: BorderRadius.circular(12),
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
                            size: 40,
                            color: Colors.white,
                          ),
                          SizedBox(height: 10),
                          Text(
                            spaceName,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Capacity: $capacity',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Occupied: $occupied',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            isFull ? 'Full' : 'Available',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFD7B7A5),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddSpaceScreen()),
          );
        },
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
