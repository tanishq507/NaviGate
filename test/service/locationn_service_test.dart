import 'package:cab_booking_app/services/api/place_api_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:cab_booking_app/services/location_service.dart';
import 'package:cab_booking_app/services/database_service.dart';
import 'package:cab_booking_app/models/location.dart';

import '../location_service_test.dart';

@GenerateMocks([DatabaseService, PlacesApiService])
void main() {
  late LocationService locationService;
  late MockDatabaseService mockDatabaseService;
  late MockPlacesApiService mockPlacesApiService;

  setUp(() {
    mockDatabaseService = MockDatabaseService();
    mockPlacesApiService = MockPlacesApiService();
    locationService = LocationService(
      databaseService: mockDatabaseService,
      apiService: mockPlacesApiService,
    );
  });

  group('LocationService Tests', () {
    final testLocation = Location(
      id: 'test_id',
      address: 'Test Address',
      latitude: 0.0,
      longitude: 0.0,
      lastSearched: DateTime.now(),
    );

    test('searchLocation returns cached location when available', () async {
      when(mockDatabaseService.getLocation('Test Address'))
          .thenAnswer((_) async => testLocation);

      final result = await locationService.searchLocation('Test Address');

      expect(result, equals(testLocation));
      verify(mockDatabaseService.getLocation('Test Address')).called(1);
      verifyNever(mockPlacesApiService.searchPlaceByText(any));
    });

    test('searchLocation fetches from API when cache miss', () async {
      when(mockDatabaseService.getLocation('Test Address'))
          .thenAnswer((_) async => null);
      when(mockPlacesApiService.searchPlaceByText('Test Address'))
          .thenAnswer((_) async => testLocation);
      when(mockDatabaseService.saveLocation(testLocation))
          .thenAnswer((_) async => {});

      final result = await locationService.searchLocation('Test Address');

      expect(result, equals(testLocation));
      verify(mockDatabaseService.getLocation('Test Address')).called(1);
      verify(mockPlacesApiService.searchPlaceByText('Test Address')).called(1);
      verify(mockDatabaseService.saveLocation(testLocation)).called(1);
    });

    test('getRecentSearches returns list of recent locations', () async {
      final locations = [
        testLocation,
        Location(
          id: 'test_id_2',
          address: 'Test Address 2',
          latitude: 1.0,
          longitude: 1.0,
          lastSearched: DateTime.now(),
        ),
      ];

      when(mockDatabaseService.getRecentLocations())
          .thenAnswer((_) async => locations);

      final result = await locationService.getRecentSearches();

      expect(result.length, equals(2));
      expect(result, equals(locations));
      verify(mockDatabaseService.getRecentLocations()).called(1);
    });

    test('searchLocation throws exception when API fails', () async {
      when(mockDatabaseService.getLocation('Test Address'))
          .thenAnswer((_) async => null);
      when(mockPlacesApiService.searchPlaceByText('Test Address'))
          .thenThrow(Exception('API Error'));

      expect(
        () => locationService.searchLocation('Test Address'),
        throwsException,
      );
    });
  });
}
