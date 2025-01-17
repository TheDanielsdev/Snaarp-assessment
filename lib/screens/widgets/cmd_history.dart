import 'package:flutter/material.dart';

class CommandHistoryWidget extends StatelessWidget {
  final String? lastCommand;

  const CommandHistoryWidget({super.key, this.lastCommand});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Command Received:'),
        Text(lastCommand ?? 'None'),
      ],
    );
  }
}
