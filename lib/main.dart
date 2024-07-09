import 'package:flutter/material.dart';
import 'package:pexels/Screens/Home/Home_View.dart';
import 'package:pexels/sliver.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      title: 'Material App',
      home: UsingSliver(),
    );
  }
}
