
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bandname/models/band.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 12),
    Band(id: '2', name: 'Metallica', votes: 12),
    Band(id: '3', name: 'Metallica', votes: 12),
    Band(id: '4', name: 'Metallica', votes: 12),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Cual es la mejor banda',
            style: TextStyle(fontSize: 25),
          ),
        ),
        elevation: 3,
      ),
      body: ListView.builder(
          itemCount: bands.length,
          itemBuilder: (context, int i) => _bandTile(bands[i])),
      floatingActionButton: FloatingActionButton(
        onPressed: AddNewBand,
        child: Icon(Icons.add ),
        elevation: 3,
      ),
    );
  }

  Widget _bandTile(Band band) {
    // final textController = TextEditingController();

    return Dismissible( // Eliminacion por scroll a la derecha
        key: Key(band.id),
        direction: DismissDirection.startToEnd,
        onDismissed: ( direction ){ 
          print('direction: $direction');
          print('id: ${band.id} ##### name: ${band.name}');
        },
        background: Container(
          color: Colors.red[300],
          padding: EdgeInsets.only(left: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Icon(Icons.remove),
                SizedBox(width: 5,),
                Text('Remove', style: TextStyle(fontSize: 20) ),
              ],
            ) 
          ),
        ),
        child: ListTile(      // 
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
        ),
        title: Text(band.name.toUpperCase()),
        trailing: Text(
          '${band.votes}', // (band.votes).toString()
          style: TextStyle(fontSize: 20),
        ), // para determinar la fuente
        onTap: () {
          print(band.name);
        },
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
                  textColor: Colors.blue,
                  onPressed: () => addBandToList(textController.text))
            ],
          );
        });
  }

  void addBandToList(String name) {
    print(name);

    if (name.length > 1) {
      this.bands.add(new Band(id: DateTime.now().toString(), name: name));
      setState(() {});

      Navigator.pop(context);
    }
  }
}
