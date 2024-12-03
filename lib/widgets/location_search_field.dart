import 'package:flutter/material.dart';
import '../services/location_service.dart';
import '../models/location.dart';
import '../utils/logger.dart';
import 'map_preview.dart';

class LocationSearchField extends StatefulWidget {
  final Function(Location) onLocationSelected;
  final String placeholder;

  const LocationSearchField({
    Key? key,
    required this.onLocationSelected,
    this.placeholder = 'Search location',
  }) : super(key: key);

  @override
  _LocationSearchFieldState createState() => _LocationSearchFieldState();
}

class _LocationSearchFieldState extends State<LocationSearchField> {
  final LocationService _locationService = LocationService();
  final TextEditingController _controller = TextEditingController();
  List<Location> _recentLocations = [];
  bool _isLoading = false;
  Location? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _loadRecentLocations();
  }

  Future<void> _loadRecentLocations() async {
    try {
      final locations = await _locationService.getRecentSearches();
      setState(() {
        _recentLocations = locations;
      });
    } catch (e) {
      Logger.error('Failed to load recent locations: $e');
    }
  }

  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final location = await _locationService.searchLocation(query);
      widget.onLocationSelected(location);
      setState(() {
        _selectedLocation = location;
      });
      _controller.clear();
      await _loadRecentLocations();
      Logger.success('Location search completed: ${location.address}');
    } catch (e) {
      Logger.error('Search location error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: widget.placeholder,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : null,
          ),
          onSubmitted: _searchLocation,
        ),
        if (_selectedLocation != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              height: 150,
              child: MapPreview(location: _selectedLocation!),
            ),
          ),
        if (_recentLocations.isNotEmpty)
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            child: Card(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: _recentLocations.length,
                itemBuilder: (context, index) {
                  final location = _recentLocations[index];
                  return ListTile(
                    leading: const Icon(Icons.history),
                    title: Text(
                      location.address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      setState(() {
                        _selectedLocation = location;
                      });
                      widget.onLocationSelected(location);
                    },
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
