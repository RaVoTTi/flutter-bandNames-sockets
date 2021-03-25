import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:bandname/services/socket_service.dart';
import 'package:bandname/pages/status.dart';
import 'package:bandname/pages/homePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => SocketService()) // devuelve instancia del socket service
      ],
      child: MaterialApp(
        // theme: ThemeData(
        //   color:
        // ),
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'home',
        routes: {
          'home': (_) => HomePage(),
          'status': (_) => StatusPage(),
        },
      ),
    );
  }
}
