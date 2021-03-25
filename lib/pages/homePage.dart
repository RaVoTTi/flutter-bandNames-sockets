
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
import 'package:bandname/models/band.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:bandname/services/socket_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    // Band(id: '1', name: 'Metallica', votes: 12),
    // Band(id: '2', name: 'Metallica', votes: 12),
    // Band(id: '3', name: 'Metallica', votes: 12),
    // Band(id: '4', name: 'Metallica', votes: 12),
  ];
  // Map rawData;
  // List cleanData;
  // getJSON(String ruta) async {
  //   // String localhost = 'http://127.0.0.1:5000/api/' + ruta;
  // print(localhost);
  // http.Response response = await http.get('http://localhost:3000/api/bands');
  //   rawData = json.decode(response.body);
  //   setState(() {
  //     cleanData = rawData['bands'];
  //   });
  // }
  // @override
  // void initState() {
  //   super.initState();
  //   getJSON('bands');
  // }

 
  
  // ESCUCHAMOS
  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false); // listen en false si no necesitamos que se redibuje
    socketService.socket.on('active-bands', (payload) {

      this.bands = (payload as List) // castea a lista
              .map((band) => Band.fromMap(band))
              .toList();

    setState(() {}); // se redibuja el widget
    });
    // si el set state queda fuera del socketService no se redibuja el widget

    super.initState();
  }

  // MATAMOS LA ESCUCHA
  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    
    // APAGA LA ESCUCHA
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final serverStatus = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Cual es la mejor banda',
            style: TextStyle(fontSize: 25, color: Colors.black87),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            // Ternario
            child: serverStatus.serverStatus == ServerStatus.Online
                ? Icon(Icons.check_circle, color: Colors.green[300])
                : Icon(Icons.offline_bolt, color: Colors.red[300])
          )
        ],
      ),
      body: Column(
        children: [
          _showGraph(),

          Expanded(
            child: ListView.builder(
                itemCount: bands.length,
                itemBuilder: (context, int i) => _bandTile(bands[i])),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[300],
        onPressed: AddNewBand,
        child: Icon(Icons.message),
        elevation: 3,
      ),
    );
  }

  Widget _bandTile(Band band) {
    // final textController = TextEditingController();
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      // Eliminacion por scroll a la derecha
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: ( _ ) => socketService.socket.emit('delete-band', {'id' :band.id}),
      background: Container(
        color: Colors.red[300],
        padding: EdgeInsets.only(left: 8.0),
        child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Icon(Icons.remove),
                SizedBox(
                  width: 5,
                ),
                Text('Remove', style: TextStyle(fontSize: 20)),
              ],
            )),
      ),
      child: ListTile(
        //
        leading: CircleAvatar(
          child: Text(
            band.name.substring(0, 2),
            style: TextStyle(color: Colors.green[600]),
          ),
          backgroundColor: Colors.green[100],
        ),
        title: Text(band.name.toUpperCase()),
        trailing: Text(
          (band.votes).toString(),
        ), // para determinar la fuente
        onTap: () => socketService.socket.emit('vote-band', {'id': band.id}),
      ),
    );
  }

  AddNewBand() {
    final textController = TextEditingController();

// Deteccion de plataformas
    // if (Platform.isIOS) {
    //   //La plataforma es IOS?
    //   showCupertinoDialog(
    //       context: context,
    //       builder: (_) {
    //         // no se utiliza el context cuando se representa en _
    //         return CupertinoAlertDialog(
    //           title: Text('nombre de la banda nueva'),
    //           content: CupertinoTextField(
    //             controller: textController,
    //           ),
    //           actions: <Widget>[
    //             CupertinoDialogAction(
    //               isDefaultAction: true,
    //               child: Text('Add'),
    //               onPressed: () => addBandToList(textController.text),
    //             ),
    //             CupertinoDialogAction(
    //               isDestructiveAction: true,
    //               child: Text('Dismiss'),
    //               onPressed: () => Navigator.pop(context),
    //             )
    //           ],
    //         );
    //       });
    // } else {
    // La plataforma es android?

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Nombre de la banda nueva'),
            content: TextField(
              controller: textController,
            ),
            actions: <Widget>[
              MaterialButton(
                  child: Text('Add'),
                  elevation: 3,
                  textColor: Colors.green[100],
                  onPressed: () => addBandToList(textController.text))
            ],
          );
        });
  }

  void addBandToList(String name) {

    if (name.length > 1) {
      final socketService = Provider.of<SocketService>(context,listen: false);

      socketService.socket.emit('create-band', {'name': name});

      Navigator.pop(context);
    }
  }


Widget _showGraph() {

  // fl_char
  // List<PieChartSectionData> dataList = []; 
  // List<Color> colors = [
  //   Colors.blue,
  //   Colors.green,
  //   Colors.red,
  //   Colors.yellow,
  //   Colors.brown,
  //   Colors.pink,
  //   Colors.orange,
  //   Colors.lightBlue,
  //   Colors.grey,
  // ];
  // for (var i = 0; i < bands.length; i++) {
  //   final temp = PieChartSectionData(
  //     value: bands[i].votes.toDouble(),
  //     title: bands[i].name,
  //     color: colors[(i)],
  //     titleStyle: TextStyle(color: Colors.black87)
  //   );
  //   dataList.add(temp);
  //  };
  // return Container(
  //   width: double.infinity,
  //   height: 300,
  //   child: PieChart(
  //     PieChartData(
  //       sections: dataList,
  //     ),
  //     ),
  // );
  Map<String,double> dataMap = new Map();

  bands.forEach((band) { 
    dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
  });


return Container(
  width:  double.infinity,
  height: 200,
  child: PieChart(dataMap: dataMap,));
}
}