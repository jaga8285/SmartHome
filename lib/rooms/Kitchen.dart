// AmbInt/Lamp/ Kitchen1,Kitchen2
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../mqtt.dart';
import 'Room.dart';

class KitchenWidget extends Room{
  // KitchenWidget(MqttService mqttService) : super(title : "Kitchen", mqttService: mqttService);
  KitchenWidget() : super(title : "Kitchen", lights: ["Kitchen1","Kitchen2"]);

}


