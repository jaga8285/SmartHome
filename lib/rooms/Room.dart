import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
//import '../mqtt.dart';

/* abstract class Room extends StatefulWidget{
  Room({
    required this.title,
    // required this.mqttService,
  });
  // final MqttService mqttService;
  final String title;

} */

// AmbInt/Lamp/ Kitchen1,Kitchen2
import 'package:get_it/get_it.dart';
import 'package:smart_home/mqtt.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class Room extends StatefulWidget{
  Room({
    required title,
    tv = const <String>[],
    lights = const <String>[],
    alarm = const <String>[],
  }):this.title = title, _lights = lights, _tv = tv, _alarm = alarm;
  final String title;
  final List<String> _lights;
  final List<String> _alarm;
  final List<String> _tv;

  @override
  State<Room> createState () {
    return _RoomState();
  }
}

class _RoomState extends State<Room>{

  @override
  Widget build(BuildContext context){
    List<Widget> widgetList = <Widget>[];
    if (widget._alarm.isNotEmpty){
      widgetList.add(
        Consumer<RoomModel>(builder: (context,roomState,child){
          return SwitchListTile(
            title: const Text('Turn on Security'),
            value:  roomState.getProp("AmbInt/Alarm",widget._alarm[0],"STATE"),
            onChanged: (bool onoff) => toggleAlarm(roomState, onoff),
            secondary: const Icon(Icons.notification_important_rounded)
          );
        })
      );
    }
    if (widget._lights.isNotEmpty){
      widgetList.add(
        Consumer<RoomModel>(builder: (context,roomState,child){
          return SwitchListTile(
            title: const Text('Lights'),
            value:  roomState.getProp("AmbInt/Lamp",widget._lights[0],"STATE"),
            onChanged: (bool onoff) => toggleLights(roomState, onoff),
            secondary: const Icon(Icons.lightbulb_outline)
          );
        })
      );
      widgetList.addAll([
        Consumer<RoomModel>(builder: (context,roomState,child){
          bool onoff = roomState.getProp("AmbInt/Lamp",widget._lights[0],"STATE");
          double intensity = roomState.getProp("AmbInt/Lamp",widget._lights[0],"INT");
          return ListTile(
            enabled: onoff,
            title: const Text('Light Intensity'),
            subtitle: Slider(
              value: onoff ? intensity : 0.5,
              min:0.5,
              max:2.5,
              label: intensity.toString(),
              onChanged: onoff ? (value) {
                setState( () {
                  roomState.setProp("AmbInt/Lamp",widget._lights[0],"INT",value);
                });} : null,
              onChangeEnd: (value) {setLightIntensity(roomState,value);},
            ),
            leading: const Icon(Icons.lightbulb_outline)
          );}
        ),
        Consumer<RoomModel>(builder: (context,roomState,child){
          bool onoff = roomState.getProp("AmbInt/Lamp",widget._lights[0],"STATE");
          double hue = roomState.getProp("AmbInt/Lamp",widget._lights[0],"COLOR");
          return ListTile(
            enabled: onoff,
            title: const Text('Light Hue'),
            subtitle: Slider(
              value: hue,
              min:0.0,
              max:360.0,
              label: hue.round().toString(),
              onChanged: onoff ? (value) {
                setState( () {
                  roomState.setProp("AmbInt/Lamp",widget._lights[0],"COLOR",value);
                });} : null,
              onChangeEnd: (value) {setLightHue(roomState,value);},
              ),
            
            leading: Stack(
              children:[Icon(Icons.lightbulb, color: HSLColor.fromAHSL(1, ((hue+180)%360), 1, (tan((hue/360)*(pi/2)-pi/4)+ 1) /2).toColor(),),
              Icon(Icons.lightbulb_outline)]
            )
          );}
        )
      ]);
    }
    if (widget._tv.isNotEmpty){
      widgetList.add(
        Consumer<RoomModel>(builder: (context,roomState,child){
          return SwitchListTile(
            title: const Text('T.V.'),
            value:  roomState.getProp("AmbInt/TV",widget._tv[0],"STATE"),
            onChanged: (bool onoff) => toggleTV(roomState, onoff),
            secondary: const Icon(Icons.tv),
          );
        },)
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: widgetList,);
  }

  toggleLights(RoomModel room, bool onoff){
    setState(() {
      widget._lights.forEach((light) {
        room.setProp("AmbInt/Lamp", light, "STATE", onoff);
        GetIt.I.get<MqttService>().publish("AmbInt/Lamp", lightMessage(light, onoff));
        String lightmessage = lightMessage(light, onoff);
        print("Sending $lightmessage to topic AmbInt/Lamp ");
      });
    });
  }

  toggleAlarm(RoomModel room, bool onoff){
    setState(() {
      widget._alarm.forEach((alarm) {
        room.setProp("AmbInt/Alarm", alarm, "STATE", onoff);
        GetIt.I.get<MqttService>().publish("AmbInt/Alarm", lightMessage(alarm, onoff));
        String lightmessage = lightMessage(alarm, onoff);
        print("Sending $lightmessage to topic AmbInt/Alarm ");
      });
    });
  }

  toggleTV(RoomModel room, bool onoff){
    setState(() {
      widget._tv.forEach((tv) {
        room.setProp("AmbInt/TV", tv, "STATE", onoff);
        GetIt.I.get<MqttService>().publish("AmbInt/TV", lightMessage(tv, onoff));
        String lightmessage = lightMessage(tv, onoff);
        print("Sending $lightmessage to topic AmbInt/TV ");
      });
    });
  }

  setLightIntensity(RoomModel room, double value){
    setState(() {
      widget._lights.forEach((light) {
        room.setProp("AmbInt/Lamp", light, "INT", value);
        GetIt.I.get<MqttService>().publish("AmbInt/Lamp", lightIntensityMessage(light, value));
        String lightmessage = lightIntensityMessage(light, value);
        print("Sending $lightmessage to topic AmbInt/Lamp ");
      });
    });
  }
  setLightHue(RoomModel room, double value){
    setState(() {
      widget._lights.forEach((light) {
        room.setProp("AmbInt/Lamp", light, "COLOR", value);
        GetIt.I.get<MqttService>().publish("AmbInt/Lamp", lightHueMessage(light, value));
        String lightmessage = lightHueMessage(light, value);
        print("Sending $lightmessage to topic AmbInt/Lamp ");
      });
    });
  }

  String lightMessage(String id, bool on){
    return "{\"$id\" : {\"op\": \"STATE\", \"value\": " + on.toString() + "}}";
  }
  String lightIntensityMessage(String id, double intensity){
    return "{\"$id\" : {\"op\": \"INT\", \"value\": " + ((intensity * 100).round() /100).toString() + "}}";
  }
  String lightHueMessage(String id, double hue){
    return "{\"$id\" : {\"op\": \"COLOR\", \"value\": \"#" + (HSLColor.fromAHSL(1, ((hue+180)%360), 1, (tan((hue/360)*(pi/2)-pi/4)+ 1) /2).toColor()).toString().substring(10,16).toUpperCase() + "\"}}";
  }
}

class RoomModel extends ChangeNotifier{
  Map _state = {};

