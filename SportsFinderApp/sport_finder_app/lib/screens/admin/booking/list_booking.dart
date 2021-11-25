import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sport_finder_app/models/globalVariables.dart'
    as globalVariables;
import 'package:intl/intl.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:sport_finder_app/screens/admin/booking/view_booking.dart';

import 'edit_booking.dart';

class ViewBookingWidget extends StatefulWidget {
  ViewBookingWidget({Key? key}) : super(key: key);
  static const String routeName = '/admin/booking';

  @override
  _ViewBookingWidgetState createState() => _ViewBookingWidgetState();
}

class _ViewBookingWidgetState extends State<ViewBookingWidget> {
  late TextEditingController searchFieldController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime _startDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);
  DateTime _lastDate = DateTime(2099, 12, 31, 23, 59, 59);
  late int _startDateSecond;
  late int _lastDateSecond;
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    searchFieldController = TextEditingController();
    _startDateSecond = _startDate.millisecondsSinceEpoch ~/ 1000;
    _lastDateSecond = _lastDate.millisecondsSinceEpoch ~/ 1000;
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

  Future<void> _showChoiceDialog(BuildContext context, data, bookID) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Choose option",
              style: TextStyle(color: Colors.blue),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BookingDetailsWidget(dataMap: data),
                          ));
                    },
                    title: Text("View"),
                    leading: Icon(
                      Icons.visibility,
                      color: Colors.blue,
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BookingEditWidget(dataMap: data, id: bookID),
                          ));
                    },
                    title: Text("Edit"),
                    leading: Icon(
                      Icons.edit,
                      color: Colors.blue,
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () async {
                      CollectionReference booking =
                          FirebaseFirestore.instance.collection('booking');
                      booking.doc(bookID).delete().then((value) {
                        print("Booking Deleted");
                      }).catchError((error) {
                        print("Failed to delete booking: $error");
                        _showToastError(
                            context, "Failed to delete booking in Database");
                      });
                      if (data['game_id'] != "") {
                        // Send message
                        CollectionReference msgSRef = FirebaseFirestore.instance
                            .collection('messages')
                            .doc(data['game_id'])
                            .collection("messages");
                        await msgSRef
                            .doc()
                            .set({
                              'uid': globalVariables.uid,
                              "timestamp": DateTime.now(),
                              "msg": "Administrator has deleted the booking!",
                            })
                            .then((value) => {print("Message sent")})
                            .catchError((error) {
                              print("Failed to send msg: $error");
                            });

                        //update message
                        CollectionReference msgIRef =
                            FirebaseFirestore.instance.collection('messages');
                        await msgIRef
                            .doc(data['game_id'])
                            .update({
                              "last_updated": DateTime.now(),
                              "last_message":
                                  "Administrator has deleted the booking!",
                            })
                            .then((value) => {print("Message Update")})
                            .catchError((error) {
                              print("Failed to update msg: $error");
                            });

                        //update game details
                        DocumentReference games = FirebaseFirestore.instance
                            .collection('games')
                            .doc(data['game_id']);
                        await games
                            .update({
                              'booked': false,
                            })
                            .then((value) => {print("Games Update")})
                            .catchError((error) {
                              print("Failed to update msg: $error");
                            });
                      }
                      _showToastSuccess(
                          context, "Booking deleted successfully");
                      Navigator.pop(context);
                    },
                    title: Text("Delete"),
                    leading: Icon(
                      Icons.delete,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> _showChoiceDialogDeletedUser(
      BuildContext context, data, bookID) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Choose option",
              style: TextStyle(color: Colors.blue),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  ListTile(
                    onTap: () async {
                      CollectionReference booking =
                          FirebaseFirestore.instance.collection('booking');
                      booking.doc(bookID).delete().then((value) {
                        print("Booking Deleted");
                      }).catchError((error) {
                        print("Failed to delete booking: $error");
                        _showToastError(
                            context, "Failed to delete booking in Database");
                      });
                      if (data['game_id'] != "") {
                        // Send message
                        CollectionReference msgSRef = FirebaseFirestore.instance
                            .collection('messages')
                            .doc(data['game_id'])
                            .collection("messages");
                        await msgSRef
                            .doc()
                            .set({
                              'uid': globalVariables.uid,
                              "timestamp": DateTime.now(),
                              "msg": "Administrator has deleted the booking!",
                            })
                            .then((value) => {print("Message sent")})
                            .catchError((error) {
                              print("Failed to send msg: $error");
                            });

                        //update message
                        CollectionReference msgIRef =
                            FirebaseFirestore.instance.collection('messages');
                        await msgIRef
                            .doc(data['game_id'])
                            .update({
                              "last_updated": DateTime.now(),
                              "last_message":
                                  "Administrator has deleted the booking!",
                            })
                            .then((value) => {print("Message Update")})
                            .catchError((error) {
                              print("Failed to update msg: $error");
                            });

                        //update game details
                        DocumentReference games = FirebaseFirestore.instance
                            .collection('games')
                            .doc(data['game_id']);
                        await games
                            .update({
                              'booked': false,
                            })
                            .then((value) => {print("Games Update")})
                            .catchError((error) {
                              print("Failed to update msg: $error");
                            });
                      }
                      _showToastSuccess(
                          context, "Booking deleted successfully");
                      Navigator.pop(context);
                    },
                    title: Text("Delete"),
                    leading: Icon(
                      Icons.delete,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildBookingList(
      {required BuildContext context,
      required Map<String, dynamic> data,
      required String id}) {
    if (data['game_id'] != "") {
      return new FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(data["uid"])
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              DocumentSnapshot documentSnapshot =
                  snapshot.data as DocumentSnapshot;
              try {
                Map<String, dynamic> user =
                    documentSnapshot.data() as Map<String, dynamic>;
                DateTime date = data['start_date_time'].toDate();
                DateTime date2 = data['end_date_time'].toDate();
                return new FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('games')
                        .doc(data["game_id"])
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        DocumentSnapshot documentSnapshot =
                            snapshot.data as DocumentSnapshot;
                        Map<String, dynamic> game =
                            documentSnapshot.data() as Map<String, dynamic>;
                        Map<String, dynamic> gameDetails =
                            game['gameDetails'] as Map<String, dynamic>;
                        return InkWell(
                            onTap: () async {
                              await _showChoiceDialog(context, data, id);
                            },
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(8, 4, 8, 4),
                              child: Container(
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Card(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  color: Colors.white,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16, 0, 0, 0),
                                        child: Stack(
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  -0.1, -0.5),
                                              child: Text(
                                                '${user['username']}',
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Color(0xFF15212B),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  2.64, 0.55),
                                              child: Text(
                                                '${gameDetails['slots']} Players, ${DateFormat.jm().format(date)} - ${DateFormat.jm().format(date2)}',
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
                                      Expanded(
                                        flex: 2,
                                        child: Align(
                                          alignment: AlignmentDirectional(1, 0),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 0, 38, 0),
                                            child: Container(
                                              width: 40,
                                              height: 40,
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: Image.network(
                                                '${user['profile_picture']}',
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ));
                      } else if (snapshot.hasError) {
                        return new Text("An error occurred, Please try again!");
                      }
                      return new LinearProgressIndicator();
                    });
              } catch (e) {
                DateTime date = data['start_date_time'].toDate();
                DateTime date2 = data['end_date_time'].toDate();
                return new FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('games')
                        .doc(data["game_id"])
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        DocumentSnapshot documentSnapshot =
                            snapshot.data as DocumentSnapshot;
                        Map<String, dynamic> game =
                            documentSnapshot.data() as Map<String, dynamic>;
                        Map<String, dynamic> gameDetails =
                            game['gameDetails'] as Map<String, dynamic>;
                        return InkWell(
                            onTap: () async {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "Error: Booking creator has been deleted!")));
                              _showChoiceDialogDeletedUser(context, data, id);
                            },
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(8, 4, 8, 4),
                              child: Container(
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Card(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  color: Colors.white,
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16, 0, 0, 0),
                                        child: Stack(
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  -0.1, -0.5),
                                              child: Text(
                                                'Deleted User',
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: Color(0xFF15212B),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  2.64, 0.55),
                                              child: Text(
                                                '${gameDetails['slots']} Players, ${DateFormat.jm().format(date)} - ${DateFormat.jm().format(date2)}',
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
                                      Expanded(
                                        flex: 2,
                                        child: Align(
                                          alignment: AlignmentDirectional(1, 0),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 0, 38, 0),
                                            child: Container(
                                              width: 40,
                                              height: 40,
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: Image.network(
                                                'https://www.globalsign.com/application/files/9516/0389/3750/What_Is_an_SSL_Common_Name_Mismatch_Error_-_Blog_Image.jpg',
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ));
                      } else if (snapshot.hasError) {
                        return new Text("An error occurred, Please try again!");
                      }
                      return new LinearProgressIndicator();
                    });
              }
            } else if (snapshot.hasError) {
              return new Text("An error occurred, Please try again!");
            }
            return new LinearProgressIndicator();
          });
    } else {
      return new FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(data["uid"])
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              DocumentSnapshot documentSnapshot =
                  snapshot.data as DocumentSnapshot;
              try {
                Map<String, dynamic> user =
                    documentSnapshot.data() as Map<String, dynamic>;
                DateTime date = data['start_date_time'].toDate();
                DateTime date2 = data['end_date_time'].toDate();
                return InkWell(
                    onTap: () async {
                      await _showChoiceDialog(context, data, id);
                    },
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8, 4, 8, 4),
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment:
                                          AlignmentDirectional(-0.1, -0.5),
                                      child: Text(
                                        '${user['username']}',
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Color(0xFF15212B),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional(2.64, 0.55),
                                      child: Text(
                                        '1 Players, ${DateFormat.jm().format(date)} - ${DateFormat.jm().format(date2)}',
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
                              Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: AlignmentDirectional(1, 0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 38, 0),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.network(
                                        '${user['profile_picture']}',
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ));
              } catch (e) {
                DateTime date = data['start_date_time'].toDate();
                DateTime date2 = data['end_date_time'].toDate();
                return InkWell(
                    onTap: () async {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Error: Booking creator has been deleted!")));
                      _showChoiceDialogDeletedUser(context, data, id);
                    },
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8, 4, 8, 4),
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment:
                                          AlignmentDirectional(-0.1, -0.5),
                                      child: Text(
                                        'Deleted User',
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Color(0xFF15212B),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment:
                                          AlignmentDirectional(2.64, 0.55),
                                      child: Text(
                                        '1 Players, ${DateFormat.jm().format(date)} - ${DateFormat.jm().format(date2)}',
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
                              Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: AlignmentDirectional(1, 0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 38, 0),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.network(
                                        'https://www.globalsign.com/application/files/9516/0389/3750/What_Is_an_SSL_Common_Name_Mismatch_Error_-_Blog_Image.jpg',
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ));
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
        title: Text(
          'BOOKING LIST',
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(20, 16, 13, 16),
                      child: DateTimePicker(
                        initialValue: _startDate.toString(),
                        type: DateTimePickerType.date,
                        dateMask: 'dd MMM yyyy',
                        firstDate: DateTime(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day, 0, 0, 0),
                        initialDate: _startDate,
                        lastDate: DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day + 20,
                            0,
                            0,
                            0),
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
                            _startDate = DateTime.parse(val);
                          });
                        },
                        validator: (val) {
                          print(val);
                          return null;
                        },
                        onSaved: (val) {
                          setState(() {
                            _startDate = DateTime.parse(val!);
                          });
                        },
                      ),
                    ),
                  ),
                  Text('-'),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(13, 16, 13, 16),
                      child: DateTimePicker(
                        initialValue: _lastDate.toString(),
                        type: DateTimePickerType.date,
                        dateMask: 'dd MMM yyyy',
                        firstDate: DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                            23,
                            59,
                            59),
                        initialDate: _lastDate,
                        lastDate: DateTime(2099, 12, 31, 23, 59, 59),
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'To Date',
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
                            _lastDate = DateTime.parse(val);
                          });
                        },
                        validator: (val) {
                          print(val);
                          return null;
                        },
                        onSaved: (val) {
                          setState(() {
                            _lastDate = DateTime.parse(val!);
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
              Flexible(
                child: PaginateFirestore(
                  //item builder type is compulsory.
                  itemBuilder: (index, context, documentSnapshot) {
                    final data =
                        documentSnapshot.data() as Map<String, dynamic>;
                    if (data != null) {
                      return _buildBookingList(
                        context: context,
                        data: data,
                        id: documentSnapshot.id,
                      );
                    } else {
                      print(data);
                      return Text(
                        "You didn't have any booking",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Color(0xFF8B97A2),
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }
                  },
                  // orderBy is compulsory to enable pagination
                  query: FirebaseFirestore.instance
                      .collection("booking")
                      .where("start_date_time",
                          isGreaterThanOrEqualTo:
                              Timestamp(_startDateSecond, 0))
                      .where("start_date_time",
                          isLessThanOrEqualTo: Timestamp(_lastDateSecond, 0))
                      .orderBy("start_date_time", descending: true),
                  //Change types accordingly
                  itemBuilderType: PaginateBuilderType.listView,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  emptyDisplay: Text(
                    "You didn't have any booking",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Color(0xFF8B97A2),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // to fetch real-time data
                  isLive: true,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
