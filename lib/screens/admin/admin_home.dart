import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobil_park/screens/admin/admin_add_space.dart';

class AdminHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E2336), // Deeper background color
      appBar: AppBar(
        backgroundColor: Color(0xFF4A5367), // Softer app bar color
        elevation: 0,
        title: Text(
          'Parking Slots Management',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Parking_Spaces').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF5D76E)),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.padding_outlined,
                    size: 100,
                    color: Colors.white54,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'No parking spaces available.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
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
              // Occupancy Summary
              Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF4A5367),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Occupancy',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '$totalOccupied / $totalCapacity',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFFF5D76E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Parking Spaces Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                      childAspectRatio: 0.75, // Adjusted for better height balance
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

                      return _ParkingSpaceCard(
                        spaceName: spaceName,
                        capacity: capacity,
                        occupied: occupied,
                        isFull: isFull,
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(0xFFF5D76E),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddSpaceScreen()),
          );
        },
        icon: Icon(Icons.add, color: Colors.black87),
        label: Text(
          'Add Parking Space',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _ParkingSpaceCard extends StatelessWidget {
  final String spaceName;
  final int capacity;
  final int occupied;
  final bool isFull;

  const _ParkingSpaceCard({
    required this.spaceName,
    required this.capacity,
    required this.occupied,
    required this.isFull,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isFull
              ? [Colors.red.shade800, Colors.red.shade600]
              : [Color(0xFF4A5367), Color(0xFF5D6677)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              isFull ? Icons.car_rental : Icons.local_parking,
              size: 50,
              color: Color(0xFFF5D76E),
            ),
            SizedBox(height: 10),
            Flexible(
              child: Text(
                spaceName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.1,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis, // Prevent overflow
                maxLines: 1,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Capacity: $capacity',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            Text(
              'Occupied: $occupied',
              style: TextStyle(
                fontSize: 14,
                color: isFull ? Colors.red[200] : Color(0xFFF5D76E),
              ),
            ),
            SizedBox(height: 10),
            Text(
              isFull ? 'FULL' : 'AVAILABLE',
              style: TextStyle(
                fontSize: 16,
                color: isFull ? Colors.red[200] : Color(0xFFF5D76E),
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
