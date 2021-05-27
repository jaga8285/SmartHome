/// Flutter code sample for ExpansionPanelList

// Here is a simple example of how to implement ExpansionPanelList.

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:get_it/get_it.dart';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:provider/provider.dart';
import 'mqtt.dart';
import 'rooms/Room.dart';
import 'rooms/Alarm.dart';
import 'rooms/ParentsBedroom.dart';
import 'rooms/KidsBedroom.dart';
import 'rooms/Hallway.dart';
import 'rooms/HallwayBathroom.dart';
import 'rooms/Kitchen.dart';
import 'rooms/LivingRoom.dart';
import 'rooms/SuiteBathroom.dart';
import 'rooms/Suite.dart';
import 'scenarios.dart';
import 'dart:convert';




void main(){
  GetIt.I.registerSingletonAsync<MqttService>(MqttService.connect);
  runApp(
    ChangeNotifierProvider(
      create: (context) {
        return RoomModel(jsonDecode(jsonEncode(ScenarioWidget.defaultScenario)));
      },
      child:MyApp()
    )
  );

}

/// This is the main application widget.
class MyApp extends StatelessWidget {

  MyApp({Key? key}) : super(key: key);

  static const String _title = 'Smart Home';
  // final MqttService mqttService = MqttService();
  


  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance!.addPostFrameCallback(  (duration){mqttService.connect();}  );
    return MaterialApp(
      title: _title,
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Builder(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text(_title),
              bottom: const TabBar(tabs: [
                Tab(
                  text:"Control"
                ),
                Tab(
                  text:"Scenarios"
                ),
                Tab(
                  text:"Users"
                ),
              ]),
            ),
            body: FutureBuilder(
              future: GetIt.I.isReady<MqttService>(),
              builder: (BuildContext context, AsyncSnapshot asyncSnapshot){
                if (asyncSnapshot.connectionState == ConnectionState.done){  
                  return TabBarView(children: [
                    RoomListWidget(),
                    FutureBuilder(
                      future: ScenarioWidget.getTempFile(),
                      builder: (BuildContext context, AsyncSnapshot<File> asyncSnapshot){
                        if(asyncSnapshot.hasData){
                          return ScenarioWidget(storage: asyncSnapshot.data!);
                        }
                        else{
                          return CircularProgressIndicator();
                        }
                      }
                    ),
                    RoomListWidget(),
                  ]);
                } else {
                  return Center(child: Column(children: [CircularProgressIndicator(),Text("Connecting to your Home..")], mainAxisAlignment: MainAxisAlignment.center,));
                }
              }
            )
          ),
        ),
      ),
    );
  }


}



class RoomListWidget extends StatefulWidget {
  // final MqttService mqttService;
  const RoomListWidget({
    Key? key, 
    // required this.mqttService,
    }) : super(key: key);

  @override
  // State<RoomListWidget> createState() => _RoomListWidgetState(mqttService : mqttService);
  State<RoomListWidget> createState() => _RoomListWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _RoomListWidgetState extends State<RoomListWidget> {
  // MqttService mqttService;
/*   _RoomListWidgetState({required this.mqttService}){
      _data = [
      KitchenWidget(mqttService),
      BedroomWidget(mqttService),
      LivingRoomWidget(mqttService),
    ];
  } */
  _RoomListWidgetState(){
      _data = [
      AlarmWidget(),
      KitchenWidget(),
      ParentsBedroomWidget(),
      KidsBedroomWidget(),
      SuiteWidget(),
      SuiteBathroomWidget(),
      LivingRoomWidget(),
      HallwayWidget(),
      HallwayBathroomWidget(),
    ];
  }

  late final List<Room> _data;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
      ),
    );
  }

  Widget _buildPanel() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Scrollbar(
        child: ExpansionPanelList.radio(
          initialOpenPanelValue: 2,
          children: _data.map<ExpansionPanelRadio>((Room room) {
            return ExpansionPanelRadio(
              value: room.title,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text(room.title),
                );
              },
              body: room,
              canTapOnHeader: true,
            );
          }).toList(),
        )
      )
    );
  }
}
