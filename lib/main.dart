import 'package:flutter/material.dart';
import 'package:helper/db.dart';
import 'package:helper/home_screen.dart';

Future<void> main(List<String> args) async {
  await run();
}

Future<void> run() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Db().initDb();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
