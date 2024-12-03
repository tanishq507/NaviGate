// import 'package:flutter_google_maps_webservices/places.dart' as gmaps;

// import '../../models/location.dart';
// import '../../utils/api_config.dart';

// class GoogleMapsApiService {
//   final gmaps.GoogleMapsPlaces places =
//       gmaps.GoogleMapsPlaces(apiKey: ApiConfig.googleMapsApiKey);

//   Future<Location?> searchPlaceByText(String query) async {
//     try {
//       final response = await places.searchByText(query);

//       if (response.status == "OK" && response.results.isNotEmpty) {
//         final place = response.results.first;
//         return Location(
//           id: place.placeId,
//           address: place.formattedAddress ?? query,
//           latitude: place.geometry!.location.lat,
//           longitude: place.geometry!.location.lng,
//           lastSearched: DateTime.now(),
//         );
//       }
//       return null; // No results found
//     } catch (e) {
//       throw Exception('Failed to fetch location: ${e.toString()}');
//     }
//   }
// }
