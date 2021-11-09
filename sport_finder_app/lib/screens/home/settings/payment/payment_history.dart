import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import '../../../../models/globalVariables.dart' as globalVariables;

class PaymentHistory extends StatefulWidget {
  const PaymentHistory({Key? key}) : super(key: key);
  static const String routeName = '/settings/payment/history';

  @override
  _PaymentHistoryState createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  /*Widget _buildPaymentHistory(context){
    return
  }*/

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
                        return new Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
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
                                            'BADMINTON',
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
                                            '2 Players, Proshuttle Balakong',
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
                                      ' 20/10/2021',
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
                        );
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
