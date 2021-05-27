// AmbInt/Lamp/ SuiteBathroom1
import 'package:flutter/material.dart';
import '../mqtt.dart';
import 'Room.dart';

class SuiteBathroomWidget extends Room{
  // LivingRoomWidget(MqttService mqttService) : super(title : "Living Room", mqttService: mqttService);
  SuiteBathroomWidget() : super(title : "Suite Bathroom", lights: ["SuiteBathroom1"]);

}