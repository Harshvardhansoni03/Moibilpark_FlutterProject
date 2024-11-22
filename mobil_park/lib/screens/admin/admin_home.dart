import 'package:flutter/material.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: 4, // Update with the actual number of parking slots
          itemBuilder: (context, index) {
            bool isOccupied = index % 2 == 0; // Example: Alternate slots are occupied

            return Container(
              decoration: BoxDecoration(
                color: isOccupied ? Colors.redAccent : Color(0xFFD7B7A5),
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
                    isOccupied ? Icons.car_repair : Icons.car_rental,
                    size: 40,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Slot ${index + 1}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    isOccupied ? 'Occupied' : 'Available',
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFD7B7A5),
        onPressed: () {
          // Action to add new slots or update slots
        },
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
