// AmbInt/Lamp/ Bedroom1,Bedroom2
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../mqtt.dart';
import 'Room.dart';

class KidsBedroomWidget extends Room{
  // BedroomWidget(MqttService mqttService) : super(title : "Bedroom", mqttService: mqttService);
  KidsBedroomWidget() : super(title : "Children's Bedroom", lights: ["Bedroom2"]);

}

