import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_picker_widget/time_picker_widget.dart';

class ViewCourtWidget extends StatefulWidget {
  //ViewCourtWidget({required Key key}) : super(key: key);

  @override
  _ViewCourtWidgetState createState() => _ViewCourtWidgetState();
  final String cid;

  ViewCourtWidget({required this.cid});
}

class _ViewCourtWidgetState extends State<ViewCourtWidget> {
  late TextEditingController textController1;
  late TextEditingController textController2;
  late TextEditingController textController3;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime now = new DateTime.now();
  String selectedTime1 = '';
  String selectedTime2 = '';



  @override
  void initState() {
    super.initState();
    textController1 = TextEditingController();
    textController2 = TextEditingController();
    textController3 = TextEditingController();
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
      body: SingleChildScrollView(
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
                          Image.asset(
                            'assets/images/59958_164402090240694_5885574_n.jpg',
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            height: MediaQuery
                                .of(context)
                                .size
                                .height * 0.2,
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
                      'RM 15 per hour',
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
                    padding: EdgeInsetsDirectional.fromSTEB(10, 0, 200, 0),
                    child: DateTimePicker(
                      initialValue:now.toString(),
                      type: DateTimePickerType.date,
                      dateMask: 'd MMM, yyyy',
                      firstDate: DateTime(now.year),
                      lastDate: DateTime(now.year),
                      dateLabelText: 'Date',
                      onChanged: (val) => print(val),
                      validator: (val) {
                        print(val);
                        return null;
                      },
                      onSaved: (val) => print(val),
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
                      padding: EdgeInsetsDirectional.fromSTEB(10, 0, 13, 0),
                      child:InkWell(
                        onTap: () =>
                        // DEMO --------------
                        showCustomTimePicker(
                            context: context,
                            // It is a must if you provide selectableTimePredicate
                            onFailValidation: (context) {},
                            initialTime: TimeOfDay(
                                hour: 10,
                                minute: 0),
                            selectableTimePredicate: (time) => time!.hour >= 10 && time!.hour <= 20 && time!.minute % 30 == 0).then(
                                (time) =>
                                setState(() => selectedTime1 = time!.format(context))),
                        // --------------

                        child: Text(
                          selectedTime1 ?? 'Select Time',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.black,
                          ),
                        ),
                      ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 13, 0),
                    child: InkWell(
                      onTap: () =>
                      // DEMO --------------
                      showCustomTimePicker(
                          context: context,
                          // It is a must if you provide selectableTimePredicate
                          onFailValidation: (context) {},
                          initialTime: TimeOfDay(
                              hour: 10,
                              minute: 0),
                          selectableTimePredicate: (time) => time!.hour >= 10 && time!.hour <= 20 && time!.minute % 30 == 0).then(
                              (time) =>
                              setState(() => selectedTime1 = time!.format(context))),
                      // --------------

                      child: Text(
                        selectedTime1 ?? 'Select Time',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.black,
                        ),
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
                        padding: EdgeInsetsDirectional.fromSTEB(6, 0, 0, 0),
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
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 9, 10),
                      child: Text(
                        '  1        2        3       4      5       6\n\n  7       8        9      10      11      12\n\n 13      14      15      16      17     18\n\n 19     20      21      22    23    24\n\n25     26     27     28     29   30',
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
                      onTap: (startLoading, stopLoading, btnState) async {},
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
