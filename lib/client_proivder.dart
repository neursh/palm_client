import 'package:flutter/foundation.dart';
import "package:socket_io_client/socket_io_client.dart" as sio;

enum KeyInput { left, right, shiftf5, f5, esc }

class ClientProivder extends ChangeNotifier {
  bool connected = false;
  bool authorized = false;
  sio.Socket? socket;

  connect(String ip, int port, String pin) {
    socket = sio.io(
        "http://$ip:$port",
        sio.OptionBuilder()
            .setTransports(["websocket"])
            .setExtraHeaders({"PIN": pin})
            .disableAutoConnect()
            .build());

    socket!.on("authorized", (data) {
      authorized = true;
      notifyListeners();
    });

    socket!.on("disconnect", (data) {
      authorized = false;
      connected = false;
      notifyListeners();
    });

    socket!.on("connection", (data) {
      connected = true;
      notifyListeners();
    });

    socket!.connect();
  }

  sendKey() {
    socket!.emit("input", );
  }
}
