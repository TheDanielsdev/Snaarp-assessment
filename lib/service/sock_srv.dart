import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snaarp/providers/device_prov.dart';
import 'package:snaarp/providers/location_prov.dart';
import 'package:socket_io_client/socket_io_client.dart';

final websocketProvider =
    StateNotifierProvider<WebSocketStateNotifier, WebSocketState>((ref) {
  return WebSocketStateNotifier();
});
final container = ProviderContainer();

class WebSocketStateNotifier extends StateNotifier<WebSocketState> {
  WebSocketStateNotifier() : super(WebSocketState.initial()) {
    connect();
  }

  late Socket _socket;

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
      state = state.copyWith(lastCommand: 'logout');
    });
    _socket.on('shutdown', (_) {
      // Handle shutdown command
      state = state.copyWith(lastCommand: 'shutdown');
    });
    _socket.on('startLocation', (_) {
      container.read(locationProvider.notifier).startTracking();
      state = state.copyWith(lastCommand: 'startLocation');
    });
    _socket.on('stopLocation', (_) {
      container.read(locationProvider.notifier).stopTracking();
      state = state.copyWith(lastCommand: 'stopLocation');
    });
    _socket.on('getStats', (_) {
      container.read(deviceProvider.notifier).updateStats();
      state = state.copyWith(lastCommand: 'getStats');
    });
    _socket.on('config', (data) {
      state = state.copyWith(configData: data, lastCommand: 'config');
    });
  }

  // void sendCommand(String event, dynamic data) {
  //   _socket.emit(event, data);
  // }
}

class WebSocketState {
  final bool isConnected;
  final String? lastCommand;
  final Map<String, dynamic>? configData;

  WebSocketState({
    required this.isConnected,
    this.lastCommand,
    this.configData,
  });

  factory WebSocketState.initial() => WebSocketState(isConnected: false);

  WebSocketState copyWith({
    bool? isConnected,
    String? lastCommand,
    Map<String, dynamic>? configData,
  }) {
    return WebSocketState(
      isConnected: isConnected ?? this.isConnected,
      lastCommand: lastCommand ?? this.lastCommand,
      configData: configData ?? this.configData,
    );
  }
}
