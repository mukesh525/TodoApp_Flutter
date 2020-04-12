import 'package:flutter/material.dart';
import 'package:todoapp/ui/Home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NoToDo',
      home: Home(),
    );
  }
}