  RoomModel(Map state){
    _state = Map.from(state);
  }

  RoomModel.fromString(String json){
    this._state = jsonDecode(json);
  }

  void loadDefault() async{
    String json = await File('../scenarios/default.json').readAsString();
    _state = jsonDecode(json);
  }

  void setProp(String device, String room, String prop, dynamic value){
    _state[device][room][prop] = value;
    notifyListeners();
  }

  dynamic getProp(String device, String room, String prop){
    return _state[device][room][prop];
  }

  Map state(){
    return _state;
  }

  void setState(Map newState){
    _state = newState;
    Map message = _state.map((device,rooms) {
      List opList = [];
      Map.from(rooms).forEach((room, ops) { 
        ops.forEach((op,value){
          if (op == "COLOR"){
            opList.add({room:{"op":op,"value":"#"+(HSLColor.fromAHSL(1, ((value+180)%360), 1, (tan((value/360)*(pi/2)-pi/4)+ 1) /2).toColor()).toString().substring(10,16).toUpperCase() }});
          } else {
            opList.add({room:{"op":op,"value":value}});
          }
        });
      });
      return MapEntry(device, opList);
    });
    GetIt.I.get<MqttService>().publish("AmbInt/Scenario", jsonEncode(message));
    print("Sending " + jsonEncode(message));
  }
  void saveState(){
    File newfile = File('../scenarios/'+DateTime.now().toString()+'-scenario.json');
    newfile.writeAsString(jsonEncode(_state));
  }
}