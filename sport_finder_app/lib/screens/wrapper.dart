import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sport_finder_app/models/user.dart';
import 'package:sport_finder_app/screens/authenticate/authenticate.dart';
import 'package:sport_finder_app/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserInfoRetrieve?>(context);
    //return either Home or Authenticate Widget
    if(user == null){
      return Authenticate(toggleView: 0);
    }else if(!user.emailVerified){
      return Authenticate(toggleView: 2);
    }else{
      return Home();
    }
  }
}
