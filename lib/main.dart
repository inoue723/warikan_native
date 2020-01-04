import 'package:flutter/material.dart';
import 'package:warikan_native/src/landing_page.dart';
import 'package:warikan_native/src/services/auth.dart';
import 'package:warikan_native/src/services/auth_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: Auth(),
      child: MaterialApp(
        title: "warikan",
        theme: ThemeData(primarySwatch: Colors.brown),
        home: LandingPage(),
      ),
    );
  }
}
