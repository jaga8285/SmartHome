// AmbInt/Lamp/ Bedroom1,Bedroom2
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../mqtt.dart';
import 'Room.dart';

class ParentsBedroomWidget extends Room{
  // BedroomWidget(MqttService mqttService) : super(title : "Bedroom", mqttService: mqttService);
  ParentsBedroomWidget() : super(title : "Parent's Bedroom", lights: ["Bedroom1"]);

}

