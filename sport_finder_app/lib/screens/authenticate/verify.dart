import 'dart:async';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sport_finder_app/services/auth.dart';

class Verify extends StatefulWidget {
  final Function toggleView;

  Verify({required this.toggleView});

  //const Register({Key? key, this.toggleView}) : super(key: key);

  @override
  _Verify createState() => _Verify();
}

class _Verify extends State<Verify> {
  final AuthService _auth = AuthService();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late bool _once;
  late int _timer;
  late FToast fToast;
  String username = "N/A";
  late Map<String, dynamic> data;

  @override
  void initState() {
    _once = false;
    _timer = 0;
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  Future getUserData() async {
    data = await _auth.getUserData();
    username = data['username'];
    return true;
  }

  Widget _heyUsername(context) {
    return new FutureBuilder(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: EdgeInsets.fromLTRB(40, 0, 40, 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Hey ' + username + ',',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return new Padding(
              padding: EdgeInsets.fromLTRB(40, 0, 40, 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Hey Error,',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
            );
          }
          return new Padding(
            padding: EdgeInsets.fromLTRB(40, 0, 40, 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Hey loading,',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          );
        });
  }

  _showToastVerify() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline),
          SizedBox(
            width: 12.0,
          ),
          Text("Verification email has been sent!\nWaiting for verification!"),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 3),
    );
  }
/*
  _showToastError() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.redAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.highlight_off),
          SizedBox(
            width: 12.0,
          ),
          Text("An error occurred during Verification!"),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }
*/
  _showToastVerifyWait() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.redAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.highlight_off),
          SizedBox(
            width: 12.0,
          ),
          Text("Please wait 10 seconds after sending!"),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  _showToastVerified() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline),
          SizedBox(
            width: 12.0,
          ),
          Text("Account has been verified!\nPlease login!"),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print(
            'Backbutton pressed (device or appbar button), do whatever you want.');

        //trigger leaving and use own data
        widget.toggleView(0);

        //we need to return a future
        return Future.value(false);
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 1,
              decoration: BoxDecoration(
                color: Color(0xFFEEEEEE),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.asset(
                    'assets/images/AppBG.png',
                  ).image,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'WELCOME',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.drafts_outlined,
                          color: Color(0x1A000000),
                          size: 170,
                        ),
                        iconSize: 170,
                      )
                    ],
                  ),
                  _heyUsername(context),
                  Padding(
                    padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Thank you for registering an account with Sports Finder!',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(40, 10, 40, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Before we get started, we'll need to verify your email.",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ArgonButton(
                          height: 40,
                          width: 130,
                          borderRadius: 12.0,
                          roundLoadingShape: true,
                          color: Colors.black,
                          child: Text(
                            "Verify Email",
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                              //fontSize: 18,
                              //fontWeight: FontWeight.w700
                            ),
                          ),
                          loader: Container(
                            padding: EdgeInsets.all(10),
                            child: SpinKitDoubleBounce(
                              color: Colors.white,
                            ),
                          ),
                          onTap: (startLoading, stopLoading, btnState) async {
                            if (_timer == 0) {
                              startLoading();
                              await _auth.verification();
                              _showToastVerify();

                              Timer.periodic(new Duration(seconds: 1), (timer) {
                                if (timer.tick.toInt() == 10) {
                                  timer.cancel();
                                  _timer = 0;
                                  stopLoading();
                                } else {
                                  _timer = timer.tick.toInt();
                                }
                              });
                            } else {
                              _showToastVerifyWait();
                            }
                            if (!_once) {
                              _once = true;
                              Timer.periodic(new Duration(seconds: 1),
                                  (timer) async {
                                dynamic user = await _auth.refreshUser();
                                if (user != null && user.emailVerified) {
                                  timer.cancel();
                                  _showToastVerified();
                                  await _auth.signOut();
                                  widget.toggleView(0);
                                }
                              });
                            }
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
