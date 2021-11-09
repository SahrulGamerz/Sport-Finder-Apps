import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sport_finder_app/models/globalVariables.dart'
    as globalVariables;
import 'package:sport_finder_app/widgets/PaypalPayment.dart';
import 'package:time_picker_widget/time_picker_widget.dart';

class ViewCourtWidget extends StatefulWidget {
  //ViewCourtWidget({required Key key}) : super(key: key);

  @override
  _ViewCourtWidgetState createState() => _ViewCourtWidgetState();
  final String cid;
  final int pph;
  final int cc;
  final String img;
  final String cn;
  final String gameType;

  ViewCourtWidget(
      {required this.cid,
      required this.pph,
      required this.cc,
      required this.img,
      required this.cn,
      required this.gameType});
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
  late String paymentId;

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

  Future<void> _showChoiceDialog(BuildContext context, String totalPrice) {
    TextEditingController firstName = TextEditingController();
    TextEditingController lastName = TextEditingController();
    TextEditingController addressCity = TextEditingController();
    TextEditingController addressStreet = TextEditingController();
    TextEditingController addressZipCode = TextEditingController();
    TextEditingController addressCountry = TextEditingController();
    TextEditingController addressState = TextEditingController();
    TextEditingController addressPhoneNumber = TextEditingController();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Payment Information",
              style: TextStyle(color: Colors.blue),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  // First Name
                  TextFormField(
                    controller: firstName,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'First Name',
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
                    ),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.name,
                  ),
                  // Last Name
                  TextFormField(
                    controller: lastName,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Last Name',
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
                    ),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.name,
                  ),
                  // Phone Number
                  TextFormField(
                    controller: addressPhoneNumber,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Phone Number',
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
                    ),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.phone,
                  ),
                  // Street
                  TextFormField(
                    controller: addressStreet,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Street',
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
                    ),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.streetAddress,
                  ),
                  // State
                  TextFormField(
                    controller: addressState,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'State',
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
                    ),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.streetAddress,
                  ),
                  // City
                  TextFormField(
                    controller: addressCity,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'City',
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
                    ),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.streetAddress,
                  ),
                  // Zipcode
                  TextFormField(
                    controller: addressZipCode,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Zipcode',
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
                    ),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.number,
                  ),
                  //Country
                  TextFormField(
                    controller: addressCountry,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Country',
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
                    ),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.streetAddress,
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                    child: ArgonButton(
                      height: 40,
                      width: 130,
                      borderRadius: 12.0,
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
                      onTap: (startLoading, stopLoading, btnState) async {
                        paymentId = '';
                        if (firstName.text.trim() == '')
                          return _showToastWarning(
                              context, "Please enter your first name!");
                        if (lastName.text.trim() == '')
                          return _showToastWarning(
                              context, "Please enter your last name!");
                        if (addressPhoneNumber.text.trim() == '')
                          return _showToastWarning(
                              context, "Please enter your phone number!");
                        if (addressCity.text.trim() == '')
                          return _showToastWarning(
                              context, "Please enter your city!");
                        if (addressStreet.text.trim() == '')
                          return _showToastWarning(
                              context, "Please enter your street!");
                        if (addressState.text.trim() == '')
                          return _showToastWarning(
                              context, "Please enter your state!");
                        if (addressZipCode.text.trim() == '')
                          return _showToastWarning(
                              context, "Please enter your zipcode!");
                        if (addressCountry.text.trim() == '')
                          return _showToastWarning(
                              context, "Please enter your country!");
                        startLoading();
                        FirebaseFirestore firestore =
                            FirebaseFirestore.instance;
                        CollectionReference users =
                            firestore.collection('users');
                        await users
                            .doc(globalVariables.uid)
                            .update({
                              'payment_information': {
                                'firstName': firstName.text.toString(),
                                'lastName': lastName.text.toString(),
                                'addressPhoneNumber':
                                    addressPhoneNumber.text.toString(),
                                'addressCity': addressCity.text.toString(),
                                'addressStreet': addressStreet.text.toString(),
                                'addressState': addressState.text.toString(),
                                'addressZipCode':
                                    addressZipCode.text.toString(),
                                'addressCountry':
                                    addressCountry.text.toString(),
                              },
                            })
                            .then((value) => print("Update Success"))
                            .catchError((error) =>
                                print("Failed to update user: $error"));
                        globalVariables.firstName = firstName.text.toString();
                        globalVariables.lastName = lastName.text.toString();
                        globalVariables.addressPhoneNumber =
                            addressPhoneNumber.text.toString();
                        globalVariables.addressCity =
                            addressCity.text.toString();
                        globalVariables.addressStreet =
                            addressStreet.text.toString();
                        globalVariables.addressState =
                            addressState.text.toString();
                        globalVariables.addressZipCode =
                            addressZipCode.text.toString();
                        globalVariables.addressCountry =
                            addressCountry.text.toString();
                        _showToastSuccess(context,
                            "Successfully update payment information!\nRedirecting to payment gateway!");
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => PaypalPayment(
                                  onFinish: (number) async {
                                    setState(() {
                                      paymentId = number;
                                    });
                                    FirebaseFirestore firestore =
                                        FirebaseFirestore.instance;
                                    CollectionReference booking =
                                        firestore.collection('booking');
                                    await booking
                                        .doc()
                                        .set({
                                          'court_id': widget.cid,
                                          'game_id': '',
                                          'gameType': widget.gameType,
                                          'end_date_time': time2,
                                          'payment_id': number,
                                          'date': DateTime.now(),
                                          'total_price': totalPrice,
                                          'start_date_time': time1,
                                          'status': 'booked',
                                          'uid': globalVariables.uid,
                                        })
                                        .then(
                                            (value) => print("Update Success"))
                                        .catchError((error) => print(
                                            "Failed to update booking: $error"));
                                    CollectionReference history =
                                        firestore.collection('history');
                                    await history
                                        .doc(globalVariables.uid)
                                        .update({
                                          'payment_history':
                                              FieldValue.arrayUnion([
                                            {
                                              'code': 'success',
                                              'court_name': widget.cn,
                                              'game_id': '',
                                              'gameType': widget.gameType,
                                              'date': DateTime.now(),
                                              'payment_id': number,
                                              'total_price': totalPrice,
                                            },
                                          ]),
                                        })
                                        .then(
                                            (value) => print("Update Success"))
                                        .catchError((error) async {
                                          print(
                                              "Failed to update history: $error");
                                          await history
                                              .doc(globalVariables.uid)
                                              .set({
                                                'payment_history': [
                                                  {
                                                    'code': 'success',
                                                    'court_name': widget.cn,
                                                    'game_id': '',
                                                    'gameType': widget.gameType,
                                                    'date': DateTime.now(),
                                                    'payment_id': number,
                                                    'total_price': totalPrice,
                                                  },
                                                ],
                                              })
                                              .then((value) =>
                                                  print("Update Success"))
                                              .catchError((error) => print(
                                                  "Failed to update history: $error"));
                                        });
                                    CollectionReference sales =
                                        firestore.collection('sales');
                                    await sales
                                        .doc(widget.cid)
                                        .update({
                                          'sales.${time1.year}.${time1.month}': FieldValue.arrayUnion([
                                                {
                                                  'date': DateTime.now(),
                                                  'total_price': totalPrice,
                                                },
                                              ]),
                                        })
                                        .then(
                                            (value) => print("Update Success"))
                                        .catchError((error) async {
                                          print(
                                              "Failed to update sales: $error");
                                          await sales
                                              .doc(widget.cid)
                                              .set({
                                                'sales': {
                                                  '${time1.year}': {
                                                    '${time1.month}': [
                                                      {
                                                        'date': DateTime.now(),
                                                        'total_price':
                                                            totalPrice,
                                                      },
                                                    ]
                                                  }
                                                },
                                              })
                                              .then((value) =>
                                                  print("Update Success"))
                                              .catchError((error) => print(
                                                  "Failed to update sales: $error"));
                                        });
                                    print('Order ID: ' + number);
                                  },
                                  itemName: '${widget.cn} Booking',
                                  itemPrice: totalPrice,
                                )));
                        await new Future.delayed(
                            const Duration(milliseconds: 2000), () {
                          if (paymentId != '')
                            _showToastSuccess(context,
                                'Payment has been received!\nPayment ID: $paymentId');
                        });
                        stopLoading();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future _getCourtCount() async {
    count = 0;
    await FirebaseFirestore.instance
        .collection('booking')
        .where("court_id", isEqualTo: widget.cid)
        .where("status", isEqualTo: "booked")
        .get()
        .then((QuerySnapshot querySnapshot) {
      print(querySnapshot.docs.length);
      for (var i = 0; i < querySnapshot.docs.length; i++) {
        Map<String, dynamic> data =
            querySnapshot.docs[i].data() as Map<String, dynamic>;

        final int queryStart = time1.millisecondsSinceEpoch;
        final int queryEnd = time2.millisecondsSinceEpoch;
        final int startTime = data['start_date_time'].seconds * 1000;
        final int endTime = data['end_date_time'].seconds * 1000;

        if (queryStart >= startTime &&
            queryStart < endTime &&
            queryEnd >= endTime) {
          count++;
        } else if (queryEnd <= endTime &&
            queryStart < startTime &&
            queryEnd > startTime) {
          count++;
        } else if (queryStart < startTime && queryEnd > endTime) {
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
                              setState(() {
                                now = DateTime.parse(val);
                                timestamp =
                                    DateTime.now().millisecondsSinceEpoch;
                              });
                            },
                            validator: (val) {
                              print(val);
                              return null;
                            },
                            onSaved: (val) {
                              setState(() {
                                now = DateTime.parse(val!);
                                timestamp =
                                    DateTime.now().millisecondsSinceEpoch;
                              });
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
                                        time.hour <= 19 &&
                                        time.minute % 30 == 0)
                                .then((time) => setState(() {
                                      textController2.text =
                                          time!.format(context);
                                      DateTime timeOne;
                                      if (textController2.text.contains("AM") ||
                                          textController2.text.contains("PM")) {
                                        timeOne = DateFormat.jm()
                                            .parse(textController2.text);
                                      } else {
                                        timeOne = DateFormat.Hm()
                                            .parse(textController2.text);
                                      }
                                      timestamp =
                                          DateTime.now().millisecondsSinceEpoch;
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
                                    initialTime: TimeOfDay(hour: 11, minute: 0),
                                    selectableTimePredicate: (time) =>
                                        time!.hour >= 11 &&
                                        time.hour <= 20 &&
                                        time.minute % 30 == 0)
                                .then((time) => setState(() {
                                      textController3.text =
                                          time!.format(context);
                                      timestamp =
                                          DateTime.now().millisecondsSinceEpoch;
                                      DateTime timeOne;
                                      if (textController3.text.contains("AM") ||
                                          textController3.text.contains("PM")) {
                                        timeOne = DateFormat.jm()
                                            .parse(textController3.text);
                                      } else {
                                        timeOne = DateFormat.Hm()
                                            .parse(textController3.text);
                                      }
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
                      Flexible(
                        child: Padding(
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
                            onTap: (startLoading, stopLoading, btnState) async {
                              paymentId = '';
                              if (time1 == time2 ||
                                  time1 == now ||
                                  time2 == now ||
                                  time1.isAfter(time2)) {
                                _showToastWarning(
                                    context, "Please select time!");
                                return;
                              }
                              final hours = time2.difference(time1).inHours;
                              final tp = hours * widget.pph;
                              startLoading();
                              if (globalVariables.checkPaymentInfo()) {
                                _showToastSuccess(context,
                                    'Redirecting to the payment gateway!');
                                await Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            PaypalPayment(
                                              onFinish: (number) async {
                                                setState(() {
                                                  paymentId = number;
                                                });
                                                FirebaseFirestore firestore =
                                                    FirebaseFirestore.instance;
                                                CollectionReference booking =
                                                    firestore
                                                        .collection('booking');
                                                await booking
                                                    .doc()
                                                    .set({
                                                      'court_id': widget.cid,
                                                      'end_date_time': time2,
                                                      'game_id': '',
                                                      'gameType': widget.gameType,
                                                      'payment_id': number,
                                                      'date': DateTime.now(),
                                                      'total_price':
                                                          tp.toString(),
                                                      'start_date_time': time1,
                                                      'status': 'booked',
                                                      'uid':
                                                          globalVariables.uid,
                                                    })
                                                    .then((value) =>
                                                        print("Update Success"))
                                                    .catchError((error) => print(
                                                        "Failed to update booking: $error"));
                                                CollectionReference history =
                                                    firestore
                                                        .collection('history');
                                                await history
                                                    .doc(globalVariables.uid)
                                                    .update({
                                                      'payment_history':
                                                          FieldValue
                                                              .arrayUnion([
                                                        {
                                                          'code': 'success',
                                                          'court_name':
                                                              widget.cn,
                                                          'game_id': '',
                                                          'gameType': widget.gameType,
                                                          'date':
                                                              DateTime.now(),
                                                          'payment_id': number,
                                                          'total_price':
                                                              tp.toString(),
                                                        },
                                                      ]),
                                                    })
                                                    .then((value) =>
                                                        print("Update Success"))
                                                    .catchError((error) async {
                                                      print(
                                                          "Failed to update history: $error");
                                                      await history
                                                          .doc(globalVariables
                                                              .uid)
                                                          .set({
                                                            'payment_history': [
                                                              {
                                                                'code':
                                                                    'success',
                                                                'court_name':
                                                                    widget.cn,
                                                                'game_id': '',
                                                                'gameType': widget.gameType,
                                                                'date': DateTime
                                                                    .now(),
                                                                'payment_id':
                                                                    number,
                                                                'total_price': tp
                                                                    .toString(),
                                                              },
                                                            ],
                                                          })
                                                          .then((value) => print(
                                                              "Update Success"))
                                                          .catchError((error) =>
                                                              print(
                                                                  "Failed to update history: $error"));
                                                    });
                                                CollectionReference sales =
                                                    firestore
                                                        .collection('sales');
                                                await sales
                                                    .doc(widget.cid)
                                                    .update({
                                                      'sales.${time1.year}.${time1.month}':
                                                              FieldValue
                                                                  .arrayUnion([
                                                            {
                                                              'date': DateTime.now(),
                                                              'total_price':
                                                                  tp.toString(),
                                                            },
                                                          ]),
                                                    })
                                                    .then((value){
                                                        print("Update Success");
                                                    })
                                                    .catchError((error) async {
                                                      print(
                                                          "Failed to update sales: $error");
                                                      await sales
                                                          .doc(widget.cid)
                                                          .set({
                                                            'sales': {
                                                              '${time1.year}': {
                                                                '${time1.month}':
                                                                    [
                                                                  {
                                                                    'date': DateTime.now(),
                                                                    'total_price':
                                                                        tp.toString(),
                                                                  },
                                                                ]
                                                              }
                                                            },
                                                          })
                                                          .then((value) => print(
                                                              "Update Success"))
                                                          .catchError((error) =>
                                                              print(
                                                                  "Failed to update sales: $error"));
                                                    });
                                                print('Order ID: ' + number);
                                                stopLoading();
                                              },
                                              itemName: '${widget.cn} Booking',
                                              itemPrice: tp.toString(),
                                            )));
                                await new Future.delayed(
                                    const Duration(milliseconds: 2000), () {
                                  if (paymentId != '')
                                    _showToastSuccess(context,
                                        'Payment has been received!\nPayment ID: $paymentId');
                                });
                                stopLoading();
                              } else {
                                _showToastWarning(context,
                                    'Please update your payment information!');
                                await _showChoiceDialog(context, tp.toString());
                                stopLoading();
                              }
                            },
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
