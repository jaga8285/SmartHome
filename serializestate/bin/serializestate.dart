import 'package:serializestate/serializestate.dart' as serializestate;

void main(List<String> arguments) {
  print('${serializestate.SerializeState()}!');
  print('${serializestate.recoverState(serializestate.SerializeState())}!');
}
