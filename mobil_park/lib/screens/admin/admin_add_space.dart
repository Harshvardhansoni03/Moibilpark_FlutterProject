import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddSpaceScreen extends StatefulWidget {
  @override
  _AddSpaceScreenState createState() => _AddSpaceScreenState();
}

class _AddSpaceScreenState extends State<AddSpaceScreen> {
  final _capacityController = TextEditingController();
  final _spaceNameController = TextEditingController();
  final int _isOccupied = 0; // Default value for Occupied as 0

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF252839),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.directions_car, color: Color(0xFFD7B7A5), size: 36),
                  SizedBox(width: 8),
                  Text("MobilPark",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD7B7A5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    SizedBox(
                      height: 200,
                      child: Image.asset(
                        'assets/images/car_r.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildTextField(
                      controller: _capacityController,
                      hintText: "Capacity",
                      icon: Icons.storage,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _spaceNameController,
                      hintText: "Space Name",
                      icon: Icons.drive_eta,
                    ),
                    const SizedBox(height: 24),
                    _buildSaveButton(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Color(0xFFD7B7A5)),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD7B7A5)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    bool isHovering = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) {
            setState(() {
              isHovering = true;
            });
          },
          onExit: (_) {
            setState(() {
              isHovering = false;
            });
          },
          child: GestureDetector(
            onTap: () async {
              final capacityText = _capacityController.text.trim();
              final spaceNameText = _spaceNameController.text.trim();

              if (capacityText.isEmpty || spaceNameText.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill in all fields'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              try {
                await FirebaseFirestore.instance.collection('Parking_Spaces').add({
                  'Capacity': int.parse(capacityText),
                  'SpaceName': spaceNameText,
                  'Occupied': _isOccupied,
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Parking space added successfully'),
                    backgroundColor: Colors.green,
                  ),
                );

                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to add parking space: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.06,
              decoration: BoxDecoration(
                color: isHovering ? const Color(0xFFA5A599) : const Color(0xFF939185),
                borderRadius: BorderRadius.circular(10),
                boxShadow: isHovering
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: const Center(
                child: Text(
                  "Save Space",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
