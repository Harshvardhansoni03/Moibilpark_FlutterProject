import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';

class AddSpaceScreen extends StatefulWidget {
  const AddSpaceScreen({Key? key}) : super(key: key);

  @override
  _AddSpaceScreenState createState() => _AddSpaceScreenState();
}

class _AddSpaceScreenState extends State<AddSpaceScreen> {
  // Controllers
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _spaceNameController = TextEditingController();

  // Firestore and UUID
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = Uuid();

  // Occupation status
  final int _isOccupied = 0;

  // Key for form validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose controllers
    _capacityController.dispose();
    _spaceNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF252839),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // App Header
                _buildAppHeader(),
                
                // Car Image
                _buildCarImage(),
                
                // Capacity Input
                _buildCapacityField(),
                
                // Space Name Input
                _buildSpaceNameField(),
                
                // Save Button
                _buildSaveButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.directions_car, color: Color(0xFFD7B7A5), size: 36),
          SizedBox(width: 8),
          Text(
            "MobilPark",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFD7B7A5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarImage() {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Image.asset(
        'assets/images/car_r.png',
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildCapacityField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: _capacityController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Parking Capacity',
          prefixIcon: Icon(Icons.format_list_numbered, color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter parking capacity';
          }
          if (int.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSpaceNameField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: _spaceNameController,
        decoration: InputDecoration(
          labelText: 'Parking Space Name',
          prefixIcon: Icon(Icons.drive_eta, color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter parking space name';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ElevatedButton(
        onPressed: _saveParking,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF939185),
          minimumSize: Size(MediaQuery.of(context).size.width * 0.8, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Save Parking Space',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _saveParking() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      // Generate unique identifiers
      final spaceId = _uuid.v4();
      final spaceNameText = _spaceNameController.text.trim();
      final capacityText = _capacityController.text.trim();

      // QR Code data
      final entryQrData = 'Entry:$spaceNameText:$spaceId';
      final exitQrData = 'Exit:$spaceNameText:$spaceId';

      // Save to Firestore
      await _firestore.collection('Parking_Spaces').doc(spaceId).set({
        'id': spaceId,
        'SpaceName': spaceNameText,
        'Capacity': int.parse(capacityText),
        'Occupied': _isOccupied,
        'EntryQRCode': entryQrData,
        'ExitQRCode': exitQrData,
        'CreatedAt': FieldValue.serverTimestamp(),
      });

      // Show QR Codes
      _showQrCodeDialog(context, entryQrData, exitQrData);

      // Reset form
      _capacityController.clear();
      _spaceNameController.clear();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Parking Space "$spaceNameText" Added Successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showQrCodeDialog(BuildContext context, String entryQr, String exitQr) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Parking Space QR Codes'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildQrCodeSection('Entry QR', entryQr),
            const SizedBox(height: 16),
            _buildQrCodeSection('Exit QR', exitQr),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildQrCodeSection(String label, String data) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _safeQrCodeGenerator(data),
      ],
    );
  }

Widget _safeQrCodeGenerator(String data) {
  if (data.isEmpty) {
    return const Text(
      'No QR Data',
      style: TextStyle(color: Colors.red),
    );
  }

  return QrImageView(
  data: data,                           // Content to be encoded in the QR code
  version: QrVersions.auto,             // Automatically determine QR code version
  size: 150.0,                          // Size of the QR code (square)
  backgroundColor: Colors.white,        // Background color
  foregroundColor: Colors.black,        // Foreground (QR code modules) color
  padding: EdgeInsets.all(10),          // 10-pixel padding on all sides
  errorCorrectionLevel: QrErrorCorrectLevel.M,  // Medium error correction level
);
}
}