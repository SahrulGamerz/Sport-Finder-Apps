import 'dart:core';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:awesome_dropdown/awesome_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:time_picker_widget/time_picker_widget.dart';
import 'package:sport_finder_app/models/globalVariables.dart'
    as globalVariables;

class CreateBookingWidget extends StatefulWidget {
  CreateBookingWidget({Key? key}) : super(key: key);
  static const routeName = "/admin/booking/create";

  @override
  _CreateBookingWidgetState createState() => _CreateBookingWidgetState();
}

class _CreateBookingWidgetState extends State<CreateBookingWidget> {
  late TextEditingController textController1;
  late TextEditingController textController2;
  late TextEditingController textController3;
  late bool _isDropDownOpened;
  late bool _isDropDownOpened1;
  late bool _isBackPressedOrTouchedOutSide;
  late bool _isBackPressedOrTouchedOutSide1;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late FToast fToast;
  late DateTime time1;
  late DateTime time2;
  DateTime now = new DateTime.now();
  bool btnOnce = true;
  late String _selectedItem;
  late String _selectedItem1;

  @override
  void initState() {
    super.initState();
    textController1 = TextEditingController();
    textController2 = TextEditingController();
    textController3 = TextEditingController();
    _selectedItem = "Badminton";
    _selectedItem1 = 'Proshuttle Balakong Badminton Court';
    time1 = now;
    time2 = now;
    fToast = FToast();
    fToast.init(context);
  }

