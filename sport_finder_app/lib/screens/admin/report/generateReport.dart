import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sport_finder_app/models/globalVariables.dart' as globalVariables;
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flowder/flowder.dart';

class GenerateReportWidget extends StatefulWidget {
  GenerateReportWidget({Key? key}) : super(key: key);
  static const String routeName = '/admin/report';
  @override
  _GenerateReportWidgetState createState() => _GenerateReportWidgetState();
}

class _GenerateReportWidgetState extends State<GenerateReportWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime date = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
  bool _btnOnce = false;
  String status = "Status: Please click generate button";
  String fileName = "";
  String remotePDFpath = "";
  late DownloaderUtils options;
  late DownloaderCore core;
  late final String path;
  late FToast fToast;

  @override
  void initState(){
    super.initState();
    initPlatformState();
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

  // Path provider
  Future<void> initPlatformState() async {
    _setPath();
    if (!mounted) return;
  }

  void _setPath() async {
    path = (await getExternalStorageDirectory())!.path;
  }

  // Generate Report
  Future<void> generateReport() async {
    try{
      DocumentSnapshot user = await FirebaseFirestore.instance.collection('users').doc(globalVariables.uid).get();
      Map<String, dynamic> data = user.data() as Map<String, dynamic>;
      final resp = await http.post(
        Uri.parse('https://accmngt.sfa.yewonkim.tk/admin/report'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'month': date.month.toString(),
          'year': date.year.toString(),
          'courtID': data['court_id'],
        }),
      );
      Map<String, dynamic> status = jsonDecode(resp.body);
      print(status['file']);
      setState(() {
        fileName = status['file'];
      });
    }catch (e) {
      setState(() {
        status = "Status: Data Not Found!";
      });
    }
  }

  Future<File> fromAsset(String asset, String filename) async {
    // To open from assets, you can copy them to the app storage folder, and the access them "locally"
    Completer<File> completer = Completer();

    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          'GENERATE REPORT',
          style: TextStyle(
            fontFamily: 'Ubuntu',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [],
        elevation: 4,
      ),
      backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                    child: Text(
                      'Select Month and Year. Only Month and Year will be read',
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: DateTimePicker(
                        initialValue: date.toString(),
                        type: DateTimePickerType.date,
                        dateMask: 'dd MMM yyyy',
                        firstDate: DateTime(2021, 1, 31, 0, 0, 0),
                        initialDate: date,
                        lastDate: DateTime(2099, 12, 31, 0, 0, 0),
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'From Date ',
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
                          contentPadding:
                          EdgeInsetsDirectional.fromSTEB(0, 14, 0, 0),
                          prefixIcon: Icon(
                            Icons.keyboard_arrow_down,
                          ),
                        ),
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.black,
                        ),
                        onChanged: (val) {
                          setState(() {
                            date = DateTime.parse(val);
                          });
                        },
                        validator: (val) {
                          print(val);
                          return null;
                        },
                        onSaved: (val) {
                          setState(() {
                            date = DateTime.parse(val!);
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                      child: ArgonButton(
                        height: 40,
                        width: 130,
                        borderRadius: 12.0,
                        borderSide:
                        BorderSide(color: Colors.black, width: 1),
                        roundLoadingShape: true,
                        color: Colors.black,
                        child: Text(
                          "Generate",
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
                            if(!_btnOnce){
                              _btnOnce = true;
                              startLoading();
                              setState(() {
                                status = "Status: Generating...";
                              });
                              await generateReport();
                              _btnOnce = false;
                              if(fileName != ""){
                                setState(() {
                                  status = "Status: File Ready To Download!";
                                });
                              }else{
                                setState(() {
                                  status = "Status: Data Not Found!";
                                });
                              }
                              stopLoading();
                              return;
                            }
                            _showToastWarning(context, "Please wait before trying again!");
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Flexible( child: Text(status), )
                    ],
                  ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ArgonButton(
                      height: 40,
                      width: 130,
                      borderRadius: 12.0,
                      borderSide:
                      BorderSide(color: Colors.black, width: 1),
                      roundLoadingShape: true,
                      color: Colors.black,
                      child: Text(
                        "Download",
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
                        if(fileName == ""){
                          _showToastWarning(context, "Please generate report first!");
                          return;
                        }
                        if(!_btnOnce){
                          _btnOnce = true;
                          startLoading();
                          setState(() {
                            status = "Status: Downloading...";
                          });
                          options = DownloaderUtils(
                            progressCallback: (current, total) {
                              final progress = (current / total) * 100;
                              setState(() {
                                status = "Status: $progress %";
                              });
                              print('Downloading: $progress');
                            },
                            file: File('$path/$fileName'),
                            progress: ProgressImplementation(),
                            onDone: (){
                              print('COMPLETE');
                              setState(() {
                                status = "Status: Download Completed!\nSaved at $path/$fileName";
                              });
                            },
                            deleteOnCancel: true,
                          );
                          core = await Flowder.download(
                              'https://accmngt.sfa.yewonkim.tk/admin/report/download?file=$fileName',
                              options);
                          _btnOnce = false;
                          stopLoading();
                          return;
                        }
                        _showToastWarning(context, "Please wait before trying again!");
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
