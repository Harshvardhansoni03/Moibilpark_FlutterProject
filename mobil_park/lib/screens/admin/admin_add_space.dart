import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddSpaceScreen extends StatelessWidget {
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _spaceNameController = TextEditingController();
  final int _isOccupied = 0; // Default value for Occupied as a number (0)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFD7B7A5),
        title: Text(
          'Add Parking Space',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _capacityController,
              decoration: InputDecoration(labelText: 'Capacity'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _spaceNameController,
              decoration: InputDecoration(labelText: 'Space Name'),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Validate inputs
                  if (_capacityController.text.isEmpty || _spaceNameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please fill in all fields')),
                    );
                    return;
                  }

                  // Save data to Firestore
                  try {
                    await FirebaseFirestore.instance
                        .collection('Parking_Spaces')
                        .add({
                      'Capacity': int.parse(_capacityController.text),
                      'SpaceName': _spaceNameController.text,
                      'Occupied': _isOccupied, // Default value 0
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Parking space added successfully')),
                    );

                    // Navigate back
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add parking space: $e')),
                    );
                  }
                },
                child: Text('Save Space'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
