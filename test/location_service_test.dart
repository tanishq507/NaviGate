import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../lib/services/location_service.dart';
import '../lib/services/database_service.dart';
import '../lib/models/location.dart';

class MockDatabaseService extends Mock implements DatabaseService {}

void main() {
  late LocationService locationService;
  late MockDatabaseService mockDatabaseService;

  setUp(() {
    mockDatabaseService = MockDatabaseService();
    locationService = LocationService();
  });

  test('searchLocation returns cached location when available', () async {
    final cachedLocation = Location(
      id: 'test_id',
      address: 'Test Address',
      latitude: 0.0,
      longitude: 0.0,
      lastSearched: DateTime.now(),
    );

    when(mockDatabaseService.getLocation('Test Address'))
        .thenAnswer((_) async => cachedLocation);

    final result = await locationService.searchLocation('Test Address');
    expect(result, equals(cachedLocation));
  });

  test('getRecentSearches returns list of recent locations', () async {
    final locations = [
      Location(
        id: 'test_id_1',
        address: 'Test Address 1',
        latitude: 0.0,
        longitude: 0.0,
        lastSearched: DateTime.now(),
      ),
      Location(
        id: 'test_id_2',
        address: 'Test Address 2',
        latitude: 0.0,
        longitude: 0.0,
        lastSearched: DateTime.now(),
      ),
    ];

    when(mockDatabaseService.getRecentLocations())
        .thenAnswer((_) async => locations);

    final result = await locationService.getRecentSearches();
    expect(result.length, equals(2));
    expect(result, equals(locations));
  });
}
