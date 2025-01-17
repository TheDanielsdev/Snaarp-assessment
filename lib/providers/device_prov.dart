import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:device_info_plus/device_info_plus.dart';

final deviceProvider =
    StateNotifierProvider<DeviceNotifier, DeviceState>((ref) {
  return DeviceNotifier();
});

final container = ProviderContainer();
final batteryLevelProv = StateProvider<String>((ref) => "0");

class DeviceNotifier extends StateNotifier<DeviceState> {
  DeviceNotifier() : super(DeviceState.initial()) {
    getBatteryLevel();
    _fetchDeviceInfo();
  }

  Future<void> _fetchDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();

    if (state.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      state = state.copyWith(
        batteryLevel: container.read(batteryLevelProv.notifier).state,
        storageUsage: await _getStorageUsage(),
        model: androidInfo.model,
        platformVersion: androidInfo.version.sdkInt.toString(),
      );
    } else {
      // iOS
    }
  }

  // Future<int> _getBatteryLevel() async {
  //   // Implementation for battery level
  //   return 50; // Placeholder
  // }

  Future<String> _getStorageUsage() async {
    // Implementation for storage usage
    return "50% used"; // Placeholder
  }

  void updateStats() {
    _fetchDeviceInfo();
  }
}

class DeviceState {
  final bool isAndroid;
  final String batteryLevel;
  final String storageUsage;
  final String model;
  final String platformVersion;

  DeviceState({
    required this.isAndroid,
    required this.batteryLevel,
    required this.storageUsage,
    required this.model,
    required this.platformVersion,
  });

  factory DeviceState.initial() => DeviceState(
        isAndroid: true, // Configured for Android
        batteryLevel: '0',
        storageUsage: '0%',
        model: 'Unknown',
        platformVersion: 'Unknown',
      );

  DeviceState copyWith({
    bool? isAndroid,
    String? batteryLevel,
    String? storageUsage,
    String? model,
    String? platformVersion,
  }) {
    return DeviceState(
      isAndroid: isAndroid ?? this.isAndroid,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      storageUsage: storageUsage ?? this.storageUsage,
      model: model ?? this.model,
      platformVersion: platformVersion ?? this.platformVersion,
    );
  }
}

Future<void> getBatteryLevel() async {
  const platform = MethodChannel('com.example.battery/battery_level');

  try {
    final int result = await platform.invokeMethod('getBatteryLevel');
    container.read(batteryLevelProv.notifier).state = "$result";
  } on PlatformException catch (e) {
    container.read(batteryLevelProv.notifier).state =
        "Failed to get battery level: '${e.message}'.";
  }
}
