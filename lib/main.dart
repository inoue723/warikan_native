import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warikan_native/src/common_widgets/custom_swatch.dart';
import 'package:warikan_native/src/landing_page.dart';
import 'package:warikan_native/src/services/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        title: "warikan",
        theme: ThemeData(primarySwatch: customSwatch),
        home: LandingPage(),
      ),
    );
  }
}
