import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helper/alarm.dart';
import 'package:helper/db.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  DateTime pickedTime;
  final curentDate = DateTime.now();

  List<Alarm> alarms = [];

  Future<void> pickTime() async {
    var res = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.dial,
      initialTime: TimeOfDay.now(),
    );

    if (res == null) {
      return;
    }

    setState(() {
      pickedTime = DateTime(
        curentDate.year,
        curentDate.month,
        res.hour > curentDate.hour
            ? curentDate.day
            : curentDate.add(Duration(days: 1)).day,
        res.hour,
        res.minute,
      );
      alarms.add(
        Alarm(time: pickedTime),
      );
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      print("this is called");
      Db().insertAlarms(alarms);
    }

    if (state == AppLifecycleState.resumed) {
      r();
    }

    super.didChangeAppLifecycleState(state);
  }

  void r() async {
    List<Alarm> res = await Db().read();

    setState(() {
      alarms = res;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    r();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(4, 15, 51, 1),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              itemBuilder: (c, i) => alarmItemView(
                alarm: alarms[i],
                index: ++i,
              ),
              itemCount: alarms.length,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: pickTime,
      ),
    );
  }

  Widget alarmItemView({Alarm alarm, int index}) => Container(
        margin: EdgeInsets.only(top: 15),
        child: Dismissible(
          key: UniqueKey(),
          onDismissed: (DismissDirection d) {
            alarms.remove(alarm);
          },
          background: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                8,
              ),
            ),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.delete,
                    color: Colors.pink,
                  ),
                ],
              ),
            ),
          ),
          direction: DismissDirection.horizontal,
          secondaryBackground: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.delete,
                  color: Colors.pink,
                ),
              ],
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                8,
              ),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(8),
              title: Text(alarm.time.toString()),
              subtitle: Text(alarm.timeToAlarm),
              trailing: CupertinoSwitch(
                value: alarm.state == "1",
                onChanged: (v) {
                  setState(() {
                    alarm.state = v ? "1" : "0";
                  });
                },
              ),
            ),
          ),
        ),
      );
}
