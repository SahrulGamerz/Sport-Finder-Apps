import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPassWidget extends StatefulWidget {
  ForgotPassWidget({required Key key}) : super(key: key);

  @override
  _ForgotPassWidgetState createState() => _ForgotPassWidgetState();
}

class _ForgotPassWidgetState extends State<ForgotPassWidget> {
  late TextEditingController email;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    email = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Column(
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
                        onTap: (startLoading, stopLoading, btnState) {
                          //dlm ni eh sume function tuk tkn tu. refer tutorial
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
    );
  }
}
