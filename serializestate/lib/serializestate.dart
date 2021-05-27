import 'dart:convert';

String SerializeState() {
  Map _state = Map();
  _state["LAMP"] = Map();
  _state["LAMP"]["Kitchen1"] = Map();
  _state["LAMP"]["Kitchen1"]["STATE"] = false;
  _state["LAMP"]["Kitchen1"]["INT"] = 2.3;
  return JsonEncoder.withIndent("  ").convert(_state);
}

Map recoverState(String json){
  return jsonDecode(json);
}