  _showToastSuccess(BuildContext context) {
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
          Text("Booking created successfully!"),
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
          'CREATE BOOKING',
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 16, 0, 0),
              child: Text(
                'Choose your Sports',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Color(0xFF8B97A2),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
              child: AwesomeDropDown(
                isPanDown: false,
                dropDownList: ["Badminton"],
                dropDownIcon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey,
                  size: 23,
                ),
                selectedItem: _selectedItem,
                onDropDownItemClick: (selectedItem) {
                  _selectedItem = selectedItem;
                },
                dropStateChanged: (isOpened) {
                  _isDropDownOpened = isOpened;
                  if (!isOpened) {
                    _isBackPressedOrTouchedOutSide = false;
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 16, 0, 0),
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
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
              child: AwesomeDropDown(
                isPanDown: false,
                dropDownList: ['Proshuttle Balakong Badminton Court'],
                dropDownIcon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey,
                  size: 23,
                ),
                selectedItem: _selectedItem1,
                onDropDownItemClick: (selectedItem) {
                  _selectedItem1 = selectedItem;
                },
                dropStateChanged: (isOpened) {
                  _isDropDownOpened1 = isOpened;
                  if (!isOpened) {
                    _isBackPressedOrTouchedOutSide1 = false;
                  }
                },
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 16, 0, 0),
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
                )
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 16, 200, 0),
                    child: DateTimePicker(
                      initialValue: now.toString(),
                      type: DateTimePickerType.date,
                      dateMask: 'dd MMM yyyy',
                      firstDate: DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day),
                      initialDate: now,
                      lastDate: DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day + 20),
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
                        setState(() {
                          now = DateTime.parse(val);
                        });
                      },
                      validator: (val) {
                        print(val);
                        return null;
                      },
                      onSaved: (val) {
                        setState(() {
                          now = DateTime.parse(val!);
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(20, 16, 0, 0),
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
                    )
                  ],
                )
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 16, 13, 0),
                    child: InkWell(
                      onTap: () => showCustomTimePicker(
                          context: context,
                          onFailValidation: (context) {
                            _showToastWarning(context, "Unavailable Time");
                          },
                          initialTime: TimeOfDay(hour: 10, minute: 0),
                          selectableTimePredicate: (time) =>
                              time!.hour >= 10 &&
                              time.hour <= 19 &&
                              time.minute % 30 ==
                                  0).then((time) => setState(() {
                            textController2.text = time!.format(context);
                            DateTime timeOne;
                            if (textController2.text.contains("AM") ||
                                textController2.text.contains("PM")) {
                              timeOne =
                                  DateFormat.jm().parse(textController2.text);
                            } else {
                              timeOne =
                                  DateFormat.Hm().parse(textController2.text);
                            }
                            time1 = DateTime.parse(
                                DateFormat('yyyy-MM-dd').format(now) +
                                    ' ' +
                                    DateFormat('HH:mm:ss').format(timeOne));
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
                    padding: EdgeInsetsDirectional.fromSTEB(13, 16, 13, 0),
                    child: InkWell(
                      onTap: () => showCustomTimePicker(
                          context: context,
                          onFailValidation: (context) {
                            _showToastWarning(context, "Unavailable Time");
                          },
                          initialTime: TimeOfDay(hour: 11, minute: 0),
                          selectableTimePredicate: (time) =>
                              time!.hour >= 11 &&
                              time.hour <= 20 &&
                              time.minute % 30 ==
                                  0).then((time) => setState(() {
                            textController3.text = time!.format(context);
                            DateTime timeOne;D
                            if (textController3.text.contains("AM") ||
                                textController3.text.contains("PM")) {
                              timeOne =
                                  DateFormat.jm().parse(textController3.text);
                            } else {
                              timeOne =
                                  DateFormat.Hm().parse(textController3.text);
                            }
                            time2 = DateTime.parse(
                                DateFormat('yyyy-MM-dd').format(now) +
                                    ' ' +
                                    DateFormat('HH:mm:ss').format(timeOne));
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
              padding: EdgeInsetsDirectional.fromSTEB(0, 90, 0, 0),
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
                      "Create",
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
                      if (time1 == time2 ||
                          time1 == now ||
                          time2 == now ||
                          time1.isAfter(time2)) {
                        _showToastWarning(context, "Please select time!");
                        return;
                      }
                      if (btnOnce) {
                        btnOnce = !btnOnce;
                        QuerySnapshot court = await FirebaseFirestore.instance
                            .collection('locations')
                            .where('court_name', isEqualTo: _selectedItem1)
                            .get();
                        int pph = 0;
                        String cid = "";
                        print(court.docs);
                        court.docs.forEach((doc) {
                          Map<String, dynamic> court =
                              doc.data() as Map<String, dynamic>;
                          pph = int.parse(court['price_per_hour']);
                          cid = doc.id;
                          print(cid);
                          print(pph);
                        });
                        final hours = time2.difference(time1).inHours;
                        final tp = hours * pph;
                        startLoading();

                        // Create Booking
                        CollectionReference booking =
                            FirebaseFirestore.instance.collection('booking');
                        final bookID = await booking.add({
                          "court_id": cid,
                          "date": DateTime.now(),
                          "end_date_time": time2,
                          "gameType": _selectedItem,
                          "game_id": "",
                          "payment_id": "Cash",
                          "start_date_time": time1,
                          "status": "booked",
                          "total_price": tp,
                          "uid": globalVariables.uid,
                        });
                        if (bookID.id != "") {
                          CollectionReference sales =
                              FirebaseFirestore.instance.collection('sales');
                          await sales.doc(cid).update({
                            'sales.${time1.year}.${time1.month}':
                                FieldValue.arrayUnion([
                              {
                                'date': DateTime.now(),
                                'total_price': tp.toString(),
                              },
                            ]),
                          }).then((value) {
                            print("Update Success");
                          }).catchError((error) async {
                            print("Failed to update sales: $error");
                            await sales
                                .doc(cid)
                                .set({
                                  'sales': {
                                    '${time1.year}': {
                                      '${time1.month}': [
                                        {
                                          'date': DateTime.now(),
                                          'total_price': tp.toString(),
                                        },
                                      ]
                                    }
                                  },
                                })
                                .then((value) => print("Update Success"))
                                .catchError((error) =>
                                    print("Failed to update sales: $error"));
                          });
                          _showToastSuccess(context);
                          stopLoading();
                          Navigator.pop(context);
                        } else {
                          _showToastWarning(
                              context, "Failed to create booking!");
                          stopLoading();
                        }
                        return;
                      }
                      _showToastWarning(
                          context, "Please wait before trying again!");
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
