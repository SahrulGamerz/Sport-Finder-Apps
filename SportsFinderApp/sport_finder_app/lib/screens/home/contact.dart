import 'dart:async';
import 'dart:convert';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sport_finder_app/widgets/drawer.dart';
import 'package:http/http.dart' as http;

class Contact extends StatefulWidget {
  const Contact({Key? key}) : super(key: key);

  static const String routeName = '/contact';

  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  late TextEditingController textController1;
  late TextEditingController textController2;
  late TextEditingController textController3;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late FToast fToast;
  bool _buttonEnabled = true;

  @override
  void initState() {
    super.initState();
    textController1 = TextEditingController();
    textController2 = TextEditingController();
    textController3 = TextEditingController();
    fToast = FToast();
    fToast.init(context);
  }

  _showToastSuccess(BuildContext context, String text) {
    fToast.init(context);
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
          Text(text),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  _showToastWarning(BuildContext context, String text) {
    fToast.init(context);
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.orangeAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline),
          SizedBox(
            width: 12.0,
          ),
          Text(text),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  Future sendEmail({
    required String name,
    required String email,
    required String message,
  }) async {
    final serviceID = 'service_4n5f5yz';
    final templateID = 'template_dnem1rq';
    final userID = 'user_Arp3PlPUizE2qXveHa3lp';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceID,
        'template_id': templateID,
        'user_id': userID,
        'template_params': {
          'user_name': name,
          'user_email': email,
          'user_message': message,
        },
        'accessToken': "ebb3ab2a2bf6ace755de6e963c39410f"
      }),
    );

    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          'CONTACT',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Ubuntu',
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [],
      ),
      drawer: AppDrawer(currentView: 'Contact'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Contact Us',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                        fontSize: 40,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Please contact us using the form below',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: TextFormField(
                          controller: textController1,
                          obscureText: false,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Name',
                            hintStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.black,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.black,
                          ),
                          keyboardType: TextInputType.name,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: TextFormField(
                          controller: textController2,
                          obscureText: false,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Email',
                            hintStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.black,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.black,
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: TextFormField(
                          controller: textController3,
                          obscureText: false,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Message',
                            hintStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.black,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 200),
                          ),
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                        child: ArgonButton(
                          height: 40,
                          width: 130,
                          borderRadius: 12.0,
                          roundLoadingShape: true,
                          color: Colors.black,
                          child: Text(
                            "Submit",
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
                            if (_buttonEnabled) {
                              if (textController1.text == "" ||
                                  textController2.text == "" ||
                                  textController3.text == "") {
                                _showToastWarning(
                                    context, "Please fill in all fields!");
                              } else {
                                if (EmailValidator.validate(
                                    textController2.text)) {
                                  Timer.periodic(new Duration(seconds: 1),
                                      (timer) {
                                    if (timer.tick.toInt() == 10) {
                                      timer.cancel();
                                      _buttonEnabled = true;
                                    }
                                  });
                                  startLoading();
                                  await sendEmail(
                                    name: textController1.text,
                                    email: textController2.text,
                                    message: textController3.text,
                                  );
                                  stopLoading();
                                  _showToastSuccess(
                                      context, "Message successfully sent");
                                } else {
                                  _showToastWarning(
                                      context, "Invalid email address!");
                                }
                              }
                            } else {
                              _showToastWarning(context,
                                  "Please wait 10 seconds before trying!");
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
