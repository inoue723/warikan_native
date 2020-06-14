import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:warikan_native/src/common_widgets/platform_alert_dialog.dart';
import 'package:warikan_native/src/costs/bloc/index.dart';
import 'package:warikan_native/src/costs/costs_page.dart';
import 'package:warikan_native/src/invitation/bloc/invitation_bloc.dart';
import 'package:warikan_native/src/models/user.dart';
import 'package:warikan_native/src/services/auth.dart';
import 'package:warikan_native/src/services/database.dart';
import 'package:warikan_native/src/sign_in/sign_in_page.dart';

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
                return BlocProvider<InvitationBloc>(
                  create: (context) => InvitationBloc(database)
                    ..add(
                      InvitationInit(),
                    ),
                  child: BlocConsumer<InvitationBloc, InvitationState>(
                    listener: (context, state) {
                      if (state is InvitationNotInvited) {
                        showDialog(
                          context: context,
                          child: PlatformAlertDialog(
                            title: "割り勘する相手を招待しましょう",
                            content: "",
                            defaultActionText: "招待する",
                            cancelActionText: "キャンセル",
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is InvitationInvited) {
                        return BlocProvider<CostsBloc>(
                          create: (context) {
                            return CostsBloc(
                              database: database,
                              partnerId: state.partnerId,
                            )..add(LoadCosts());
                          },
                          child: CostsPage(),
                        );
                      } else if (state is InvitationNotInvited) {
                        return BlocProvider<CostsBloc>(
                          create: (context) {
                            return CostsBloc(
                              database: database,
                              partnerId: null,
                            )..add(LoadCosts());
                          },
                          child: CostsPage(),
                        );
                      }

                      return Scaffold(
                        body: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                  ),
                );
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
