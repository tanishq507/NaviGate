import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/location.dart';
import '../../utils/api_config.dart';
import '../../utils/logger.dart';

class PlacesApiService {
  static final PlacesApiService _instance = PlacesApiService._internal();
  final String _baseUrl = 'https://maps.googleapis.com/maps/api/place';

  factory PlacesApiService() => _instance;

  PlacesApiService._internal();

  Future<Location?> searchPlaceByText(String query) async {
    try {
      final url = Uri.parse(
          '$_baseUrl/textsearch/json?query=${Uri.encodeComponent(query)}&key=${ApiConfig.googleMapsApiKey}');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' &&
            data['results'] != null &&
            data['results'].isNotEmpty) {
          final place = data['results'][0];
          final location = place['geometry']['location'];

          return Location(
            id: place['place_id'],
            address: place['formatted_address'] ?? query,
            latitude: location['lat'].toDouble(),
            longitude: location['lng'].toDouble(),
            lastSearched: DateTime.now(),
          );
        }
        Logger.warning('No results found for query: $query');
        return null;
      }

      throw Exception('Failed to fetch location: ${response.statusCode}');
    } catch (e) {
      Logger.error('Failed to fetch location from Places API: $e');
      throw Exception('Failed to fetch location from Places API: $e');
    }
  }

  Future<void> initPlacesApi() async {
    try {
      if (ApiConfig.googleMapsApiKey.isEmpty) {
        throw Exception('Google Maps API key is not configured');
      }
      Logger.success('Places API key configured successfully');
    } catch (e) {
      Logger.error('Error initializing Places API: $e');
      throw Exception('Failed to initialize Places API: $e');
    }
  }
}
