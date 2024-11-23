import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationServices extends StatefulWidget {
  const LocationServices({super.key});

  @override
  State<LocationServices> createState() => _LocationServicesState();
}

class _LocationServicesState extends State<LocationServices> {
  String? latitude;
  String? longitude;
  String? address; // Variable to store the human-readable address

  // Fetch the current location and address
  Future<void> getCurrentLocationAndAddress() async {
    // Check for location permissions
    LocationPermission permissions = await Geolocator.checkPermission();
    if (permissions == LocationPermission.denied ||
        permissions == LocationPermission.deniedForever) {
      print("LocationPermission denied");
      await Geolocator.requestPermission();
    } else {
      // Get the current position
      Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      setState(() {
        latitude = currentPosition.latitude.toString();
        longitude = currentPosition.longitude.toString();
      });

      // Reverse geocode to get the address
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          currentPosition.latitude,
          currentPosition.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          setState(() {
            address =
                "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
          });
        } else {
          setState(() {
            address = "No address available for this location.";
          });
        }
      } catch (e) {
        print("Error in reverse geocoding: $e");
        setState(() {
          address = "Failed to fetch address.";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C2E3A), // Dark background color
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C2E3A),
        title: Row(
          children: [
            Icon(
              Icons.directions_car,
              color: const Color(0xFFE4C2B4),
              size: 34,
            ),
            const SizedBox(width: 8),
            const Text(
              "MobilPark",
              style: TextStyle(
                color: Color(0xFFE4C2B4),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Latitude and Longitude Display
            Text(
              latitude != null && longitude != null
                  ? "Latitude: $latitude\nLongitude: $longitude"
                  : "Your location is not fetched yet.",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFE4C2B4),
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            // Address Display
            Text(
              address ?? "Fetching address...",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFE4C2B4),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30),
            // Grab Location Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE4C2B4), // Button color
                foregroundColor: const Color(0xFF2C2E3A), // Text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: getCurrentLocationAndAddress,
              child: const Text(
                "Grab Location and Address",
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            // Placeholder for additional instructions or info
            const Text(
              "Park effortlessly, anytime, anywhere!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFE4C2B4),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
