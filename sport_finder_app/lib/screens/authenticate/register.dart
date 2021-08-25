import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({required this.toggleView});

  //const Register({Key? key, this.toggleView}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late TextEditingController name;
  late TextEditingController email;
  late TextEditingController password;
  late bool passwordVis;
  late TextEditingController confirmPassword;
  late bool confirmPasswordVis;
  late bool checkbox;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    name = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();
    passwordVis = false;
    confirmPassword = TextEditingController();
    confirmPasswordVis = false;
    checkbox = false;

    super.initState();
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  shape: BoxShape.rectangle,
                ),
                alignment: Alignment(0, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment(0, 0),
                          child: Text(
                            'SIGN UP',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Ubuntu',
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                    Align(
                      alignment: Alignment(0, 0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(50, 10, 50, 0),
                                    child: TextFormField(
                                      controller: name,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        hintText: 'Name', // bukn username eh, ni display name limit length die dlm 15 chara
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
                                        EdgeInsets.fromLTRB(0, 15, 0, 0),
                                        prefixIcon: Icon(
                                          Icons.account_circle_outlined,
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
                                    padding: EdgeInsets.fromLTRB(50, 10, 50, 0),
                                    child: TextFormField(
                                      controller: email,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        hintText: 'Email Address',
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
                                        EdgeInsets.fromLTRB(0, 15, 0, 0),
                                        prefixIcon: Icon(
                                          Icons.email_outlined,
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
                                    padding: EdgeInsets.fromLTRB(50, 10, 50, 0),
                                    child: TextFormField(
                                      controller: password,
                                      obscureText: !passwordVis,
                                      decoration: InputDecoration(
                                        hintText: 'Password',
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
                                        EdgeInsets.fromLTRB(0, 15, 0, 0),
                                        prefixIcon: Icon(
                                          Icons.lock_outline,
                                        ),
                                        suffixIcon: InkWell(
                                          onTap: () => setState(
                                                () => passwordVis =
                                            !passwordVis,
                                          ),
                                          child: Icon(
                                            passwordVis
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
                                    padding: EdgeInsets.fromLTRB(50, 10, 50, 0),
                                    child: TextFormField(
                                      controller: confirmPassword,
                                      obscureText: !confirmPasswordVis,
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
                                        EdgeInsets.fromLTRB(0, 15, 0, 0),
                                        prefixIcon: Icon(
                                          Icons.lock_open_sharp,
                                        ),
                                        suffixIcon: InkWell(
                                          onTap: () => setState(
                                                () => confirmPasswordVis =
                                            !confirmPasswordVis,
                                          ),
                                          child: Icon(
                                            confirmPasswordVis
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
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment(0, 0),
                                    child: Padding(
                                      padding:
                                      EdgeInsets.fromLTRB(50, 0, 50, 0),
                                      child: CheckboxListTile(
                                        value: checkbox,
                                        onChanged: (newValue) => setState(() =>
                                        checkbox = !checkbox),
                                        title: Text(
                                          'I read and agree to Terms & Conditions',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        tileColor: Color(0x00F5F5F5),
                                        activeColor: Colors.black,
                                        dense: true,
                                        controlAffinity:
                                        ListTileControlAffinity.leading,
                                      ),
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
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  child: ArgonButton(
                                    height: 40,
                                    width: 130,
                                    borderRadius: 12.0,
                                    roundLoadingShape: true,
                                    color: Colors.black,
                                    child: Text(
                                      "Sign Up",
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
                                      //awie kt sini gak eh function signup tngok turoaial
                                    },
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(text: 'Already have an account?\n'),
                                          TextSpan(
                                            text: 'Sign In',
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              color: Color(0xFF002A97),
                                              fontSize: 12,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                widget.toggleView(0);
                                              }
                                            ),
                                        ],
                                      ),
                                    )
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
