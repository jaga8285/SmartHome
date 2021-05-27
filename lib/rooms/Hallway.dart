// AmbInt/Lamp/ Hallway1, Hallway2
import 'package:flutter/material.dart';
import '../mqtt.dart';
import 'Room.dart';

class HallwayWidget extends Room{
  // KitchenWidget(MqttService mqttService) : super(title : "Kitchen", mqttService: mqttService);
  HallwayWidget() : super(title : "Hallway", lights: ["Hallway1","Hallway2","Hallway3"]);

}