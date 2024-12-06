import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class UpdateSpaceScreen extends StatefulWidget {
  const UpdateSpaceScreen({Key? key}) : super(key: key);

  @override
  _UpdateSpaceScreenState createState() => _UpdateSpaceScreenState();
}

class _UpdateSpaceScreenState extends State<UpdateSpaceScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isProcessing = false; // To prevent multiple scans at the same time

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF252839),
      appBar: AppBar(
        title: const Text('Scan Parking QR Code'),
        backgroundColor: const Color(0xFF939185),
      ),
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (barcodeCapture) {
              if (isProcessing) return; // Prevent duplicate scans
              final String? code = barcodeCapture.barcodes.first.rawValue;
              if (code != null) {
                setState(() {
                  isProcessing = true;
                });
                _handleQrCodeScanned(context, code);
              }
            },
          ),
          if (isProcessing)
            Center(
              child: Container(
                color: Colors.black.withOpacity(0.7),
                child: const CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  void _handleQrCodeScanned(BuildContext context, String qrCodeData) async {
    try {
      // Parse QR Code Data
      final segments = qrCodeData.split(':');
      if (segments.length < 3) {
        _showSnackBar(context, 'Invalid QR Code', Colors.red);
        setState(() {
          isProcessing = false;
        });
        return;
      }

      final String type = segments[0]; // Expected to be "Entry" or "Exit"
      final String spaceId = segments[2];

      // Fetch the parking space document
      final DocumentSnapshot parkingSpace = await _firestore
          .collection('Parking_Spaces')
          .doc(spaceId)
          .get();

      if (!parkingSpace.exists) {
        _showSnackBar(context, 'Parking space not found', Colors.red);
        setState(() {
          isProcessing = false;
        });
        return;
      }

      // Get the current Occupied count
      int occupied = parkingSpace['Occupied'] ?? 0;
      if (type == 'Entry') {
        occupied += 1; // Increment count for Entry
      } else if (type == 'Exit' && occupied > 0) {
        occupied -= 1; // Decrement count for Exit
      } else if (type == 'Exit' && occupied <= 0) {
        _showSnackBar(context, 'No vehicles to exit', Colors.orange);
        setState(() {
          isProcessing = false;
        });
        return;
      }

      // Update the parking space document
      await _firestore.collection('Parking_Spaces').doc(spaceId).update({
        'Occupied': occupied,
      });

      _showSnackBar(
        context,
        'Parking space updated successfully! Current Occupied: $occupied',
        Colors.green,
      );
    } catch (e) {
      _showSnackBar(context, 'Error: ${e.toString()}', Colors.red);
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }
}