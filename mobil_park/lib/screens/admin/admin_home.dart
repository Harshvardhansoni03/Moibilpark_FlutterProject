// TODO Implement this library.import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class AdminHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Home"),
        backgroundColor: const Color(0xFF252839),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.admin_panel_settings,
              size: 80,
              color: Color(0xFFD7B7A5),
            ),
            const SizedBox(height: 20),
            const Text(
              "Welcome to the Admin Dashboard!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF252839),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Implement logout functionality or other admin actions
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Feature not implemented yet")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD7B7A5),
              ),
              child: const Text(
                "Perform Admin Actions",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
