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
  String? address;

  Future<bool> checkAndRequestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return false;
      }
    }
    return true;
  }

  Future<void> getCurrentLocationAndAddress() async {
    bool hasPermission = await checkAndRequestLocationPermission();
    if (!hasPermission) {
      setState(() {
        address = "Location permissions are denied. Please enable them.";
      });
      return;
    }

    try {
      Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      setState(() {
        latitude = currentPosition.latitude.toString();
        longitude = currentPosition.longitude.toString();
      });

      await fetchAddressFromCoordinates(
        currentPosition.latitude,
        currentPosition.longitude,
      );
    } catch (e) {
      print("Error in fetching location: $e");
      setState(() {
        address = "Failed to fetch location.";
      });
    }
  }

  Future<void> fetchAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          address =
              "${place.street ?? "N/A"}, ${place.locality ?? "N/A"}, ${place.administrativeArea ?? "N/A"}, ${place.country ?? "N/A"}";
        });
      } else {
        setState(() {
          address = "No address found for the given location.";
        });
      }
    } catch (e) {
      print("Error in reverse geocoding: $e");
      setState(() {
        address = "Error retrieving address.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C2E3A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C2E3A),
        title: const Text(
          "MobilPark",
          style: TextStyle(
            color: Color(0xFFE4C2B4),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              latitude != null && longitude != null
                  ? "Latitude: $latitude\nLongitude: $longitude"
                  : "Your location is not fetched yet.",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFFE4C2B4), fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              address ?? "Fetching address...",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFFE4C2B4), fontSize: 16),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: getCurrentLocationAndAddress,
              child: const Text("Grab Location and Address"),
            ),
          ],
        ),
      ),
    );
  }
}
