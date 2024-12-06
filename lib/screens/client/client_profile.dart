import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Icon(Icons.person, color: Colors.orange),
            SizedBox(width: 8),
            Text(
              'Profile',
              style: TextStyle(color: Colors.orange),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.black,
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileOption(
              context,
              icon: Icons.account_circle,
              title: "Profile",
              onTap: () {
                // Navigate to Profile details page
              },
            ),
            _buildProfileOption(
              context,
              icon: Icons.lock,
              title: "Change Password",
              onTap: () {
                // Navigate to Change Password page
              },
            ),
            _buildProfileOption(
              context,
              icon: Icons.directions_car,
              title: "Add Car",
              onTap: () {
                // Navigate to Add Car page
              },
            ),
            _buildProfileOption(
              context,
              icon: Icons.logout,
              title: "Logout",
              onTap: () {
                // Perform logout action
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(BuildContext context,
      {required IconData icon, required String title, required VoidCallback onTap}) {
    return Card(
      color: Color(0xFF1A1A1A), // Dark grey card background
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange),
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.orange, size: 16),
        onTap: onTap,
      ),
    );
  }
}
