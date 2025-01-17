import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snaarp/providers/location_prov.dart';

class LocationWidget extends ConsumerStatefulWidget {
  const LocationWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LocationWidgetState();
}

class _LocationWidgetState extends ConsumerState<LocationWidget> {
  @override
  Widget build(BuildContext context) {
    final location = ref.watch(locationProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _gtLocation();
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (location.isTracking)
        Text(
            'Tracking: Latitude: ${location.latitude}, Longitude: ${location.longitude}'),
        // const Text('Location Tracking Stopped'),
        // ElevatedButton(
        //   onPressed: () {

        //   },
        //   child: Text(location.isTracking ? 'Stop Tracking' : 'Start Tracking'),
        // ),
      ],
    );
  }

  void _gtLocation() {
    final location = ref.watch(locationProvider);
    if (location.isTracking) {
      ref.read(locationProvider.notifier).stopTracking();
    } else {
      ref.read(locationProvider.notifier).startTracking();
    }
  }
}
