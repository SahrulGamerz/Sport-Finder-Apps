import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sport_finder_app/models/globalVariables.dart'
    as globalVariables;
import 'package:time_picker_widget/time_picker_widget.dart';

class BookingEditWidget extends StatefulWidget {
  final Map<String, dynamic> dataMap;
  final String id;

  BookingEditWidget({Key? key, required this.dataMap, required this.id})
      : super(key: key);
  static const String routeName = '/admin/booking/edit';

  @override
  _BookingEditWidgetState createState() => _BookingEditWidgetState();
}

class _BookingEditWidgetState extends State<BookingEditWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController textController1;
  late TextEditingController textController2;
  late TextEditingController textController3;
  late FToast fToast;
  late DateTime time1;
  late DateTime time2;
  late DateTime now;
  bool _btnOnce = false;
  late DateTime date;
  late DateTime date2;

  void initState() {
    super.initState();
    textController1 = TextEditingController();
    textController2 = TextEditingController();
    textController3 = TextEditingController();
    date = widget.dataMap['start_date_time'].toDate();
    date2 = widget.dataMap['end_date_time'].toDate();
    time1 = date;
    time2 = date2;
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

  Widget _buildBookingEdit(BuildContext context) {
    if (widget.dataMap['game_id'] != "") {
      return new FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('games')
              .doc(widget.dataMap["game_id"])
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              DocumentSnapshot documentSnapshot =
                  snapshot.data as DocumentSnapshot;
              Map<String, dynamic> game =
                  documentSnapshot.data() as Map<String, dynamic>;
              Map<String, dynamic> gameDetails =
                  game['gameDetails'] as Map<String, dynamic>;
              return new FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(globalVariables.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      DocumentSnapshot documentSnapshot =
                          snapshot.data as DocumentSnapshot;
                      Map<String, dynamic> user =
                          documentSnapshot.data() as Map<String, dynamic>;
                      now = date;
                      textController2.text =
                          TimeOfDay.fromDateTime(time1).format(context);
                      textController3.text =
                          TimeOfDay.fromDateTime(time2).format(context);
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    20, 16, 0, 0),
                                child: Text(
                                  'Paid',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Color(0xFF8B97A2),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  20, 16, 20, 70),
                              child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: Color(0xFFF5F5F5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 20, 0, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20, 0, 0, 0),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: Image.network(
                                                user['profile_picture'],
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    20, 0, 0, 0),
                                            child: Text(
                                              user['username'],
                                              style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 22,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 40, 0, 2),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(20, 0, 0, 0),
                                              child: Text(
                                                'Game Type',
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Color(0xFF8B97A2),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 2, 0, 2),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(20, 0, 0, 0),
                                              child: Text(
                                                gameDetails['gameType'],
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 20, 0, 2),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(20, 0, 0, 0),
                                              child: Text(
                                                'Location',
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Color(0xFF8B97A2),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 2, 0, 2),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(20, 0, 0, 0),
                                              child: Text(
                                                gameDetails['court_name'],
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 20, 0, 2),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(20, 0, 0, 0),
                                              child: Text(
                                                'Players',
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Color(0xFF8B97A2),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 2, 0, 2),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(20, 0, 0, 0),
                                              child: Text(
                                                '1/1 Players',
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 20, 0, 2),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(20, 0, 0, 0),
                                              child: Text(
                                                'Date',
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Color(0xFF8B97A2),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            20, 2, 200, 2),
                                        child: DateTimePicker(
                                          initialValue: now.toString(),
                                          type: DateTimePickerType.date,
                                          dateMask: 'dd MMM yyyy',
                                          firstDate: DateTime(
                                              DateTime.now().year,
                                              DateTime.now().month,
                                              DateTime.now().day),
                                          initialDate: now,
                                          lastDate: DateTime(
                                              DateTime.now().year,
                                              DateTime.now().month,
                                              DateTime.now().day + 20),
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
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(4.0),
                                                topRight: Radius.circular(4.0),
                                              ),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(4.0),
                                                topRight: Radius.circular(4.0),
                                              ),
                                            ),
                                            contentPadding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 14, 0, 0),
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
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 20, 0, 2),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(20, 0, 0, 0),
                                              child: Text(
                                                'Time',
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Color(0xFF8B97A2),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            20, 2, 20, 2),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: () =>
                                                    showCustomTimePicker(
                                                        context: context,
                                                        onFailValidation:
                                                            (context) {
                                                          _showToastWarning(
                                                              context,
                                                              "Unavailable Time");
                                                        },
                                                        initialTime: TimeOfDay(
                                                            hour: 10,
                                                            minute: 0),
                                                        selectableTimePredicate:
                                                            (time) =>
                                                                time!.hour >=
                                                                    10 &&
                                                                time.hour <=
                                                                    19 &&
                                                                time.minute %
                                                                        30 ==
                                                                    0).then(
                                                        (time) => setState(() {
                                                              textController2
                                                                      .text =
                                                                  time!.format(
                                                                      context);
                                                              DateTime timeOne;
                                                              if (textController2
                                                                      .text
                                                                      .contains(
                                                                          "AM") ||
                                                                  textController2
                                                                      .text
                                                                      .contains(
                                                                          "PM")) {
                                                                timeOne = DateFormat
                                                                        .jm()
                                                                    .parse(textController2
                                                                        .text);
                                                              } else {
                                                                timeOne = DateFormat
                                                                        .Hm()
                                                                    .parse(textController2
                                                                        .text);
                                                              }
                                                              time1 = DateTime.parse(DateFormat(
                                                                          'yyyy-MM-dd')
                                                                      .format(
                                                                          now) +
                                                                  ' ' +
                                                                  DateFormat(
                                                                          'HH:mm:ss')
                                                                      .format(
                                                                          timeOne));
                                                            })),
                                                child: TextFormField(
                                                  controller: textController2,
                                                  readOnly: true,
                                                  enabled: false,
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    isDense: true,
                                                    hintText: 'From',
                                                    hintStyle: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      color: Colors.black,
                                                    ),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topLeft:
                                                            Radius.circular(
                                                                4.0),
                                                        topRight:
                                                            Radius.circular(
                                                                4.0),
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topLeft:
                                                            Radius.circular(
                                                                4.0),
                                                        topRight:
                                                            Radius.circular(
                                                                4.0),
                                                      ),
                                                    ),
                                                    contentPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 14, 0, 0),
                                                    prefixIcon: Icon(
                                                      Icons.keyboard_arrow_down,
                                                    ),
                                                  ),
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    color: Colors.black,
                                                  ),
                                                  keyboardType:
                                                      TextInputType.datetime,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(5, 2, 5, 2),
                                              child: Text("-"),
                                            ),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () =>
                                                    showCustomTimePicker(
                                                        context: context,
                                                        onFailValidation:
                                                            (context) {
                                                          _showToastWarning(
                                                              context,
                                                              "Unavailable Time");
                                                        },
                                                        initialTime: TimeOfDay(
                                                            hour: 11,
                                                            minute: 0),
                                                        selectableTimePredicate:
                                                            (time) =>
                                                                time!.hour >=
                                                                    11 &&
                                                                time.hour <=
                                                                    20 &&
                                                                time.minute %
                                                                        30 ==
                                                                    0).then(
                                                        (time) => setState(() {
                                                              textController3
                                                                      .text =
                                                                  time!.format(
                                                                      context);
                                                              DateTime timeOne;
                                                              if (textController3
                                                                      .text
                                                                      .contains(
                                                                          "AM") ||
                                                                  textController3
                                                                      .text
                                                                      .contains(
                                                                          "PM")) {
                                                                timeOne = DateFormat
                                                                        .jm()
                                                                    .parse(textController3
                                                                        .text);
                                                              } else {
                                                                timeOne = DateFormat
                                                                        .Hm()
                                                                    .parse(textController3
                                                                        .text);
                                                              }
                                                              time2 = DateTime.parse(DateFormat(
                                                                          'yyyy-MM-dd')
                                                                      .format(
                                                                          now) +
                                                                  ' ' +
                                                                  DateFormat(
                                                                          'HH:mm:ss')
                                                                      .format(
                                                                          timeOne));
                                                            })),
                                                child: TextFormField(
                                                  controller: textController3,
                                                  readOnly: true,
                                                  enabled: false,
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    isDense: true,
                                                    hintText: 'To',
                                                    hintStyle: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      color: Colors.black,
                                                    ),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topLeft:
                                                            Radius.circular(
                                                                4.0),
                                                        topRight:
                                                            Radius.circular(
                                                                4.0),
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topLeft:
                                                            Radius.circular(
                                                                4.0),
                                                        topRight:
                                                            Radius.circular(
                                                                4.0),
                                                      ),
                                                    ),
                                                    contentPadding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                0, 14, 0, 0),
                                                    prefixIcon: Icon(
                                                      Icons.keyboard_arrow_down,
                                                    ),
                                                  ),
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    color: Colors.black,
                                                  ),
                                                  keyboardType:
                                                      TextInputType.datetime,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 20, 0, 0),
                                        child: ArgonButton(
                                          height: 40,
                                          width: 130,
                                          borderRadius: 12.0,
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 1),
                                          roundLoadingShape: true,
                                          color: Colors.black,
                                          child: Text(
                                            "Update",
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
                                            if (time1 == time2 ||
                                                time1 == now ||
                                                time2 == now ||
                                                time1.isAfter(time2)) {
                                              _showToastWarning(context,
                                                  "Please select time!");
                                              return;
                                            }
                                            if (!_btnOnce) {
                                              startLoading();
                                              setState(() async {
                                                // Send message
                                                CollectionReference msgSRef =
                                                    FirebaseFirestore.instance
                                                        .collection('messages')
                                                        .doc(widget
                                                            .dataMap["game_id"])
                                                        .collection("messages");
                                                await msgSRef
                                                    .doc()
                                                    .set({
                                                      'uid':
                                                          globalVariables.uid,
                                                      "timestamp":
                                                          DateTime.now(),
                                                      "msg":
                                                          "Administrator has updated the booking date and system has changed the game date to match the current booking time!",
                                                    })
                                                    .then((value) =>
                                                        {print("Message sent")})
                                                    .catchError((error) {
                                                      print(
                                                          "Failed to send msg: $error");
                                                    });

                                                //update message
                                                CollectionReference msgIRef =
                                                    FirebaseFirestore.instance
                                                        .collection('messages');
                                                await msgIRef
                                                    .doc(widget
                                                        .dataMap["game_id"])
                                                    .update({
                                                      "last_updated":
                                                          DateTime.now(),
                                                      "last_message":
                                                          "Administrator has updated the booking date and system has changed the game date to match the current booking time!",
                                                    })
                                                    .then((value) => {
                                                          print(
                                                              "Message Update")
                                                        })
                                                    .catchError((error) {
                                                      print(
                                                          "Failed to update msg: $error");
                                                    });

                                                //update game details
                                                DocumentReference games =
                                                    FirebaseFirestore.instance
                                                        .collection('games')
                                                        .doc(widget.dataMap[
                                                            "game_id"]);
                                                await games
                                                    .update({
                                                      "gameDetails": {
                                                        "court_name":
                                                            gameDetails[
                                                                'court_name'],
                                                        "date": time1,
                                                        "to": time2,
                                                        "gameType": gameDetails[
                                                            'gameType'],
                                                        "slots": gameDetails[
                                                            'slots'],
                                                      },
                                                    })
                                                    .then((value) =>
                                                        {print("Games Update")})
                                                    .catchError((error) {
                                                      print(
                                                          "Failed to update msg: $error");
                                                    });

                                                //update booking details
                                                DocumentReference booking =
                                                    FirebaseFirestore.instance
                                                        .collection('booking')
                                                        .doc(widget.id);
                                                await booking.update({
                                                  'start_date_time': time1,
                                                  'end_date_time': time2,
                                                }).then((value) {
                                                  print("Booking Update");
                                                  _showToastSuccess(context,
                                                      "Booking has been updated!");
                                                  stopLoading();
                                                }).catchError((error) {
                                                  print(
                                                      "Failed to update booking: $error");
                                                  _showToastWarning(context,
                                                      "Update failed!");
                                                  stopLoading();
                                                });
                                              });
                                              stopLoading();
                                              return;
                                            }
                                            _showToastWarning(context,
                                                "Please wait before trying again!");
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return new Text("An error occurred, Please try again!");
                    }
                    return new LinearProgressIndicator();
                  });
            } else if (snapshot.hasError) {
              return new Text("An error occurred, Please try again!");
            }
            return new LinearProgressIndicator();
          });
    } else {
      return new FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('locations')
              .doc(widget.dataMap["court_id"])
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              DocumentSnapshot documentSnapshot =
                  snapshot.data as DocumentSnapshot;
              try {
                Map<String, dynamic> court =
                    documentSnapshot.data() as Map<String, dynamic>;
                return new FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(globalVariables.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        DocumentSnapshot documentSnapshot =
                            snapshot.data as DocumentSnapshot;
                        Map<String, dynamic> user =
                            documentSnapshot.data() as Map<String, dynamic>;
                        now = date;
                        textController2.text =
                            TimeOfDay.fromDateTime(time1).format(context);
                        textController3.text =
                            TimeOfDay.fromDateTime(time2).format(context);
                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      20, 16, 0, 0),
                                  child: Text(
                                    'Paid',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Color(0xFF8B97A2),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    20, 16, 20, 70),
                                child: Card(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  color: Color(0xFFF5F5F5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 20, 0, 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(20, 0, 0, 0),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.2,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Image.network(
                                                  user['profile_picture'],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(20, 0, 0, 0),
                                              child: Text(
                                                user['username'],
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Align(
                                        alignment: AlignmentDirectional(0, 0),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 40, 0, 2),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(20, 0, 0, 0),
                                                child: Text(
                                                  'Game Type',
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    color: Color(0xFF8B97A2),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: AlignmentDirectional(0, 0),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 2, 0, 2),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(20, 0, 0, 0),
                                                child: Text(
                                                  court['gameType'],
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: AlignmentDirectional(0, 0),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 20, 0, 2),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(20, 0, 0, 0),
                                                child: Text(
                                                  'Location',
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    color: Color(0xFF8B97A2),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: AlignmentDirectional(0, 0),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 2, 0, 2),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(20, 0, 0, 0),
                                                child: Text(
                                                  court['court_name'],
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: AlignmentDirectional(0, 0),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 20, 0, 2),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(20, 0, 0, 0),
                                                child: Text(
                                                  'Players',
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    color: Color(0xFF8B97A2),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: AlignmentDirectional(0, 0),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 2, 0, 2),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(20, 0, 0, 0),
                                                child: Text(
                                                  '1/1 Players',
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: AlignmentDirectional(0, 0),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 20, 0, 2),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(20, 0, 0, 0),
                                                child: Text(
                                                  'Date',
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    color: Color(0xFF8B97A2),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: AlignmentDirectional(0, 0),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  20, 2, 200, 2),
                                          child: DateTimePicker(
                                            initialValue: now.toString(),
                                            type: DateTimePickerType.date,
                                            dateMask: 'dd MMM yyyy',
                                            firstDate: DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month,
                                                DateTime.now().day),
                                            initialDate: now,
                                            lastDate: DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month,
                                                DateTime.now().day + 20),
                                            decoration: InputDecoration(
                                              isDense: true,
                                              hintText: 'Set Time ',
                                              hintStyle: TextStyle(
                                                fontFamily: 'Montserrat',
                                                color: Colors.black,
                                              ),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(4.0),
                                                  topRight:
                                                      Radius.circular(4.0),
                                                ),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(4.0),
                                                  topRight:
                                                      Radius.circular(4.0),
                                                ),
                                              ),
                                              contentPadding:
                                                  EdgeInsetsDirectional
                                                      .fromSTEB(0, 14, 0, 0),
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
                                      ),
                                      Align(
                                        alignment: AlignmentDirectional(0, 0),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 20, 0, 2),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(20, 0, 0, 0),
                                                child: Text(
                                                  'Time',
                                                  style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    color: Color(0xFF8B97A2),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: AlignmentDirectional(0, 0),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  20, 2, 20, 2),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () =>
                                                      showCustomTimePicker(
                                                          context: context,
                                                          onFailValidation:
                                                              (context) {
                                                            _showToastWarning(
                                                                context,
                                                                "Unavailable Time");
                                                          },
                                                          initialTime:
                                                              TimeOfDay(
                                                                  hour: 10,
                                                                  minute: 0),
                                                          selectableTimePredicate:
                                                              (time) =>
                                                                  time!.hour >=
                                                                      10 &&
                                                                  time.hour <=
                                                                      19 &&
                                                                  time.minute %
                                                                          30 ==
                                                                      0).then(
                                                          (time) =>
                                                              setState(() {
                                                                textController2
                                                                        .text =
                                                                    time!.format(
                                                                        context);
                                                                DateTime
                                                                    timeOne;
                                                                if (textController2
                                                                        .text
                                                                        .contains(
                                                                            "AM") ||
                                                                    textController2
                                                                        .text
                                                                        .contains(
                                                                            "PM")) {
                                                                  timeOne = DateFormat
                                                                          .jm()
                                                                      .parse(textController2
                                                                          .text);
                                                                } else {
                                                                  timeOne = DateFormat
                                                                          .Hm()
                                                                      .parse(textController2
                                                                          .text);
                                                                }
                                                                time1 = DateTime.parse(DateFormat(
                                                                            'yyyy-MM-dd')
                                                                        .format(
                                                                            now) +
                                                                    ' ' +
                                                                    DateFormat(
                                                                            'HH:mm:ss')
                                                                        .format(
                                                                            timeOne));
                                                              })),
                                                  child: TextFormField(
                                                    controller: textController2,
                                                    readOnly: true,
                                                    enabled: false,
                                                    obscureText: false,
                                                    decoration: InputDecoration(
                                                      isDense: true,
                                                      hintText: 'From',
                                                      hintStyle: TextStyle(
                                                        fontFamily:
                                                            'Montserrat',
                                                        color: Colors.black,
                                                      ),
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.black,
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  4.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  4.0),
                                                        ),
                                                      ),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.black,
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  4.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  4.0),
                                                        ),
                                                      ),
                                                      contentPadding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 14, 0, 0),
                                                      prefixIcon: Icon(
                                                        Icons
                                                            .keyboard_arrow_down,
                                                      ),
                                                    ),
                                                    style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      color: Colors.black,
                                                    ),
                                                    keyboardType:
                                                        TextInputType.datetime,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(5, 2, 5, 2),
                                                child: Text("-"),
                                              ),
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () =>
                                                      showCustomTimePicker(
                                                          context: context,
                                                          onFailValidation:
                                                              (context) {
                                                            _showToastWarning(
                                                                context,
                                                                "Unavailable Time");
                                                          },
                                                          initialTime:
                                                              TimeOfDay(
                                                                  hour: 11,
                                                                  minute: 0),
                                                          selectableTimePredicate:
                                                              (time) =>
                                                                  time!.hour >=
                                                                      11 &&
                                                                  time.hour <=
                                                                      20 &&
                                                                  time.minute %
                                                                          30 ==
                                                                      0).then(
                                                          (time) =>
                                                              setState(() {
                                                                textController3
                                                                        .text =
                                                                    time!.format(
                                                                        context);
                                                                DateTime
                                                                    timeOne;
                                                                if (textController3
                                                                        .text
                                                                        .contains(
                                                                            "AM") ||
                                                                    textController3
                                                                        .text
                                                                        .contains(
                                                                            "PM")) {
                                                                  timeOne = DateFormat
                                                                          .jm()
                                                                      .parse(textController3
                                                                          .text);
                                                                } else {
                                                                  timeOne = DateFormat
                                                                          .Hm()
                                                                      .parse(textController3
                                                                          .text);
                                                                }
                                                                time2 = DateTime.parse(DateFormat(
                                                                            'yyyy-MM-dd')
                                                                        .format(
                                                                            now) +
                                                                    ' ' +
                                                                    DateFormat(
                                                                            'HH:mm:ss')
                                                                        .format(
                                                                            timeOne));
                                                              })),
                                                  child: TextFormField(
                                                    controller: textController3,
                                                    readOnly: true,
                                                    enabled: false,
                                                    obscureText: false,
                                                    decoration: InputDecoration(
                                                      isDense: true,
                                                      hintText: 'To',
                                                      hintStyle: TextStyle(
                                                        fontFamily:
                                                            'Montserrat',
                                                        color: Colors.black,
                                                      ),
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.black,
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  4.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  4.0),
                                                        ),
                                                      ),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Colors.black,
                                                          width: 1,
                                                        ),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  4.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  4.0),
                                                        ),
                                                      ),
                                                      contentPadding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 14, 0, 0),
                                                      prefixIcon: Icon(
                                                        Icons
                                                            .keyboard_arrow_down,
                                                      ),
                                                    ),
                                                    style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      color: Colors.black,
                                                    ),
                                                    keyboardType:
                                                        TextInputType.datetime,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: AlignmentDirectional(0, 0),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 20, 0, 0),
                                          child: ArgonButton(
                                            height: 40,
                                            width: 130,
                                            borderRadius: 12.0,
                                            borderSide: BorderSide(
                                                color: Colors.black, width: 1),
                                            roundLoadingShape: true,
                                            color: Colors.black,
                                            child: Text(
                                              "Update",
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
                                              if (time1 == time2 ||
                                                  time1 == now ||
                                                  time2 == now ||
                                                  time1.isAfter(time2)) {
                                                _showToastWarning(context,
                                                    "Please select time!");
                                                return;
                                              }
                                              if (!_btnOnce) {
                                                startLoading();
                                                setState(() async {
                                                  //update booking details
                                                  DocumentReference booking =
                                                      FirebaseFirestore.instance
                                                          .collection('booking')
                                                          .doc(widget.id);
                                                  await booking.update({
                                                    'start_date_time': time1,
                                                    'end_date_time': time2,
                                                  }).then((value) {
                                                    print("Booking Update");
                                                    _showToastSuccess(context,
                                                        "Booking has been updated!");
                                                    stopLoading();
                                                  }).catchError((error) {
                                                    print(
                                                        "Failed to update booking: $error");
                                                    _showToastWarning(context,
                                                        "Update failed!");
                                                    stopLoading();
                                                  });
                                                });
                                                stopLoading();
                                                return;
                                              }
                                              _showToastWarning(context,
                                                  "Please wait before trying again!");
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return new Center(
                            child:
                                Text("An error occurred, Please try again!"));
                      }
                      return new LinearProgressIndicator();
                    });
              } catch (e) {
                print(e);
                return new Center(
                    child: Text("Booking has been deleted by administrator!"));
              }
            } else if (snapshot.hasError) {
              return new Text("An error occurred, Please try again!");
            }
            return new LinearProgressIndicator();
          });
    }
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
            'BOOKING DETAIL',
            textAlign: TextAlign.start,
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
        body: _buildBookingEdit(context));
  }
}
