import 'package:flutter/material.dart';

class CommandHistoryWidget extends StatelessWidget {
  final List? lastCommand;

  const CommandHistoryWidget({super.key, this.lastCommand});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Command Received:'),
        ListView.builder(
            shrinkWrap: true,
            itemCount: lastCommand?.length ?? 0,
            itemBuilder: (_, i) {
              return Text(lastCommand![i] ?? 'No commands yet');
            })
      ],
    );
  }
}
