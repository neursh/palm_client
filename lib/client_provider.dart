import 'dart:async';

import 'package:flutter/foundation.dart';
import "package:socket_io_client/socket_io_client.dart" as sio;

enum KeyInput { left, right, shiftf5, f5, esc }

class ClientProvider extends ChangeNotifier {
  bool authorized = false;
  bool connection = false;
  sio.Socket? socket;

  connect(String ip, int port, String pin) {
    connection = true;

    socket = sio.io(
      "http://$ip:$port",
      sio.OptionBuilder()
          .enableForceNew()
          .setTransports(["websocket"])
          .setExtraHeaders({"PIN": pin})
          .disableAutoConnect()
          .disableReconnection()
          .build(),
    );

    socket!.on("authorized", (data) {
      authorized = true;
      Timer.run(() => notifyListeners());
    });

    socket!.on("disconnect", (data) {
      disconnect();
    });

    socket!.connect();
  }

  sendKey(KeyInput input) {
    socket!.emit("input", input.name);
  }

  disconnect() {
    socket?.dispose();
    socket = null;
    connection = false;
    authorized = false;
    Timer.run(() => notifyListeners());
  }
}
