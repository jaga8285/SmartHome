//VARIAVEIS GLOBAIS
import 'dart:async';


//MqttBrowserClient client = MqttBrowserClient.withPort('ws://broker.emqx.io/mqtt', 'ws_client', 8083);

const String broker = "broker.emqx.io";
const String browserBroker = "ws://broker.emqx.io";
const int port = 1883;
const int browserPort = 8083;
const String clientIdentifier = "android";

class MqttService {

  String connectionState = "disconnected";

  MqttService._create(){
    print("Creating service");
  }


  static Future<MqttService> connect() async{
    var service = MqttService._create();
    return Future<MqttService>.delayed(Duration(milliseconds: 50),(){
      print("Mqtt connected");
      service.connectionState = "connected";
      return service;
    });
  }
  void subscribeToTopic(String topic) {
  }
  void _disconnect() {
    print("Disconnect");
  }
  
  void _onConnected(){
    print("Connected");
  }

  void _onDisconnected() {
    print("Disconnected");
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


  void publish(String topic, String message) {
    print("Sent $message to $topic");
  }
}