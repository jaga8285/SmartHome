// AmbInt/Lamp/ Suite1
import 'package:flutter/material.dart';
import '../mqtt.dart';
import 'Room.dart';

class SuiteWidget extends Room{
  // LivingRoomWidget(MqttService mqttService) : super(title : "Living Room", mqttService: mqttService);
  SuiteWidget() : super(title : "Suite", lights: ["Suite1"]);

}