import 'package:flutterpad/constants.dart';
import "package:socket_io_client/socket_io_client.dart" as io;

// Single socket instance for document editing
class SocketClient {
  io.Socket? socket;
  static SocketClient? _instance;

  SocketClient._internal() {
    socket = io.io(host, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket!.connect();
  }

  static SocketClient get instance {
    // If there is no instance, create a socket client internal
    _instance ??= SocketClient._internal();
    return _instance!;
  }
}
