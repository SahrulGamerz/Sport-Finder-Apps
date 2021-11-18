import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sport_finder_app/models/globalVariables.dart' as globalVariables;
import 'package:sport_finder_app/widgets/PaypalPayment.dart';

class YourGameWidget extends StatefulWidget {
  final String id;
  final Map data;

  const YourGameWidget({Key? key, required this.id, required this.data})
      : super(key: key);

  @override
  _YourGameWidgetState createState() => _YourGameWidgetState();
}

class _YourGameWidgetState extends State<YourGameWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool _btnOnce = true;
  late FToast fToast;
  late String paymentId;
  late bool booked;
  bool sended = false;

  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    booked = widget.data['booked'];
  }

  Future<void> cancelGame({required Map creator}) async {
    // Leave games
    DocumentReference games = firestore.collection('games').doc(widget.id);
    await games.update({
      "joined": FieldValue.arrayRemove([globalVariables.uid])
    }).then((value) => print("Games Update"));

    // Leave group chat
    DocumentReference msgRef = firestore.collection('messages').doc(widget.id);
    await msgRef.update({
      "users": FieldValue.arrayRemove([globalVariables.uid])
    }).then((value) => print("Message Update"));

    // Send leaving message
    CollectionReference msgSRef =
        firestore.collection('messages').doc(widget.id).collection("messages");
    await msgSRef
        .doc()
        .set({
          'uid': globalVariables.uid,
          "timestamp": DateTime.now(),
          "msg": "${globalVariables.username} left the game!",
        })
        .then((value) => {print("Message sent")})
        .catchError((error) {
          print("Failed to send msg: $error");
        });

    // Update message
    CollectionReference msgIRef = firestore.collection('messages');
    await msgIRef
        .doc(widget.id)
        .update({
          "last_updated": DateTime.now(),
          "last_message": "${globalVariables.username} left the game!",
        })
        .then((value) => {print("Message Update")})
        .catchError((error) {
          print("Failed to update msg: $error");
        });

    // Retrieve data
    DocumentSnapshot gameData = await games.get();
    Map<String, dynamic> data = gameData.data() as Map<String, dynamic>;

    // Change creator id if owner left
    if (creator['uid'] == globalVariables.uid && data['joined'].length > 1) {
      await games.update({
        "creator": {
          'uid': data['joined'][0],
        },
      }).then((value) => print("Games Update"));
    } else if (data['joined'].length < 1) {
      // Delete message and games if no one left
      await games.delete();
      await msgSRef.get().then((QuerySnapshot querySnapshot) {
        querySnapshot.docs
            .forEach((doc) async => {await doc.reference.delete()});
      });
      await msgIRef.doc(widget.id).delete();
    }

    //check slots
    DocumentSnapshot game = await firestore.collection('games').doc(widget.id).get();
    Map<String, dynamic> gameDetails = data['gameDetails'] as Map<String, dynamic>;
    if(data['joined'].length.toString() == gameDetails['slots'].toString()) {
      DocumentReference games = firestore.collection('games').doc(widget.id);
      await games.update({
        "game_full": "true",
      });
    }else{
      DocumentReference games = firestore.collection('games').doc(widget.id);
      await games.update({
        "game_full": "false",
      });
    }

    return;
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

  Future<void> _showChoiceDialog(BuildContext context, String totalPrice,
      String cid, int pph, String cn, DateTime date1, DateTime date2, String gameType) {
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
                                    if(!sended){
                                      sended = true;
                                      setState(() {
                                        paymentId = number;
                                        booked = true;
                                      });
                                      FirebaseFirestore firestore =
                                          FirebaseFirestore.instance;
                                      // Create booking
                                      CollectionReference
                                      booking =
                                      firestore
                                          .collection(
                                          'booking');
                                      await booking
                                          .doc()
                                          .set({
                                        'court_id':
                                        cid,
                                        'end_date_time':
                                        date2,
                                        'game_id':
                                        widget
                                            .id,
                                        'gameType': gameType,
                                        'payment_id':
                                        number,
                                        'date': DateTime
                                            .now(),
                                        'total_price':
                                        totalPrice.toString(),
                                        'start_date_time':
                                        date1,
                                        'status':
                                        'booked',
                                        'uid': globalVariables
                                            .uid,
                                      })
                                          .then((value) =>
                                          print(
                                              "Update Success"))
                                          .catchError(
                                              (error) =>
                                              print("Failed to update booking: $error"));

                                      // Update history
                                      CollectionReference
                                      history =
                                      firestore
                                          .collection(
                                          'history');
                                      await history
                                          .doc(globalVariables
                                          .uid)
                                          .update({
                                        'payment_history':
                                        FieldValue
                                            .arrayUnion([
                                          {
                                            'code':
                                            'success',
                                            'court_name':
                                            cn,
                                            'game_id':
                                            widget.id,
                                            'gameType': gameType,
                                            'date':
                                            DateTime.now(),
                                            'payment_id':
                                            number,
                                            'total_price':
                                            totalPrice.toString(),
                                          },
                                        ]),
                                      })
                                          .then((value) =>
                                          print(
                                              "Update Success"))
                                          .catchError(
                                              (error) async {
                                            print(
                                                "Failed to update history: $error");
                                            await history
                                                .doc(globalVariables
                                                .uid)
                                                .set({
                                              'payment_history':
                                              [
                                                {
                                                  'code': 'success',
                                                  'court_name': cn,
                                                  'game_id': widget.id,
                                                  'gameType': gameType,
                                                  'date': DateTime.now(),
                                                  'payment_id': number,
                                                  'total_price': totalPrice.toString(),
                                                },
                                              ],
                                            })
                                                .then((value) => print(
                                                "Update Success"))
                                                .catchError((error) =>
                                                print("Failed to update history: $error"));
                                          });

                                      // Update Sales
                                      CollectionReference
                                      sales =
                                      firestore
                                          .collection(
                                          'sales');
                                      await sales
                                          .doc(cid)
                                          .update({
                                        'sales.${date1.year}.${date1.month}': FieldValue.arrayUnion([
                                          {
                                            'date': DateTime.now(),
                                            'total_price': totalPrice.toString(),
                                          },
                                        ]),
                                      })
                                          .then((value) =>
                                          print(
                                              "Update Success"))
                                          .catchError(
                                              (error) async {
                                            print(
                                                "Failed to update sales: $error");
                                            await sales
                                                .doc(
                                                cid)
                                                .set({
                                              'sales':
                                              {
                                                '${date1.year}': {
                                                  '${date1.month}': [
                                                    {
                                                      'date': DateTime.now(),
                                                      'total_price': totalPrice.toString(),
                                                    },
                                                  ]
                                                }
                                              },
                                            })
                                                .then((value) => print(
                                                "Update Success"))
                                                .catchError((error) =>
                                                print("Failed to update sales: $error"));
                                          });

                                      // Send message
                                      CollectionReference msgSRef = firestore
                                          .collection(
                                          'messages')
                                          .doc(widget
                                          .id)
                                          .collection(
                                          "messages");
                                      await msgSRef
                                          .doc()
                                          .set({
                                        'uid': globalVariables
                                            .uid,
                                        "timestamp":
                                        DateTime
                                            .now(),
                                        "msg":
                                        "${globalVariables.username} has booked the court!",
                                      })
                                          .then(
                                              (value) =>
                                          {
                                            print("Message sent")
                                          })
                                          .catchError(
                                              (error) {
                                            print(
                                                "Failed to send msg: $error");
                                          });

                                      //update message
                                      CollectionReference
                                      msgIRef =
                                      firestore
                                          .collection(
                                          'messages');
                                      await msgIRef
                                          .doc(widget
                                          .id)
                                          .update({
                                        "last_updated":
                                        DateTime
                                            .now(),
                                        "last_message":
                                        "${globalVariables.username} has booked the court!",
                                      })
                                          .then(
                                              (value) =>
                                          {
                                            print("Message Update")
                                          })
                                          .catchError(
                                              (error) {
                                            print(
                                                "Failed to update msg: $error");
                                          });

                                      //update game details
                                      DocumentReference
                                      games =
                                      firestore
                                          .collection(
                                          'games')
                                          .doc(widget
                                          .id);
                                      await games
                                          .update({
                                        'booked':
                                        true,
                                      })
                                          .then(
                                              (value) =>
                                          {
                                            print("Games Update")
                                          })
                                          .catchError(
                                              (error) {
                                            print(
                                                "Failed to update msg: $error");
                                          });
                                      print(
                                          'Order ID: ' +
                                              number);
                                      stopLoading();
                                    }
                                  },
                                  itemName: '$cn Booking',
                                  itemPrice: totalPrice,
                                )));
                        await new Future.delayed(
                            const Duration(milliseconds: 2000), () {
                          if (paymentId != '')
                            _showToastSuccess(context,
                                'Payment has been received!\nPayment ID: $paymentId');
                          Navigator.pop(context);
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

  Widget _buildYourGame(BuildContext context) {
    Map<String, dynamic> creator = widget.data['creator'];
    Map<String, dynamic> gameDetails = widget.data['gameDetails'];
    DateTime date1 = gameDetails['date'].toDate();
    DateTime date2 = gameDetails['to'].toDate();
    if (creator['uid'] == globalVariables.uid) {
      return new FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(creator["uid"])
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              DocumentSnapshot documentSnapshot =
                  snapshot.data as DocumentSnapshot;
              Map<String, dynamic> user =
                  documentSnapshot.data() as Map<String, dynamic>;
              return Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 16, 0, 0),
                        child: Text(
                          'Your Game',
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
                      padding: EdgeInsetsDirectional.fromSTEB(20, 16, 20, 70),
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
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        20, 0, 0, 0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      height:
                                          MediaQuery.of(context).size.width *
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
                                    padding: EdgeInsetsDirectional.fromSTEB(
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
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 40, 0, 2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 0, 0, 0),
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
                                    EdgeInsetsDirectional.fromSTEB(0, 2, 0, 2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 0, 0, 0),
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
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 20, 0, 2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 0, 0, 0),
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
                                    EdgeInsetsDirectional.fromSTEB(0, 2, 0, 2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 0, 0, 0),
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
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 20, 0, 2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 0, 0, 0),
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
                                    EdgeInsetsDirectional.fromSTEB(0, 2, 0, 2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 0, 0, 0),
                                      child: Text(
                                        widget.data['joined'].length
                                                .toString() +
                                            "/" +
                                            gameDetails['slots'] +
                                            " Players",
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
                                    EdgeInsetsDirectional.fromSTEB(0, 20, 0, 2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 0, 0, 0),
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
                                    EdgeInsetsDirectional.fromSTEB(0, 2, 0, 2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 0, 0, 0),
                                      child: Text(
                                        DateFormat('dd/MM/yyyy').format(date1),
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
                                    EdgeInsetsDirectional.fromSTEB(0, 20, 0, 2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 0, 0, 0),
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
                                    EdgeInsetsDirectional.fromSTEB(0, 2, 0, 2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 0, 0, 0),
                                      child: Text(
                                        '${DateFormat.jm().format(date1)} - ${DateFormat.jm().format(date2)}',
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
                                    EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ArgonButton(
                                      height: 40,
                                      width: 130,
                                      borderRadius: 12.0,
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1),
                                      roundLoadingShape: true,
                                      color: Colors.white,
                                      child: Text(
                                        "Cancel Game",
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Colors.black,
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
                                        if (booked) {
                                          return _showToastWarning(context,
                                              "Cannot cancel a game that already booked!");
                                        }
                                        if (_btnOnce) {
                                          startLoading();
                                          await cancelGame(creator: creator);
                                          stopLoading();
                                          Navigator.pop(context);
                                          return;
                                        }
                                        _showToastWarning(context,
                                            "Please wait before trying again!");
                                      },
                                    ),
                                    ArgonButton(
                                      height: 40,
                                      width: 130,
                                      borderRadius: 12.0,
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1),
                                      roundLoadingShape: true,
                                      color: Colors.white,
                                      child: Text(
                                        booked
                                            ? "Booked"
                                            : "Book Court",
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Colors.black,
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
                                        if (booked) {
                                          return _showToastWarning(
                                              context, "Already booked!");
                                        }
                                        paymentId = '';
                                        if (_btnOnce) {
                                          startLoading();
                                          QuerySnapshot locations =
                                              await firestore
                                                  .collection('locations')
                                                  .where('court_name',
                                                      isEqualTo: gameDetails[
                                                          'court_name'])
                                                  .get();
                                          int pph = 0;
                                          String cid = '';
                                          String cn = '';
                                          String gameType = '';
                                          await Future.forEach(locations.docs,
                                              (QueryDocumentSnapshot
                                                  doc) async {
                                            pph = int.parse(
                                                doc['price_per_hour']);
                                            cid = doc.id;
                                            cn = doc['court_name'];
                                            gameType = doc['gameType'];
                                          });
                                          final hours =
                                              date2.difference(date1).inHours;
                                          final tp = hours * pph;
                                          startLoading();
                                          if (globalVariables
                                              .checkPaymentInfo()) {
                                            _showToastSuccess(context,
                                                'Redirecting to the payment gateway!');
                                            await Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                    builder:
                                                        (BuildContext
                                                                context) =>
                                                            PaypalPayment(
                                                              onFinish:
                                                                  (number) async {
                                                                if(!sended){
                                                                  sended = true;
                                                                  setState(() {
                                                                    paymentId =
                                                                        number;
                                                                    booked = true;
                                                                  });
                                                                  FirebaseFirestore
                                                                  firestore =
                                                                      FirebaseFirestore
                                                                          .instance;
                                                                  // Create booking
                                                                  CollectionReference
                                                                  booking =
                                                                  firestore
                                                                      .collection(
                                                                      'booking');
                                                                  await booking
                                                                      .doc()
                                                                      .set({
                                                                    'court_id':
                                                                    cid,
                                                                    'end_date_time':
                                                                    date2,
                                                                    'game_id':
                                                                    widget
                                                                        .id,
                                                                    'gameType': gameType,
                                                                    'payment_id':
                                                                    number,
                                                                    'date': DateTime
                                                                        .now(),
                                                                    'total_price':
                                                                    tp.toString(),
                                                                    'start_date_time':
                                                                    date1,
                                                                    'status':
                                                                    'booked',
                                                                    'uid': globalVariables
                                                                        .uid,
                                                                  })
                                                                      .then((value) =>
                                                                      print(
                                                                          "Update Success"))
                                                                      .catchError(
                                                                          (error) =>
                                                                          print("Failed to update booking: $error"));

                                                                  // Update history
                                                                  CollectionReference
                                                                  history =
                                                                  firestore
                                                                      .collection(
                                                                      'history');
                                                                  await history
                                                                      .doc(globalVariables
                                                                      .uid)
                                                                      .update({
                                                                    'payment_history':
                                                                    FieldValue
                                                                        .arrayUnion([
                                                                      {
                                                                        'code':
                                                                        'success',
                                                                        'court_name':
                                                                        cn,
                                                                        'game_id':
                                                                        widget.id,
                                                                        'gameType': gameType,
                                                                        'date':
                                                                        DateTime.now(),
                                                                        'payment_id':
                                                                        number,
                                                                        'total_price':
                                                                        tp.toString(),
                                                                      },
                                                                    ]),
                                                                  })
                                                                      .then((value) =>
                                                                      print(
                                                                          "Update Success"))
                                                                      .catchError(
                                                                          (error) async {
                                                                        print(
                                                                            "Failed to update history: $error");
                                                                        await history
                                                                            .doc(globalVariables
                                                                            .uid)
                                                                            .set({
                                                                          'payment_history':
                                                                          [
                                                                            {
                                                                              'code': 'success',
                                                                              'court_name': cn,
                                                                              'game_id': widget.id,
                                                                              'gameType': gameType,
                                                                              'date': DateTime.now(),
                                                                              'payment_id': number,
                                                                              'total_price': tp.toString(),
                                                                            },
                                                                          ],
                                                                        })
                                                                            .then((value) => print(
                                                                            "Update Success"))
                                                                            .catchError((error) =>
                                                                            print("Failed to update history: $error"));
                                                                      });

                                                                  // Update Sales
                                                                  CollectionReference
                                                                  sales =
                                                                  firestore
                                                                      .collection(
                                                                      'sales');
                                                                  await sales
                                                                      .doc(cid)
                                                                      .update({
                                                                    'sales.${date1.year}.${date1.month}': FieldValue.arrayUnion([
                                                                      {
                                                                        'date': DateTime.now(),
                                                                        'total_price': tp.toString(),
                                                                      },
                                                                    ]),
                                                                  })
                                                                      .then((value) =>
                                                                      print(
                                                                          "Update Success"))
                                                                      .catchError(
                                                                          (error) async {
                                                                        print(
                                                                            "Failed to update sales: $error");
                                                                        await sales
                                                                            .doc(
                                                                            cid)
                                                                            .set({
                                                                          'sales':
                                                                          {
                                                                            '${date1.year}': {
                                                                              '${date1.month}': [
                                                                                {
                                                                                  'date': DateTime.now(),
                                                                                  'total_price': tp.toString(),
                                                                                },
                                                                              ]
                                                                            }
                                                                          },
                                                                        })
                                                                            .then((value) => print(
                                                                            "Update Success"))
                                                                            .catchError((error) =>
                                                                            print("Failed to update sales: $error"));
                                                                      });

                                                                  // Send message
                                                                  CollectionReference msgSRef = firestore
                                                                      .collection(
                                                                      'messages')
                                                                      .doc(widget
                                                                      .id)
                                                                      .collection(
                                                                      "messages");
                                                                  await msgSRef
                                                                      .doc()
                                                                      .set({
                                                                    'uid': globalVariables
                                                                        .uid,
                                                                    "timestamp":
                                                                    DateTime
                                                                        .now(),
                                                                    "msg":
                                                                    "${globalVariables.username} has booked the court!",
                                                                  })
                                                                      .then(
                                                                          (value) =>
                                                                      {
                                                                        print("Message sent")
                                                                      })
                                                                      .catchError(
                                                                          (error) {
                                                                        print(
                                                                            "Failed to send msg: $error");
                                                                      });

                                                                  //update message
                                                                  CollectionReference
                                                                  msgIRef =
                                                                  firestore
                                                                      .collection(
                                                                      'messages');
                                                                  await msgIRef
                                                                      .doc(widget
                                                                      .id)
                                                                      .update({
                                                                    "last_updated":
                                                                    DateTime
                                                                        .now(),
                                                                    "last_message":
                                                                    "${globalVariables.username} has booked the court!",
                                                                  })
                                                                      .then(
                                                                          (value) =>
                                                                      {
                                                                        print("Message Update")
                                                                      })
                                                                      .catchError(
                                                                          (error) {
                                                                        print(
                                                                            "Failed to update msg: $error");
                                                                      });

                                                                  //update game details
                                                                  DocumentReference
                                                                  games =
                                                                  firestore
                                                                      .collection(
                                                                      'games')
                                                                      .doc(widget
                                                                      .id);
                                                                  await games
                                                                      .update({
                                                                    'booked':
                                                                    true,
                                                                  })
                                                                      .then(
                                                                          (value) =>
                                                                      {
                                                                        print("Games Update")
                                                                      })
                                                                      .catchError(
                                                                          (error) {
                                                                        print(
                                                                            "Failed to update msg: $error");
                                                                      });
                                                                  print(
                                                                      'Order ID: ' +
                                                                          number);
                                                                  stopLoading();
                                                                }
                                                              },
                                                              itemName:
                                                                  '$cn Booking',
                                                              itemPrice:
                                                                  tp.toString(),
                                                            )));
                                            await new Future.delayed(
                                                const Duration(
                                                    milliseconds: 2000), () {
                                              if (paymentId != '')
                                                _showToastSuccess(context,
                                                    'Payment has been received!\nPayment ID: $paymentId');
                                            });
                                            stopLoading();
                                          } else {
                                            _showToastWarning(context,
                                                'Please update your payment information!');
                                            await _showChoiceDialog(
                                                context,
                                                tp.toString(),
                                                cid,
                                                pph,
                                                cn,
                                                date1,
                                                date2,
                                                gameType);
                                            stopLoading();
                                          }
                                          /*await cancelGame(creator: creator);
                                          stopLoading();
                                          Navigator.pop(context);*/
                                          return;
                                        }
                                        _showToastWarning(context,
                                            "Please wait before trying again!");
                                      },
                                    ),
                                  ],
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
    } else {
      return new FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(creator["uid"])
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              DocumentSnapshot documentSnapshot =
                  snapshot.data as DocumentSnapshot;
              Map<String, dynamic> user =
                  documentSnapshot.data() as Map<String, dynamic>;
              return Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 16, 0, 0),
                        child: Text(
                          'Your Game',
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
                      padding: EdgeInsetsDirectional.fromSTEB(20, 16, 20, 70),
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
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        20, 0, 0, 0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      height:
                                          MediaQuery.of(context).size.width *
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
                                    padding: EdgeInsetsDirectional.fromSTEB(
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
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 40, 0, 2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 0, 0, 0),
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
                                    EdgeInsetsDirectional.fromSTEB(0, 2, 0, 2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 0, 0, 0),
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
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 20, 0, 2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 0, 0, 0),
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
                                    EdgeInsetsDirectional.fromSTEB(0, 2, 0, 2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 0, 0, 0),
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
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 20, 0, 2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 0, 0, 0),
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
                                    EdgeInsetsDirectional.fromSTEB(0, 2, 0, 2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 0, 0, 0),
                                      child: Text(
                                        widget.data['joined'].length
                                                .toString() +
                                            "/" +
                                            gameDetails['slots'] +
                                            " Players",
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
                                    EdgeInsetsDirectional.fromSTEB(0, 20, 0, 2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 0, 0, 0),
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
                                    EdgeInsetsDirectional.fromSTEB(0, 2, 0, 2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 0, 0, 0),
                                      child: Text(
                                        DateFormat('dd/MM/yyyy').format(date1),
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
                                    EdgeInsetsDirectional.fromSTEB(0, 20, 0, 2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 0, 0, 0),
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
                                    EdgeInsetsDirectional.fromSTEB(0, 2, 0, 2),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          20, 0, 0, 0),
                                      child: Text(
                                        '${DateFormat.jm().format(date1)} - ${DateFormat.jm().format(date2)}',
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
                                    EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                                child: ArgonButton(
                                  height: 40,
                                  width: 130,
                                  borderRadius: 12.0,
                                  borderSide:
                                      BorderSide(color: Colors.black, width: 1),
                                  roundLoadingShape: true,
                                  color: Colors.white,
                                  child: Text(
                                    "Leave Game",
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.black,
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
                                    if (_btnOnce) {
                                      startLoading();
                                      await cancelGame(creator: creator);
                                      stopLoading();
                                      Navigator.pop(context);
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
            'Your Game',
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
        body: _buildYourGame(context));
  }
}
