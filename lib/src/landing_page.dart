import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:warikan_native/src/costs/bloc/index.dart';
import 'package:warikan_native/src/costs/costs_page.dart';
import 'package:warikan_native/src/models/user.dart';
import 'package:warikan_native/src/services/auth.dart';
import 'package:warikan_native/src/services/database.dart';
import 'package:warikan_native/src/sign_in/sign_in_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User>(
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            return SignInPage();
          }
          return Provider<Database>(
            create: (_) => FirestoreDatabase(uid: user.uid),
            child: Consumer<Database>(
              builder: (context, database, child) {
                final FirebaseMessaging _firebaseMessaging =
                    FirebaseMessaging();
                _firebaseMessaging.requestNotificationPermissions();
                _firebaseMessaging.getToken().then((token) => print(token));

                _firebaseMessaging.configure(
                  onMessage: (Map<String, dynamic> message) {
                    print('Received notification: $message');
                  },
                  onResume: (Map<String, dynamic> message) {
                    print('on resume $message');
                    return;
                  },
                  onLaunch: (Map<String, dynamic> message) {
                    print('on launch $message');
                    return;
                  },
                );
                return BlocProvider<CostsBloc>(
                    create: (_) =>
                        CostsBloc(database: database)..add(LoadCosts()),
                    child: CostsPage());
              },
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
