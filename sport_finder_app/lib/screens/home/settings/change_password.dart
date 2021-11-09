import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChangePasswordWidget extends StatefulWidget {
  ChangePasswordWidget({Key? key}) : super(key: key);
  static const String routeName = '/settings/change_password';

  @override
  _ChangePasswordWidgetState createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget> {
  late TextEditingController textController1;
  late bool passwordVisibility1;
  late TextEditingController textController2;
  late bool passwordVisibility2;
  late TextEditingController textController3;
  late bool passwordVisibility3;
  bool _loadingButton = false;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    textController1 = TextEditingController();
    passwordVisibility1 = false;
    textController2 = TextEditingController();
    passwordVisibility2 = false;
    textController3 = TextEditingController();
    passwordVisibility3 = false;
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
            'Password',
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
                        'Your password must be more than six characters.',
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
                          20, 10, 50, 0),
                      child: TextFormField(
                        controller: textController1,
                        obscureText: !passwordVisibility1,
                        decoration: InputDecoration(
                          hintText: 'Old Password',
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
                            Icons.lock_outlined,
                          ),
                          suffixIcon: InkWell(
                            onTap: () => setState(
                                  () => passwordVisibility1 =
                              !passwordVisibility1,
                            ),
                            child: Icon(
                              passwordVisibility1
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
                          20, 10, 50, 0),
                      child: TextFormField(
                        controller: textController2,
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
                          20, 10, 50, 0),
                      child: TextFormField(
                        controller: textController3,
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
