import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snaarp/providers/device_prov.dart';

class DeviceStatsWidget extends ConsumerStatefulWidget {
  const DeviceStatsWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DeviceStatsWidgetState();
}

class _DeviceStatsWidgetState extends ConsumerState<DeviceStatsWidget> {
  @override
  Widget build(BuildContext context) {
    final device = ref.watch(deviceProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _gtDeviceDetails();
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Battery: ${device.batteryLevel}%'),
        Text('Storage: ${device.storageUsage}'),
        Text('Model: ${device.model}'),
        Text('Platform Version: ${device.platformVersion}'),
      ],
    );
  }

  _gtDeviceDetails() {
    ref.read(deviceProvider.notifier).updateStats();
  }
}
