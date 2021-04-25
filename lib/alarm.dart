class Alarm {
  final DateTime time;
  String state;

  Alarm({this.time, this.state = "0"});

  String get timeToAlarm => time.difference(DateTime.now()).toString();
}
