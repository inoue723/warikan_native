import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warikan_native/src/utils/create_material_color.dart';
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
        theme: ThemeData(primarySwatch: createMaterialColor(Color(0xFF1e68e7))),
        home: LandingPage(),
      ),
    );
  }
}
