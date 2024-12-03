import 'package:cab_booking_app/services/api/place_api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Load environment variables
    await dotenv.load(fileName: ".env");

    final placesService = PlacesApiService();
    await placesService.initPlacesApi();
    Logger.success('App initialized successfully');
  } catch (e) {
    Logger.error('Failed to initialize app: $e');
  }

  runApp(const CabBookingApp());
}

class CabBookingApp extends StatelessWidget {
  const CabBookingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cab Booking App',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
