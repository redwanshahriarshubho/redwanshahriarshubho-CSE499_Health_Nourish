import 'package:flutter/material.dart';
import '../services/web_socket_service.dart';

class WebSocketProvider with ChangeNotifier {
  late final WebSocketService _webSocketService;
  String _latestData = ''; // Stores the latest message received from the WebSocket

  // Constructor to initialize WebSocketService and listen to the WebSocket stream
  WebSocketProvider(String url) {
    _webSocketService = WebSocketService(url);

    // Listen to the WebSocket stream
    _webSocketService.stream.listen(
          (data) {
        _latestData = data; // Update the latest data received
        notifyListeners(); // Notify listeners of the change
      },
      onError: (error) {
        debugPrint('WebSocket Error: $error'); // Log the error
      },
      onDone: () {
        debugPrint('WebSocket connection closed.'); // Log when connection is closed
      },
    );
  }

  // Getter for the latest data received
  String get latestData => _latestData;

  // Getter for the WebSocket stream
  Stream<String> get webSocketStream => _webSocketService.stream;

  // Method to send a message through the WebSocket
  void sendMessage(String message) {
    _webSocketService.sendMessage(message);
  }

  // Dispose method to clean up resources
  @override
  void dispose() {
    _webSocketService.dispose(); // Dispose the WebSocketService
    super.dispose();
  }
}
