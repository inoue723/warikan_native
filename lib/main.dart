import 'package:flutter/material.dart';
import 'package:warikan_native/src/landing_page.dart';
import 'package:warikan_native/src/services/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "warikan",
      theme: ThemeData(primarySwatch: Colors.brown),
      home: LandingPage(
        auth: Auth(),
      ),
    );
  }
}
