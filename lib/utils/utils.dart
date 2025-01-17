import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snaarp/providers/app_state.dart';
import 'package:snaarp/providers/device_prov.dart';

import '../service/sock_srv.dart';

void simulateShutdown() {
  showDialog(
    context: container.read(navigatorKeyProvider).currentContext!,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Device Shutdown"),
        content: const Text("Simulating device shutdown..."),
        actions: <Widget>[
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

//! This is connected to the native api via platform channel @: /home/nurudeen/snaarp/android/app/src/main/kotlin/com/example/snaarp/MainActivity.kt

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

void configureApp(String message) {
  //Simulating form in which commands can come in
  if (message.startsWith("config:")) {
    List<String> parts = message.split(":");
    if (parts.length > 1) {
      String command = parts[1];
      final config = container.read(configProvider.notifier).state;
      switch (command) {
        case "enable_notifications":
          container.read(configProvider.notifier).state = {
            ...config,
            'notifications': true
          };
          break;
        case "disable_notifications":
          container.read(configProvider.notifier).state = {
            ...config,
            'notifications': false
          };
          break;
        case "enable_background_process":
          container.read(configProvider.notifier).state = {
            ...config,
            'backgroundProcess': true
          };
          break;
        case "disable_background_process":
          container.read(configProvider.notifier).state = {
            ...config,
            'backgroundProcess': false
          };
          break;
        default:
          print("Unknown configuration command: $command");
      }

      container
          .read(websocketProvider)
          .lastCommand
          ?.add("Config updated: $message");
    }
  }
}
