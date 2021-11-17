import 'dart:async';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sport_finder_app/services/auth.dart';

class ChangePasswordWidget extends StatefulWidget {
  ChangePasswordWidget({Key? key}) : super(key: key);
  static const String routeName = '/settings/change_password';

  @override
  _ChangePasswordWidgetState createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget> {
  late TextEditingController password;
  late bool passwordVisibility2;
  late TextEditingController confirmPassword;
  late bool passwordVisibility3;
  final AuthService _auth = AuthService();
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late FToast fToast;
  bool _buttonEnabled = true;

  @override
  void initState() {
    super.initState();
    password = TextEditingController();
    passwordVisibility2 = false;
    confirmPassword  = TextEditingController();
    passwordVisibility3 = false;
    fToast = FToast();
    fToast.init(context);
  }

  Future<void> _showReLogDialog(BuildContext context) {
    TextEditingController emailR = TextEditingController();
    TextEditingController passwordR = TextEditingController();
    bool passwordRVisibility = false;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Please enter your credential",
              style: TextStyle(color: Colors.blue),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  TextFormField(
                    controller: emailR,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Email Address',
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
                      fillColor: Color(0x00FFFFFF),
                      contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  TextFormField(
                    controller: passwordR,
                    obscureText: !passwordRVisibility,
                    decoration: InputDecoration(
                      hintText: 'Password',
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
                      fillColor: Color(0x00FFFFFF),
                      contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                      prefixIcon: Icon(
                        Icons.https_outlined,
                      ),
                      suffixIcon: InkWell(
                        onTap: () => setState(
                              () => passwordRVisibility = !passwordRVisibility,
                        ),
                        child: Icon(
                          passwordRVisibility
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Color(0xFF757575),
                          size: 22,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      dynamic result = await _auth.reAuthenticateUser(
                          emailR.text, passwordR.text);
                      if (result) {
                        Navigator.of(context).pop(false);
                      }
                    },
                    child: Text('ReLog'),
                  ),
                ],
              ),
            ),
          );
        });
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

  _showToastError(BuildContext context, String text) {
    fToast.init(context);
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.redAccent,
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

  bool isPasswordCompliant(String password, [int minLength = 8]) {
    if (password.isEmpty) {
      return false;
    }

    bool hasUppercase = password.contains(new RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(new RegExp(r'[0-9]'));
    bool hasLowercase = password.contains(new RegExp(r'[a-z]'));
    bool hasSpecialCharacters =
    password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    bool hasMinLength = password.length >= minLength;

    return hasDigits &
    hasUppercase &
    hasLowercase &
    hasSpecialCharacters &
    hasMinLength;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.black,
          brightness: Brightness.dark,
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          automaticallyImplyLeading: true,
          title: Text(
            'CHANGE PASSWORD',
            style: TextStyle(
              fontFamily: 'Ubuntu',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [],
          elevation: 4,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          20, 20, 20, 10),
                      child: Text(
                        'Your password must be more than eight(8) characters and includes special characters..',
                        style:
                        TextStyle(
                          fontFamily: 'Lexend Deca',
                          color: Color(0xFF8B97A2),
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          20, 10, 20, 0),
                      child: TextFormField(
                        controller: password,
                        obscureText: !passwordVisibility2,
                        decoration: InputDecoration(
                          hintText: 'New Password',
                          hintStyle:
                          TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius:
                            BorderRadius.circular(5),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius:
                            BorderRadius.circular(5),
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          contentPadding:
                          EdgeInsetsDirectional.fromSTEB(
                              0, 15, 0, 0),
                          prefixIcon: Icon(
                            Icons.lock_outline,
                          ),
                          suffixIcon: InkWell(
                            onTap: () => setState(
                                  () => passwordVisibility2 =
                              !passwordVisibility2,
                            ),
                            child: Icon(
                              passwordVisibility2
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Color(0xFF757575),
                              size: 22,
                            ),
                          ),
                        ),
                        style:
                        TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.name,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Field is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          20, 10, 20, 0),
                      child: TextFormField(
                        controller: confirmPassword,
                        obscureText: !passwordVisibility3,
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          hintStyle:
                          TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius:
                            BorderRadius.circular(5),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius:
                            BorderRadius.circular(5),
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          contentPadding:
                          EdgeInsetsDirectional.fromSTEB(
                              0, 15, 0, 0),
                          prefixIcon: Icon(
                            Icons.lock_open_sharp,
                          ),
                          suffixIcon: InkWell(
                            onTap: () => setState(
                                  () => passwordVisibility3 =
                              !passwordVisibility3,
                            ),
                            child: Icon(
                              passwordVisibility3
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Color(0xFF757575),
                              size: 22,
                            ),
                          ),
                        ),
                        style:
                        TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.name,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Field is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        0, 100, 0, 0),
                    child: ArgonButton(
                      height: 40,
                      width: 130,
                      borderRadius: 12.0,
                      roundLoadingShape: true,
                      color: Colors.black,
                      child: Text(
                        "Change Password",
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
                      onTap: (startLoading, stopLoading,
                          btnState) async {
                        if (_buttonEnabled) {
                          _buttonEnabled = false;
                          startLoading();
                          if (!isPasswordCompliant(
                              password.text)) {
                            stopLoading();
                            _buttonEnabled = true;
                            _showToastWarning(context,
                                "Password does not meet the requirements.\nUpper & Lower case,\nSpecial characters,\nNumbers");
                          } else if (password.text !=
                              confirmPassword.text) {
                            stopLoading();
                            _buttonEnabled = true;
                            _showToastWarning(context,
                                "Password does not match!");
                          } else {
                            Timer.periodic(
                                new Duration(seconds: 1),
                                    (timer) {
                                  if (timer.tick.toInt() == 10) {
                                    timer.cancel();
                                    _buttonEnabled = true;
                                  }
                                });
                            dynamic result = await _auth
                                .changePassword(password.text);
                            //print(result);
                            if (result == "ReLog") {
                              _showToastWarning(context,
                                  "Please enter your credential and try again!");
                              stopLoading();
                              _showReLogDialog(context);
                            } else if (result) {
                              _showToastSuccess(context,
                                  "Password changed successfully!");
                              stopLoading();
                            } else {
                              _showToastError(context,
                                  "Password changed failed");
                              stopLoading();
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
