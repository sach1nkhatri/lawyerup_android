import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../constant/api_endpoints.dart';

class SocketService {
  late IO.Socket _socket;

  void connectAndJoin(String bookingId) {
    _socket = IO.io(ApiEndpoints.socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket.connect();

    _socket.onConnect((_) {
      _socket.emit('joinRoom', bookingId);
    });
  }

  void sendMessage({
    required String bookingId,
    required String senderId,
    required String text,
    required String senderName,
  }) {
    _socket.emit('sendMessage', {
      'bookingId': bookingId,
      'senderId': senderId,
      'text': text,
      'senderName': senderName,
    });
  }

  void onMessageReceived(Function(Map<String, dynamic>) callback) {
    _socket.on('receiveMessage', (data) {
      callback(Map<String, dynamic>.from(data));
    });
  }

  void disconnect() {
    _socket.dispose();
  }
}
