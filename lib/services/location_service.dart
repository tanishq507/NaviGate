import 'package:cab_booking_app/services/api/place_api_services.dart';

import '../models/location.dart';
import 'database_service.dart';
import '../utils/logger.dart';

class LocationService {
  final PlacesApiService _apiService;
  final DatabaseService _databaseService;

  LocationService({
    PlacesApiService? apiService,
    DatabaseService? databaseService,
  })  : _apiService = apiService ?? PlacesApiService(),
        _databaseService = databaseService ?? DatabaseService();

  Future<Location> searchLocation(String query) async {
    try {
      // Check local cache first
      final cachedLocation = await _databaseService.getLocation(query);
      if (cachedLocation != null) {
        Logger.info('Location found in cache: ${cachedLocation.address}');
        return cachedLocation;
      }

      // If not in cache, fetch from Places API
      final location = await _apiService.searchPlaceByText(query);
      if (location != null) {
        // Save to local cache
        await _databaseService.saveLocation(location);
        Logger.info('New location cached: ${location.address}');
        return location;
      }

      throw Exception('Location not found');
    } catch (e) {
      Logger.error('Error in searchLocation: $e');
      throw Exception('Failed to search location: $e');
    }
  }

  Future<List<Location>> getRecentSearches() async {
    try {
      return await _databaseService.getRecentLocations();
    } catch (e) {
      Logger.error('Error fetching recent searches: $e');
      return [];
    }
  }
}
