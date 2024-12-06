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
  bool isProcessing = false; // Prevent multiple scans

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Scan Parking QR Code'),
        backgroundColor: Colors.black,
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
          // Black overlay with transparent square for scanning area
          _buildOverlay(),
          if (isProcessing)
            Center(
              child: Container(
                color: Colors.black.withOpacity(0.7),
                child: const CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  // Builds the black overlay with a transparent square in the center
  Widget _buildOverlay() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double overlayWidth = constraints.maxWidth;
        final double overlayHeight = constraints.maxHeight;
        const double squareSize = 200; // Size of the transparent square

        return Stack(
          children: [
            // Top black area
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: (overlayHeight - squareSize) / 2,
              child: Container(color: Colors.black),
            ),
            // Left black area
            Positioned(
              top: (overlayHeight - squareSize) / 2,
              left: 0,
              width: (overlayWidth - squareSize) / 2,
              height: squareSize,
              child: Container(color: Colors.black),
            ),
            // Right black area
            Positioned(
              top: (overlayHeight - squareSize) / 2,
              right: 0,
              width: (overlayWidth - squareSize) / 2,
              height: squareSize,
              child: Container(color: Colors.black),
            ),
            // Bottom black area
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: (overlayHeight - squareSize) / 2,
              child: Container(color: Colors.black),
            ),
            // Green border for transparent scanning square
            Center(
              child: Container(
                width: squareSize,
                height: squareSize,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 3),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Handles QR Code scanning and processing
  Future<void> _handleQrCodeScanned(BuildContext context, String qrCodeData) async {
    try {
      final segments = qrCodeData.split(':');
      if (segments.length < 3) {
        _showSnackBar(context, 'Invalid QR Code', Colors.red);
        setState(() => isProcessing = false);
        return;
      }

      final String type = segments[0]; // "Entry" or "Exit"
      final String spaceId = segments[2];

      // Fetch the parking space document
      final DocumentSnapshot parkingSpace = await _firestore
          .collection('Parking_Spaces')
          .doc(spaceId)
          .get();

      if (!parkingSpace.exists) {
        _showSnackBar(context, 'Parking space not found', Colors.red);
        setState(() => isProcessing = false);
        return;
      }

      int occupied = parkingSpace['Occupied'] ?? 0; // Current Occupied count
      if (type == 'Entry') {
        occupied += 1;
      } else if (type == 'Exit') {
        if (occupied > 0) {
          occupied -= 1;
        } else {
          _showSnackBar(context, 'No vehicles to exit', Colors.orange);
          setState(() => isProcessing = false);
          return;
        }
      }

      // Update the parking space document
      await _firestore.collection('Parking_Spaces').doc(spaceId).update({
        'Occupied': occupied,
      });

      // Success message and navigate back
      _navigateToHomeWithMessage(
        context,
        'Parking space updated successfully! Current Occupied: $occupied',
        Colors.green,
      );
    } catch (e) {
      _showSnackBar(context, 'Error: ${e.toString()}', Colors.red);
      setState(() => isProcessing = false);
    }
  }

  // Navigate back with a success message
  void _navigateToHomeWithMessage(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
    Navigator.of(context).pop(); // Navigate back to the previous screen
  }

  // Show a snackbar with a custom message
  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }
}
