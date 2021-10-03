import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:awesome_dropdown/awesome_dropdown.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:time_picker_widget/time_picker_widget.dart';
import '../../models/globalVariables.dart' as userDataClass;

class CreateWidget extends StatefulWidget {
  const CreateWidget({Key? key}) : super(key: key);

  @override
  _CreateWidgetState createState() => _CreateWidgetState();
}

class _CreateWidgetState extends State<CreateWidget> {
  late String dropDownValue1;
  late String dropDownValue2;
  late String dropDownValue3;
  late String _selectedItem;
  late String _selectedItem1;
  late String _selectedItem2;
  late TextEditingController textController1;
  late TextEditingController textController2;
  late TextEditingController textController3;
  late bool _isDropDownOpened;
  late bool _isDropDownOpened1;
  late bool _isDropDownOpened2;
  late bool _isBackPressedOrTouchedOutSide;
  late bool _isBackPressedOrTouchedOutSide1;
  late bool _isBackPressedOrTouchedOutSide2;
  late FToast fToast;
  late DateTime time1;
  late DateTime time2;
  DateTime now = new DateTime.now();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    textController1 = TextEditingController();
    textController2 = TextEditingController();
    textController3 = TextEditingController();
    _selectedItem = "Badminton";
    _selectedItem1 = 'Proshuttle Balakong Badminton Court';
    _selectedItem2 = "2";
    time1 = now;
    time2 = now;
    fToast = FToast();
    fToast.init(context);
  }

  List searchParamMaker(params){
    List query = [];
    for(int i = 1; i < params.length+1; i++){
      query.add(params.substring(0,i));
    }
    return query;
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
          Text("Game created successfully!"),
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
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        title: Text(
          'Create Game',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontFamily: 'Ubuntu',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [],
        centerTitle: true,
        elevation: 4,
      ),
      backgroundColor: Colors.white,
      body: Column(
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
            padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
            child: AwesomeDropDown(
              isPanDown: false,
              dropDownList: ["Badminton", "Futsal", 'Football', 'Basketball'],
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
            /*Row(
              mainAxisSize: MainAxisSize.max,
              children: [

                /*DropdownSearch<String>(
                    mode: Mode.MENU,
                    items: [" ", "Badminton", "Futsal", 'Football', 'Basketball'],
                    onChanged: print,
                    selectedItem: " "),*/
                /*FlutterFlowDropDown(
                  options: ['', 'Badminton', 'Futsal', 'Football', 'Basketball']
                      .toList(),
                  onChanged: (val) => setState(() => dropDownValue1 = val),
                  width: 130,
                  height: 40,
                  textStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  fillColor: Colors.white,
                  elevation: 2,
                  borderColor: Colors.transparent,
                  borderWidth: 0,
                  borderRadius: 0,
                  margin: EdgeInsetsDirectional.fromSTEB(8, 4, 8, 4),
                )*/
              ],
            ),*/
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
              dropDownList: [
                'Proshuttle Balakong Badminton Court',
                'Pro One Badminton Court',
                'Balakong Badminton Sports Center'
              ],
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
            /*Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                  child:

                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      /*DropdownSearch<String>(
                          mode: Mode.MENU,
                          items: [' ','Pro Shuttle Balakong', 'Pro One Badminton Court',
                            'Balakong Badminton Sports Center'],
                          onChanged: print,
                          selectedItem: " "),*/
                     /* FlutterFlowDropDown(
                        options: [
                          '',
                          'Pro Shuttle Balakong',
                          'Pro One Badminton Court',
                          'Balakong Badminton Sports Center'
                        ].toList(),
                        onChanged: (val) =>
                            setState(() => dropDownValue2 = val),
                        width: 130,
                        height: 40,
                        textStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        fillColor: Colors.white,
                        elevation: 2,
                        borderColor: Colors.transparent,
                        borderWidth: 0,
                        borderRadius: 0,
                        margin: EdgeInsetsDirectional.fromSTEB(8, 4, 8, 4),
                      )*/
                    ],
                  ),
                )
              ],
            ),*/
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
              )
            ],
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
            child: AwesomeDropDown(
              isPanDown: false,
              dropDownList: ['2', '3', '4'],
              dropDownIcon: Icon(Icons.arrow_drop_down, color: Colors.grey, size: 23,),
              selectedItem: _selectedItem2,
              onDropDownItemClick: (selectedItem) {
                _selectedItem2 = selectedItem;
              },
              dropStateChanged: (isOpened) {
                _isDropDownOpened2 = isOpened;
                if (!isOpened) {
                  _isBackPressedOrTouchedOutSide2 = false;
                }
              },
            ),/*Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                /*DropdownSearch<String>(
                          mode: Mode.MENU,
                          items: ['', '2', '3', '4'],
                          onChanged: print,
                          selectedItem: " "),
                        FlutterFlowDropDown(
                          options: ['', '2', '3', '4'].toList(),
                          onChanged: (val) =>
                              setState(() => dropDownValue3 = val),
                          width: 130,
                          height: 40,
                          textStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          fillColor: Colors.white,
                          elevation: 2,
                          borderColor: Colors.transparent,
                          borderWidth: 0,
                          borderRadius: 0,
                          margin: EdgeInsetsDirectional.fromSTEB(8, 4, 8, 4),
                        )*/
              ],
            ),*/
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
                          padding: EdgeInsetsDirectional.fromSTEB(20, 16, 0, 0),
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
                      DateTime timeOne;
                      if (textController2.text.contains("AM") ||
                          textController2.text.contains("PM")) {
                        timeOne = DateFormat.jm()
                            .parse(textController2.text);
                      } else {
                        timeOne = DateFormat.Hm()
                            .parse(textController2.text);
                      }
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
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 16, 13, 0),
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
                    List param = [userDataClass.username.toLowerCase(),
                      _selectedItem1.toLowerCase(),_selectedItem.toLowerCase()];
                    List search_param = [];
                    for(int i=0; i<param.length;i++){
                     search_param = search_param + searchParamMaker(param[i]);
                    }
                    CollectionReference games = firestore.collection('games');
                    await games.add({
                      "game_finish": "false",
                      "game_full":  "false",
                      "joined": [userDataClass.uid],
                      "gameDetails":{
                        "court_name" : _selectedItem1,
                        "date" : time1,
                        "to" : time2,
                        "gameType": _selectedItem,
                        "slots": _selectedItem2,
                      },
                      "creator": {
                        "uid": userDataClass.uid,
                      },
                      "search_param": search_param,
                    });
                    _showToastSuccess();
                    Navigator.pop(context);
                  },
                ),
                /*FFButtonWidget(
                  onPressed: () {
                    print('Button pressed ...');
                  },
                  text: 'Create',
                  options: FFButtonOptions(
                    width: 130,
                    height: 40,
                    color: Colors.black,
                    textStyle: FlutterFlowTheme.subtitle2.override(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                    ),
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                    borderRadius: 12,
                  ),
                )*/
              ],
            ),
          )
        ],
      ),
    );
  }
}
