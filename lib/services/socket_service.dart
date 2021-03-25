import 'package:flutter/foundation.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  // enum = posibles estados del server
// Evitando utilizar cuestiones como muchos booleanos o un int con distintos valores
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier {
  // avisa cuando tiene que cambiar la info
  // Notifica sobre cambio en la UI o refrescarla
  // solo cambian los valores del _serverStatus aca
  ServerStatus _serverStatus = ServerStatus.Connecting;
// se puede visualizar el status del _serverStatus
  ServerStatus get serverStatus => this._serverStatus;


  // controlar como se va a exponer esto al mundo
  IO.Socket _socket;

  // funcion get para poder gettear el _socket
  IO.Socket get socket => this._socket;

  // No se puede utilizar lo mismo pero .on porque debemos luego apagarlo con .off
  // Function get emit => this._socket.emit;

  SocketService() {
    this._initConfig();
  }

  void _initConfig() {
    this._socket = IO.io('http://localhost:4000', {
      'transports': ['websocket'],
      'autoConnect': true
    });
    this._socket.on('connect', (_) {
      // print('connect');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.on('disconnect', (_) {
      // print('disconnect');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.on('mensaje-flutter', (payload) { // payload dejarlo de tipo dynamic es mas recomendable

      
      print('${payload['name']}: ${payload['message']}');

    
    
      // pregunta si esta la key 'mensaje2'
      // print(payload.containsKey('mensaje2') ? payload['mensaje2'] : 'No esta');
    
    
      this._socket.emit(payload);
    });

    
// aca esta el active bands
      // this._socket.on('active-bands', (payload) {
      // print(payload);
      // });

    //    IO.Socket socket = IO.io('http://192.168.20.35:3000');
    //  socket.onConnect((_) {
    //   print('connect');
    //   socket.emit('msg', 'test');
    //  });
    //  socket.on('event', (data) => print(data));
    //  socket.onDisconnect((_) => print('disconnect'));
    //  socket.on('fromServer', (_) => print(_));
  }
}
