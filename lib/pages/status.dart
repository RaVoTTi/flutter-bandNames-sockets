import 'package:bandname/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      body: Center(child: Text('${socketService.serverStatus}')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.message),
        onPressed: () {
          socketService.socket.emit('mensaje-flutter',{
              
              'name': 'Flutter', 
              'message': 'Hola desde Flutter'
              
              });
        },
      ),
    );
  }
}
