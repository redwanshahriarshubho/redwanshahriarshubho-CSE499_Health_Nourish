import 'dart:async'; // For StreamController
// For JSON encoding/decoding
import 'dart:io'; // For WebSocket

class WebSocketService {
  final String url;
  late WebSocket _webSocket;
  final StreamController<String> _streamController = StreamController<String>.broadcast();

  // Ensure this getter returns Stream<String>
  Stream<String> get stream => _streamController.stream;

  WebSocketService(this.url) {
    _connect();
  }

  Future<void> _connect() async {
    try {
      _webSocket = await WebSocket.connect(url);
      _webSocket.listen(
            (data) {
          if (data is String) { // Ensure only String data is added
            _streamController.add(data);
          }
        },
        onError: (error) {
          _streamController.addError(error);
        },
        onDone: () {
          _streamController.close();
        },
      );
    } catch (e) {
      _streamController.addError('Connection error: $e');
    }
  }

  void sendMessage(String message) {
    if (_webSocket.readyState == WebSocket.open) {
      _webSocket.add(message);
    } else {
      print('WebSocket is not open');
    }
  }

  void dispose() {
    _webSocket.close();
    _streamController.close();
  }
}
