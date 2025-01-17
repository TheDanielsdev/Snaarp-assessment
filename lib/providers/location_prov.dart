import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

final locationProvider =
    StateNotifierProvider<LocationNotifier, LocationState>((ref) {
  return LocationNotifier();
});

class LocationNotifier extends StateNotifier<LocationState> {
  LocationNotifier() : super(LocationState.initial());

  void startTracking() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      state = state.copyWith(error: 'Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        state = state.copyWith(error: 'Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      state = state.copyWith(
          error:
              'Location permissions are permanently denied, we cannot request permissions.');
      return;
    }

    state = state.copyWith(isTracking: true);
    _updateLocation();
  }

  void stopTracking() {
    state = state.copyWith(isTracking: false);
  }

  void _updateLocation() async {
    if (state.isTracking) {
      Position position = await Geolocator.getCurrentPosition(
          // ignore: deprecated_member_use
          desiredAccuracy: LocationAccuracy.high);
      state = state.copyWith(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      Future.delayed(const Duration(seconds: 5),
          _updateLocation); // Update every 5 seconds
    }
  }
}

class LocationState {
  final bool isTracking;
  final double latitude;
  final double longitude;
  final String? error;

  LocationState({
    required this.isTracking,
    required this.latitude,
    required this.longitude,
    this.error,
  });

  factory LocationState.initial() => LocationState(
        isTracking: false,
        latitude: 0.0,
        longitude: 0.0,
      );

  LocationState copyWith({
    bool? isTracking,
    double? latitude,
    double? longitude,
    String? error,
  }) {
    return LocationState(
      isTracking: isTracking ?? this.isTracking,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      error: error ?? this.error,
    );
  }
}
