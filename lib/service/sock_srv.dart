// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snaarp/providers/app_state.dart';
import 'package:snaarp/providers/device_prov.dart';
import 'package:snaarp/providers/location_prov.dart';
import 'package:snaarp/screens/login.dart';
import 'package:snaarp/utils/utils.dart';
import 'package:socket_io_client/socket_io_client.dart';

final navigatorKey = container.read(navigatorKeyProvider);
final websocketProvider =
    StateNotifierProvider<WebSocketStateNotifier, WebSocketState>((ref) {
  return WebSocketStateNotifier();
});

class WebSocketStateNotifier extends StateNotifier<WebSocketState> {
  WebSocketStateNotifier() : super(WebSocketState.initial()) {
    connect();
  }

  late Socket _socket;

  List listOfCmds = [];

  void connect() {
    _socket = io('http://test-websocket.snaarp.com:3100', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    _socket.connect();

    _socket.onConnect((_) {
      state = state.copyWith(isConnected: true);
    });

    _socket.onDisconnect((_) {
      state = state.copyWith(isConnected: false);
    });

    _socket.on('logout', (_) {
      Navigator.pushAndRemoveUntil(
        container.read(navigatorKeyProvider).currentContext!,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
      listOfCmds.add('logout');
      state = state.copyWith(lastCommand: listOfCmds);
    });
    _socket.on('shutdown', (_) {
      simulateShutdown();
      listOfCmds.add('shutdown');
      state = state.copyWith(lastCommand: listOfCmds);
    });
    _socket.on('startLocation', (_) {
      container.read(locationProvider.notifier).startTracking();
      listOfCmds.add('startLocation');
      state = state.copyWith(lastCommand: listOfCmds);
    });
    _socket.on('stopLocation', (_) {
      container.read(locationProvider.notifier).stopTracking();
      listOfCmds.add('stopLocation');
      state = state.copyWith(lastCommand: listOfCmds);
    });
    _socket.on('getStats', (_) {
      container.read(deviceProvider.notifier).updateStats();
      listOfCmds.add('getStats');
      state = state.copyWith(lastCommand: listOfCmds);
    });
    _socket.on('config', (data) {
      state = state.copyWith(configData: data, lastCommand: listOfCmds);
      configureApp(data);
    });
  }

  // void sendCommand(String event, dynamic data) {
  //   _socket.emit(event, data);
  // }
}

class WebSocketState {
  final bool isConnected;
  final List? lastCommand;
  final Map<String, dynamic>? configData;

  WebSocketState({
    required this.isConnected,
    this.lastCommand,
    this.configData,
  });

  factory WebSocketState.initial() => WebSocketState(isConnected: false);

  WebSocketState copyWith({
    bool? isConnected,
    List? lastCommand,
    Map<String, dynamic>? configData,
  }) {
    return WebSocketState(
      isConnected: isConnected ?? this.isConnected,
      lastCommand: lastCommand ?? this.lastCommand,
      configData: configData ?? this.configData,
    );
  }
}
