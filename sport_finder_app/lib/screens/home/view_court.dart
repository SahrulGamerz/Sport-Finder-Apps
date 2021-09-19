import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:time_picker_widget/time_picker_widget.dart';

class ViewCourtWidget extends StatefulWidget {
  //ViewCourtWidget({required Key key}) : super(key: key);

  @override
  _ViewCourtWidgetState createState() => _ViewCourtWidgetState();
  final String cid;
  final int pph;
  final int cc;
  final String img;

  ViewCourtWidget(
      {required this.cid,
      required this.pph,
      required this.cc,
      required this.img});
}

class _ViewCourtWidgetState extends State<ViewCourtWidget> {
  late TextEditingController textController1;
  late TextEditingController textController2;
  late TextEditingController textController3;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime now = new DateTime.now();
  late FToast fToast;
  late int timestamp;
  late DateTime time1;
  late DateTime time2;
  int count = 0;

  @override
  void initState() {
    super.initState();
    textController1 = TextEditingController();
    textController2 = TextEditingController();
    textController3 = TextEditingController();
    fToast = FToast();
    fToast.init(context);
    timestamp = DateTime.now().millisecondsSinceEpoch;
    time1 = now;
    time2 = now;
  }

  Future _getCourtCount() async {
    count=0;
    await FirebaseFirestore.instance
        .collection('booking')
        .where("court_id", isEqualTo: widget.cid)
        .where("status", isEqualTo: "booked")
        .get()
        .then((QuerySnapshot querySnapshot) {
      print(querySnapshot.docs.length);
      for (var i = 0; i < querySnapshot.docs.length; i++) {
        print(querySnapshot.docs[i].data());
        Map<String, dynamic> data = querySnapshot.docs[i].data() as Map<String, dynamic>;
        print(data['end_date_time'].seconds * 1000);
        print(time2.millisecondsSinceEpoch);

        final int query_Start = time1.millisecondsSinceEpoch;
        final int query_End = time2.millisecondsSinceEpoch;
        final int start_Time = data['start_date_time'].seconds*1000;
        final int end_Time = data['end_date_time'].seconds * 1000;

        if(query_Start >= start_Time && query_Start < end_Time && query_End >= end_Time){
          count++;
        }else if(query_End <= end_Time && query_Start < start_Time && query_End > start_Time){
          count++;
        }else if(query_Start < start_Time && query_End > end_Time){
          count++;
        }


      }

      /*querySnapshot.docs.forEach((doc) {
            print(doc['end_date_time']);
            print(time2);
            if(doc['end_date_time'] <= time2){
              setState(() {
                count++;
              });

            }
          });*/
    });
    return true;
  }

  Widget _courtAvailability(BuildContext context) {
    return new FutureBuilder(
        key: ValueKey(timestamp),
        future: _getCourtCount(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 40),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.network(
                                  widget.img,
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  fit: BoxFit.cover,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(6, 0, 0, 0),
                        child: Text(
                          'Time & Date',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(2.64, 0.55),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(6, 0, 0, 0),
                          child: Text(
                            'RM ${widget.pph} Per hour',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Color(0xFF8B97A2),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(6, 0, 0, 0),
                          child: Text(
                            'Date',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(10, 0, 200, 0),
                          child: DateTimePicker(
                            initialValue: now.toString(),
                            type: DateTimePickerType.date,
                            dateMask: 'dd MMM yyyy',
                            firstDate: DateTime(DateTime.now().year,
                                DateTime.now().month, DateTime.now().day),
                            initialDate: now,
                            lastDate: DateTime(DateTime.now().year,
                                DateTime.now().month, DateTime.now().day + 3),
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: 'Set Time ',
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
                              now = DateTime.parse(val);
                              timestamp = DateTime.now().millisecondsSinceEpoch;
                            },
                            validator: (val) {
                              print(val);
                              return null;
                            },
                            onSaved: (val) {
                              now = DateTime.parse(val!);
                              timestamp = DateTime.now().millisecondsSinceEpoch;
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(6, 0, 0, 0),
                          child: Text(
                            'Time',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          child: InkWell(
                            onTap: () => showCustomTimePicker(
                                    context: context,
                                    onFailValidation: (context) {
                                      _showToastWarning(
                                          context, "Unavailable Time");
                                    },
                                    initialTime: TimeOfDay(hour: 10, minute: 0),
                                    selectableTimePredicate: (time) =>
                                        time!.hour >= 10 &&
                                        time.hour <= 20 &&
                                        time.minute % 30 == 0)
                                .then((time) => setState(() {
                                      textController2.text =
                                          time!.format(context);
                                      timestamp =
                                          DateTime.now().millisecondsSinceEpoch;
                                      DateTime timeOne = DateFormat.jm()
                                          .parse(textController2.text);
                                      time1 = DateTime.parse(
                                          DateFormat('yyyy-MM-dd').format(now) +
                                              ' ' +
                                              DateFormat('HH:mm:ss')
                                                  .format(timeOne));
                                    })),
                            child: TextFormField(
                              controller: textController2,
                              readOnly: true,
                              enabled: false,
                              obscureText: false,
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: 'Set Time ',
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
                              keyboardType: TextInputType.datetime,
                            ),
                          ),
                        ),
                      ),
                      Text('-'),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 13, 0),
                          child: InkWell(
                            onTap: () => showCustomTimePicker(
                                    context: context,
                                    onFailValidation: (context) {
                                      _showToastWarning(
                                          context, "Unavailable Time");
                                    },
                                    initialTime: TimeOfDay(hour: 10, minute: 0),
                                    selectableTimePredicate: (time) =>
                                        time!.hour >= 10 &&
                                        time.hour <= 20 &&
                                        time.minute % 30 == 0)
                                .then((time) => setState(() {
                                      textController3.text =
                                          time!.format(context);
                                      timestamp =
                                          DateTime.now().millisecondsSinceEpoch;
                                      DateTime timeOne = DateFormat.jm()
                                          .parse(textController3.text);
                                      time2 = DateTime.parse(
                                          DateFormat('yyyy-MM-dd').format(now) +
                                              ' ' +
                                              DateFormat('HH:mm:ss')
                                                  .format(timeOne));
                                    })),
                            child: TextFormField(
                              controller: textController3,
                              readOnly: true,
                              enabled: false,
                              obscureText: false,
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: 'Set Time ',
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
                              keyboardType: TextInputType.datetime,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(6, 0, 0, 0),
                              child: Text(
                                'Court Available',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 175, 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(10, 10, 9, 10),
                            child: Text(
                              '${widget.cc - count}/${widget.cc}',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 50, 0, 50),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
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
                              "Book",
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
                            onTap:
                                (startLoading, stopLoading, btnState) async {},
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return new Text("An error occurred, Please try again!");
          }
          return new LinearProgressIndicator();
        });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: Text(
          'VIEW COURT',
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
      body: _courtAvailability(context),
    );
  }
}
