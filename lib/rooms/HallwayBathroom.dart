// AmbInt/Lamp/ HallwayBathroom1
import 'package:flutter/material.dart';
import '../mqtt.dart';
import 'Room.dart';

class HallwayBathroomWidget extends Room{
  // KitchenWidget(MqttService mqttService) : super(title : "Kitchen", mqttService: mqttService);
  HallwayBathroomWidget() : super(title : "Hallway Bathroom", lights: ["HallwayBathroom1"]);

}