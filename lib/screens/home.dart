import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:snaarp/screens/widgets/cmd_history.dart';
import 'package:snaarp/screens/widgets/connectn_status.dart';
import 'package:snaarp/screens/widgets/device_stat.dart';
import 'package:snaarp/screens/widgets/location.dart';
import 'package:snaarp/service/sock_srv.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wsState = ref.watch(websocketProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ConnectionStatusWidget(isConnected: wsState.isConnected),
              CommandHistoryWidget(lastCommand: wsState.lastCommand),
              const LocationWidget(),
              const DeviceStatsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
