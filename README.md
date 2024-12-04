# NaviGate

A Flutter-based cab booking application with optimized location search functionality. This app implements efficient location caching and integrates with Google Maps for a seamless booking experience.

## Features

- **Location Search Optimization**
  - Local caching of frequently searched locations
  - SQLite database integration for fast retrieval
  - Fallback to Google Maps API for new locations
  - Automatic caching of API responses


## Setup Instructions

1. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd NaviGate
   ```

2. **Environment Setup**
   - Create a `.env` file in the root directory
   - Add your Google Maps API key:
     ```
     GOOGLE_MAPS_API_KEY=your_api_key_here
     ```

3. **Install Dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the Application**
   ```bash
   flutter run
   ```

## Testing

Run the test suite:
```bash
flutter test
```

Key test files:
- `test/location_service_test.dart`: Tests for location search functionality
- `test/services/location_service_test.dart`: Integration tests for services


### Code Organization
- Each file has a single responsibility
- Related functionality is grouped in directories
- Utility functions are extracted into separate files
- Clear separation between UI and business logic

### Error Handling
- Comprehensive error catching
- User-friendly error messages
- Logging for debugging
- Graceful fallbacks
