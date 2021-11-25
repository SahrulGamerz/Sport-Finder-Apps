import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:sport_finder_app/models/user.dart';
import 'package:sport_finder_app/screens/errors/error.dart';
import 'package:sport_finder_app/screens/errors/loading.dart';
import 'package:sport_finder_app/screens/wrapper.dart';
import 'package:sport_finder_app/services/auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

/// We are using a StatefulWidget such that we only create the [Future] once,
/// no matter how many times our widget rebuild.
/// If we used a [StatelessWidget], in the event where [App] is rebuilt, that
/// would re-initialize FlutterFire and make our application re-enter loading state,
/// which is undesired.
class App extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print(snapshot);
          return MaterialApp(home: Error());
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamProvider<UserInfoRetrieve?>.value(
              value: AuthService().user,
              initialData: null,
              child: MaterialApp(
                title: 'Sports Finder App',
                home: Wrapper(),
              ));
        }
        return MaterialApp(home: Loading()); //loading screen
      },
    );
  }
}
