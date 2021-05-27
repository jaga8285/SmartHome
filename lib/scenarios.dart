import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:smart_home/mqttStub.dart';
import 'rooms/Room.dart';
import 'package:path_provider/path_provider.dart';


class ScenarioWidget extends StatefulWidget{
  static const Map defaultScenario ={
    "AmbInt/Alarm":{
      "ALARM":{
        "STATE":false
      }
    },
    "AmbInt/Lamp":{
      "Kitchen1":{
        "STATE":true,
        "INT": 1.2,
        "COLOR":360.0
      },
      "Kitchen2":{
        "STATE":true,
        "INT": 1.5,
        "COLOR":360.0
      },
      "Bedroom1":{
        "STATE":true,
        "INT": 1.5,
        "COLOR":360.0
      },
      "Bedroom2":{
        "STATE":true,
        "INT": 1.5,
        "COLOR":360.0
      },
      "Hallway1":{
        "STATE":true,
        "INT": 1.2,
        "COLOR":360.0
      },
      "Hallway2":{
        "STATE":true,
        "INT": 0.5,
        "COLOR":360.0
      },
      "Hallway3":{
        "STATE":true,
        "INT": 1.0,
        "COLOR":360.0
      },
      "HallwayBathroom1":{
        "STATE":true,
        "INT": 1.5,
        "COLOR":360.0
      },
      "LivingRoom1":{
        "STATE":true,
        "INT": 1.2,
        "COLOR":360.0
      },
      "LivingRoom2":{
        "STATE":true,
        "INT": 1.2,
        "COLOR":360.0
      },
      "Suite1":{
        "STATE":true,
        "INT": 1.5,
        "COLOR":360.0
      },
      "SuiteBathroom1":{
        "STATE":true,
        "INT": 1.0,
        "COLOR":360.0
      }
    },
    "AmbInt/TV":{
      "LivingRoom1":{
        "STATE":false,
      }
    }
  }; 

  final File storage;

  const ScenarioWidget({
    Key? key, 
    required this.storage,
    }) : super(key: key);
    
  static Future<File> getTempFile() async{
    Directory dir = await getTemporaryDirectory();
    File file = File(dir.path+"/scenarios.json");
    if(await file.exists()){
      return file;
    } else {
      return file.create();
    }
  }

  @override
  State<ScenarioWidget> createState() => _ScenarioWidgetState(storage);
}

class _ScenarioWidgetState extends State<ScenarioWidget>{

  _ScenarioWidgetState(this.storageFile);

  

  Map savedScenarios = {};

  Map scenarios = {};


  List<GridTile> scenarioTiles = [];

  File storageFile;

  String newScenario = "undefined";
  TextEditingController _textFieldController = TextEditingController();

  Future<File> saveToFile() async{
    Map tempScenarios = Map.from(scenarios);
    tempScenarios.remove("Default");
    print("encoding "+jsonEncode(tempScenarios));
    return storageFile.writeAsString(jsonEncode(tempScenarios));
  }
  
  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adding current configuration as new scenario'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                newScenario = value;
              });
            },
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "New scenario name"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                setState(() {
                  print(newScenario);
                  scenarios.putIfAbsent(newScenario, () => context.read<RoomModel>().state()) ;
                  Navigator.pop(context);
                });
              },
            ),
          ],
        );
      }
    );
  }
  @override
  void initState() {
    String storedJson = storageFile.readAsStringSync();
    savedScenarios = storageFile.lengthSync() > 10 ? jsonDecode(storedJson) : {};
    scenarios["Default"] = jsonDecode(jsonEncode(ScenarioWidget.defaultScenario));
    scenarios.addAll(savedScenarios);
    super.initState();
  }
  @override
  void dispose(){
    super.dispose();
    saveToFile();
  }
  @override
  Widget build(BuildContext context){
    scenarioTiles = [];

    scenarios.forEach((name,scenario){
      scenarioTiles.add(
        GridTile(
          child: Container(
            color: Colors.lightBlue[100],
            child:Stack(
              children: <Widget>[
                TextButton(
                  onPressed: () => setNewScenario(context,scenario),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                        child: Text(name),
                    )
                  ),
                )
              ] + (name == "Default" ? [] : [
                Align(
                  child:
                    IconButton(
                      onPressed: () => setState((){scenarios.remove(name);}),
                      icon: Icon(Icons.delete),
                    ),
                  alignment: Alignment.topRight,
                )
              ])
            )
          ),
        ),
      );
    });
    scenarioTiles.add(
      GridTile(
        child: Container(
          child:Builder(
            builder: (BuildContext context){
              return TextButton(
                onPressed: () {
                  setState((){
                    _displayTextInputDialog(context);
                  });
                },
                child: Stack(
                  children:[
                    Align(
                      alignment: Alignment.center,
                      child: Icon(Icons.add_circle,size: 75,)
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text("New Scenario", textAlign: TextAlign.center,),
                      )
                    ),
                  ]
                ),
              );
            }
          ),
        ),
      )
    );
    return Padding(
      padding: EdgeInsets.only(bottom: 25),
      child: GridView.extent(
        maxCrossAxisExtent: 250,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        children: scenarioTiles,
      ),
    );
  }
}

void setNewScenario(BuildContext context, Map scenario){
  context.read<RoomModel>().setState(scenario);
}
