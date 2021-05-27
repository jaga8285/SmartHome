import 'package:flutter/material.dart';
import '../mqtt.dart';
import 'Room.dart';

class AlarmWidget extends Room{
  AlarmWidget() : super(title : "Alarm", alarm: ["ALARM"]);

}