import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:warikan_native/src/utils/create_material_color.dart';
import 'package:warikan_native/src/landing_page.dart';
import 'package:warikan_native/src/services/auth.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child:
                Text("エラーが発生しました。改善しない場合はサポート(omuni723@gmail.com)にお問い合わせください。"),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
        title: "warikan",
        theme: ThemeData(
          primarySwatch: createMaterialColor(Color(0xFF1e68e7)),
          fontFamily: "Noto Sans JP",
        ),
        home: LandingPage(),
      ),
    );
  }
}
