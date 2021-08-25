import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/gestures.dart';
import 'package:sport_finder_app/services/auth.dart';

class SignIn extends StatefulWidget {
  //const SignIn({Key? key}) : super(key: key);
  final Function toggleView;
  SignIn({required this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  late TextEditingController email;
  late TextEditingController password;
  late bool passwordVisibility;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final ButtonStyle style = ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
  late FToast fToast;

  @override
  void initState() {
    email = TextEditingController();
    password = TextEditingController();
    passwordVisibility = false;
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  _showToastVerify() {
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
          Text("Please verify your email!"),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }
  _showToastNotExist() {
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
          Text("Account doesn't exist!"),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
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
          Text("Logged In!"),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }
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
          Text("An error occurred during sign in!"),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }
  _showToastEmail() {
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
          Text("Incorrect Email!"),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }
  _showToastPassword() {
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
          Text("Wrong Password!"),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }
  _showToastRate() {
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
          Text("You have been rate limited due\ntoo many request has been sent!\nTry again later!"),
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
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
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
                  Align(
                    alignment: Alignment(0, -0.6),
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(50, 10, 50, 0),
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
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(50, 10, 50, 0),
                        child: TextFormField(
                          controller: password,
                          obscureText: !passwordVisibility,
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
                                    () => passwordVisibility = !passwordVisibility,
                              ),
                              child: Icon(
                                passwordVisibility
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
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(50, 10, 50, 0),
                        child: ArgonButton(
                          height: 40,
                          width: 1000,
                          borderRadius: 12.0,
                          roundLoadingShape: true,
                          color: Colors.black,
                          child: Text(
                            "Login",
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
                            final bool isEmailValid = EmailValidator.validate(email.text);
                            if(isEmailValid){
                              startLoading();
                              dynamic result = await _auth.signInEmailPass(email.text, password.text);
                              if(result == "NotFound"){
                                stopLoading();
                                _showToastNotExist();
                              }else if(result == "WrongPassword"){
                                stopLoading();
                                _showToastPassword();
                              }else if(result == "RateLimited"){
                                stopLoading();
                                _showToastRate();
                              }else if(result == null){
                                stopLoading();
                                _showToastError();
                              }else if(!result.emailVerified){
                                _showToastVerify();
                                widget.toggleView(2);
                              }else{
                                print(result.uid);
                                _showToastSuccess();
                              }
                            }else{
                              _showToastEmail();
                            }
                          },
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Color(0xFF002A97),
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Forgot password?',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Color(0xFF002A97),
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          //_showToastError();
                                          widget.toggleView(3);
                                        }
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Color(0xFF002A97),
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Sign up',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Color(0xFF002A97),
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          //_showToastError();
                                          widget.toggleView(1);
                                        }
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    ],
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
