import 'package:flutter/material.dart';

class ConnectionStatusWidget extends StatelessWidget {
  final bool isConnected;

  const ConnectionStatusWidget({super.key, required this.isConnected});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(isConnected ? Icons.cloud_done : Icons.cloud_off,
            color: isConnected ? Colors.green : Colors.red),
        const SizedBox(width: 8),
        Text(isConnected ? 'Connected' : 'Disconnected'),
      ],
    );
  }
}
