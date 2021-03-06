import 'package:flutter/material.dart';
import 'package:pets/home/home_page.dart';
import 'package:pets/services/auth.dart';
import 'package:pets/services/database.dart';
import 'package:pets/sign_in/sign_in_page.dart';
import 'package:provider/provider.dart';

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
            return SignInPage.create(context);
          }
          return Provider<User>.value(
            value: user,
            child: Provider<Database>(
                create: (_) => FireStoreDatabase(
                    uid: user.uid, displayName: user.displayName),
                child: HomePage()),
          );
        } else {
          //splash screen here
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
