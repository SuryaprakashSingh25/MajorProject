import 'package:flutter/material.dart';
import 'package:land_registration/LandRegisterModel.dart';
import 'package:land_registration/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LandRegisterModel(),
      child: MaterialApp(
        home: home_page(),
      ),
    );
  }
}
