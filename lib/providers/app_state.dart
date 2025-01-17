import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snaarp/service/sock_srv.dart';

final navigatorKeyProvider = Provider<GlobalKey<ScaffoldMessengerState>>((ref) {
  return GlobalKey<ScaffoldMessengerState>();
});

// final socketProvider = Provider<SocketService>((ref) {
//   return SocketService();
// });

// final commandHistoryProvider = StateProvider<List<String>>((ref) => []);

// final connectionStatusProvider =
//     StateProvider<String>((ref) => "Connecting...");

// final geoLocationProvider =
//     StateProvider<String>((ref) => "Tracking not active");

// final deviceStatsProvider = StateProvider<String>((ref) => "");

// final configProvider = StateProvider<Map<String, bool>>((ref) => {
//       'notifications': false,
//       'backgroundProcess': false,
//     });




// import 'package:flutter/material.dart';
// import 'package:snaarp/service/websck_srv.dart';

// class AppState extends ChangeNotifier {
//   final WebSocketService _webSocketService;

//   bool _connected = false;
//   final List<String> _commandLogs = [];

//   AppState(this._webSocketService) {
//     _webSocketService.connect(_onMessageReceived);
//     _connected = true;
//   }

//   bool get connected => _connected;
//   List<String> get commandLogs => _commandLogs;

//   void _onMessageReceived(String message) {
//     _commandLogs.add(message);
//     notifyListeners();
//   }

//   void disconnect() {
//     _webSocketService.disconnect();
//     _connected = false;
//     notifyListeners();
//   }
// }
