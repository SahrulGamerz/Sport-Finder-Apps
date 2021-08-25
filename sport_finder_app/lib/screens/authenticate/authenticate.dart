import 'package:flutter/material.dart';
import 'package:sport_finder_app/screens/authenticate/forgot_password.dart';
import 'package:sport_finder_app/screens/authenticate/register.dart';
import 'package:sport_finder_app/screens/authenticate/sign_in.dart';
import 'package:sport_finder_app/screens/authenticate/verify.dart';

class Authenticate extends StatefulWidget {
  //const Authenticate({Key? key}) : super(key: key);
  final int toggleView;
  Authenticate({required this.toggleView});
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  int showAuthScreen = 0;
  bool _once = true;

  void toggleView(int screen){
    setState(() {
      showAuthScreen = screen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.toggleView == 2 && _once){
      _once = false;
      return Verify(toggleView: toggleView);
    }

    if(showAuthScreen == 0){
      return SignIn(toggleView: toggleView);
    }else if(showAuthScreen == 1){
      return Register(toggleView: toggleView);
    }else if(showAuthScreen == 2){
      return Verify(toggleView: toggleView);
    }else{
      return ForgotPassword(toggleView: toggleView);
    }
  }
}

