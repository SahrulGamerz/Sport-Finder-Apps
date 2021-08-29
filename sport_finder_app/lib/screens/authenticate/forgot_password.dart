import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sport_finder_app/services/auth.dart';

class ForgotPassword extends StatefulWidget {
  final Function toggleView;
  ForgotPassword({required this.toggleView});

  //const Register({Key? key, this.toggleView}) : super(key: key);

  @override
  _ForgotPassword createState() => _ForgotPassword();
}

class _ForgotPassword extends State<ForgotPassword> {
  late TextEditingController email;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthService _auth = AuthService();
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    email = TextEditingController();
    fToast = FToast();
    fToast.init(context);
  }
  _showToastSuccess() {
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
          Text("Password Reset Email have been sent,\n please check your email to reset your password"),
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
      print('Backbutton pressed (device or appbar button), do whatever you want.');

      //trigger leaving and use own data
      widget.toggleView(0);

      //we need to return a future
      return Future.value(false);
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment(0, -0.13),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 65, 0, 0),
                            child: Text(
                              'FORGOT PASSWORD',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Ubuntu',
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(45, 10, 45, 0),
                            child: Text(
                              'Please enter the email address you\'d like your password reset information sent to',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                          child: TextFormField(
                            controller: email,
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
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(4.0),
                                  topRight: Radius.circular(4.0),
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                              prefixIcon: Icon(
                                Icons.email_outlined,
                              ),
                            ),
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.black,
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.fromLTRB(50, 20, 50, 0),
                            child: ArgonButton(
                              height: 40,
                              width: 130,
                              borderRadius: 12.0,
                              roundLoadingShape: true,
                              color: Colors.black,
                              child: Text(
                                "Forgot Password",
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
                                  ///size: ,
                                ),
                              ),
                              onTap: (startLoading, stopLoading, btnState) async {
                                //dlm ni eh sume function tuk tkn tu. refer tutorial
                                final bool isEmailValid = EmailValidator.validate(email.text);
                                if(isEmailValid){
                                  dynamic result = await _auth.forgotPassword(email.text);
                                  if (result != null){
                                    _showToastSuccess();
                                  }
                                }
                              },
                            )
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
