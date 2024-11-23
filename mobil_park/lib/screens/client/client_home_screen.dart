import 'package:flutter/material.dart';

class ClientHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Client Home"),
      ),
      body: Center(
        child: Text("Welcome to the Client Home Screen!"),
      ),
    );
  }
}
