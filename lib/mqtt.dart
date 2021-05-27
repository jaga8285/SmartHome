//VARIAVEIS GLOBAIS
import 'dart:async';

import 'package:mqtt_client/mqtt_client.dart';
// import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';


//MqttBrowserClient client = MqttBrowserClient.withPort('ws://broker.emqx.io/mqtt', 'ws_client', 8083);

const String broker = "broker.emqx.io";
const String browserBroker = "ws://broker.emqx.io";
const int port = 1883;
const int browserPort = 8083;
const String clientIdentifier = "android";

class MqttService {

  MqttServerClient client = MqttServerClient.withPort(broker, 'smart_home', port);
  // MqttBrowserClient client = MqttBrowserClient.withPort(browserBroker, 'smart_home1', browserPort);
  MqttConnectionState connectionState = MqttConnectionState.disconnected;

  //StreamSubscription subscription;

  MqttService._create(){
    client.websocketProtocols = ["mqttv3.11"];
    client.logging(on: true);
    client.onConnected = _onConnected;
    client.onDisconnected = _onDisconnected;
    // client.onUnsubscribed = _onUnsubscribed;
    client.onSubscribed = _onSubscribed;
    client.onSubscribeFail = _onSubscribeFail;
    final connMessage = MqttConnectMessage()
        .keepAliveFor(60)
        .withWillTopic('willtopic')
        .withWillMessage('Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMessage;
  }


  static Future<MqttService> connect() async{
    var service = MqttService._create();
    try {
      await service.client.connect().then((value) => service.connectionState = value!.state);
      return service;
    } catch (e) {
      print(e);
      print("service could not connect, retrying");
      service._disconnect();
      throw e;
    }
  }
  void subscribeToTopic(String topic) {
    if (connectionState == MqttConnectionState.connected){
      this.client.subscribe(topic, MqttQos.atLeastOnce); 
    }
  }
  void _disconnect() {
    print("Disconnect");
    client.disconnect();
  }
  
  void _onConnected(){
    print("Connected");
    connectionState = this.client.connectionStatus!.state;
  }

  void _onDisconnected() {
    print("Disconnected");
    connectionState = this.client.connectionStatus!.state;
    //subscription.cancel();
  }

  // subscribe to topic succeeded
  void _onSubscribed(String topic) {
    print('Subscribed topic: $topic');
  }

  // subscribe to topic failed
  void _onSubscribeFail(String topic) {
    print('Failed to subscribe $topic');
  }

  // unsubscribe succeeded
  void _onUnsubscribed(String topic) {
    print('Unsubscribed topic: $topic');
  }

  void _onMessage(List<MqttReceivedMessage> event) {
    print(event.length);
    final MqttPublishMessage recMess = event[0].payload as MqttPublishMessage;
    final String message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message!);
    //currentTopic = event[0].topic;  //Para distinguir qual topic esta a ser ouvido
    //valor_luz = double.parse(message); //TODO verificar o q foi a mensagem e alterar o valor certo
  }

  void publish(String topic, String message) {
    if (connectionState == MqttConnectionState.connected){
      final builder = MqttClientPayloadBuilder();   
      builder.addString(message);//message to Uint8Buffer
      client.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
    }
  }
}