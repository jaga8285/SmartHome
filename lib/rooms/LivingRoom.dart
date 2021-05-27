// AmbInt/Lamp/ LivingRoom1,LivingRoom2
import 'package:flutter/material.dart';
import '../mqtt.dart';
import 'Room.dart';


class LivingRoomWidget extends Room{
  // LivingRoomWidget(MqttService mqttService) : super(title : "Living Room", mqttService: mqttService);
  LivingRoomWidget() : super(title : "Living Room", lights: ["LivingRoom1","LivingRoom2"], tv: ["LivingRoom1"]);

}

