import 'package:flutter/material.dart';
import '../widgets/location_search_field.dart';
import '../models/location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Location? pickupLocation;
  Location? dropoffLocation;

  void _handlePickupSelected(Location location) {
    setState(() {
      pickupLocation = location;
    });
  }

  void _handleDropoffSelected(Location location) {
    setState(() {
      dropoffLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Cab'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      LocationSearchField(
                        onLocationSelected: _handlePickupSelected,
                        placeholder: 'Enter pickup location',
                      ),
                      const SizedBox(height: 16),
                      LocationSearchField(
                        onLocationSelected: _handleDropoffSelected,
                        placeholder: 'Enter drop-off location',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (pickupLocation != null && dropoffLocation != null)
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement booking logic
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Book Now',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
