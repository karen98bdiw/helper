class Alarm {
  final DateTime time;

  Alarm({this.time});

  String get timeToAlarm => time.difference(DateTime.now()).toString();
}
