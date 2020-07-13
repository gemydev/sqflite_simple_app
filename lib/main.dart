import 'package:flutter/material.dart';
import 'package:sqflite_app/Screens/employees_list.dart';



main() {
  runApp(new MaterialApp(
    title: 'Flutter Database',
    debugShowCheckedModeBanner: false,
    theme: new ThemeData(
        accentColor: Colors.black,
        primaryColor: Colors.black,
        primaryColorDark: Colors.black),
    home: HomeScreen(),
  ));
}
