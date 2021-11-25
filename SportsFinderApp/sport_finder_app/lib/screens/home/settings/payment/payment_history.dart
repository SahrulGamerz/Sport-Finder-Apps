import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sport_finder_app/screens/home/settings/payment/payment_details.dart';
import '../../../../models/globalVariables.dart' as globalVariables;

class PaymentHistory extends StatefulWidget {
  const PaymentHistory({Key? key}) : super(key: key);
  static const String routeName = '/settings/payment/history';

  @override
  _PaymentHistoryState createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _buildPaymentHistory(BuildContext context, Map<String, dynamic> data, int index){
    Map<String, dynamic> dataMap = data['payment_history'][index] as Map<String, dynamic>;
    if(dataMap['game_id'] != "") {
      return new FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('games')
              .doc(dataMap["game_id"])
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              DocumentSnapshot documentSnapshot =
              snapshot.data as DocumentSnapshot;
              Map<String, dynamic> game =
              documentSnapshot.data() as Map<String, dynamic>;
              Map<String, dynamic> gameDetails =
              game['gameDetails'] as Map<String, dynamic>;
              DateTime date = dataMap['date'].toDate();
              return new Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
                  child: InkWell(
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentDetailsWidget(dataMap: dataMap),
                          ));
                    },
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
                                    alignment: AlignmentDirectional(-0.1, -0.5),
                                    child: Text(
                                      dataMap['gameType'].toUpperCase(),
                                      style:
                                      TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Color(0xFF15212B),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: AlignmentDirectional(2.64, 0.55),
                                    child: Text(
                                      '${gameDetails['slots']} players, ${dataMap['court_name']}',
                                      style:
                                      TextStyle(
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
                              padding:
                              EdgeInsetsDirectional.fromSTEB(30, 29, 0, 0),
                              child: Text(
                                '${DateFormat('dd/MM/yyyy').format(date)}',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Color(0xFF8B97A2),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
              );
            } else if (snapshot.hasError) {
              return new Text("An error occurred, Please try again!");
            }
            return new LinearProgressIndicator();
          });
    }else{
      DateTime date = dataMap['date'].toDate();
      return new Padding(
          padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
          child: InkWell(
            onTap: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentDetailsWidget(dataMap: dataMap),
                  ));
            },
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
                            alignment: AlignmentDirectional(-0.1, -0.5),
                            child: Text(
                              dataMap['gameType'].toUpperCase(),
                              style:
                              TextStyle(
                                fontFamily: 'Montserrat',
                                color: Color(0xFF15212B),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(2.64, 0.55),
                            child: Text(
                              '1 players, ${dataMap['court_name']}',
                              style:
                              TextStyle(
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
                      padding:
                      EdgeInsetsDirectional.fromSTEB(30, 29, 0, 0),
                      child: Text(
                        '${DateFormat('dd/MM/yyyy').format(date)}',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Color(0xFF8B97A2),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
      );
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
          'PAYMENT HISTORY',
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
      body: SafeArea(
        child: Stack(
          children: [
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('history')
                  .doc(globalVariables.uid)
                  .get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    DocumentSnapshot documentSnapshot =
                    snapshot.data as DocumentSnapshot;
                    if(documentSnapshot.data() == null) {
                      return Center(
                        child: Container(
                          child: Text(
                            "You didn't do any payment(s)",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Color(0xFF8B97A2),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }
                    Map<String, dynamic> data =
                    documentSnapshot.data() as Map<String, dynamic>;
                    data['payment_history'] = data['payment_history'].reversed.toList();
                    if(data['payment_history'].length < 1 ) {
                      return Center(
                        child: Container(
                          child: Text(
                            "You didn't do any payment(s)",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Color(0xFF8B97A2),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }
                    return new ListView.builder(
                      itemCount: data['payment_history'].length,
                      itemBuilder: (BuildContext context, int  index){
                        return _buildPaymentHistory(context, data, index);
                      }
                    );
                  }else if (snapshot.hasError) {
                    return new Center(
                      child: Container(
                        child: Text(
                          "An error occurred, Please try again!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Color(0xFF8B97A2),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }
                  return new LinearProgressIndicator();
              }
            ),
          ],
        ),
      ),
    );
  }
}
