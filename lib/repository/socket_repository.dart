import 'package:socket_io_client/socket_io_client.dart';
import '../clients/socket_client.dart';

class SocketRepository {
  final _socketClient = SocketClient.instance.socket!;

  Socket get socketClient => _socketClient;

  // Each collaborative editing session will have a specific room
  void joinRoom(String documentId) {
    _socketClient.emit('join', documentId);
  }

  // Send off new data when a user edits the document
  void typing(Map<String, dynamic> data) {
    _socketClient.emit('typing', data);
  }

  // Handles changes from another connected client
  void changeListener(Function(Map<String, dynamic>) func) {
    _socketClient.on('changes', (data) => func(data));
  }
}
