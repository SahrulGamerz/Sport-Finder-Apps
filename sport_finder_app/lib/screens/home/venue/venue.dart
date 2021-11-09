import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:sport_finder_app/screens/home/venue/view_court.dart';

class VenueWidget extends StatefulWidget {
  //VenueWidget({Key key}) : super(key: key);

  @override
  _VenueWidgetState createState() => _VenueWidgetState();
  final String cid;

  VenueWidget({required this.cid});
}

class _VenueWidgetState extends State<VenueWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _buildCourtWidget(BuildContext context) {
    return new FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('locations')
            .doc(widget.cid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            DocumentSnapshot documentSnapshot =
                snapshot.data as DocumentSnapshot;
            Map<String, dynamic> data =
                documentSnapshot.data() as Map<String, dynamic>;
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        8, 0, 8, 0),
                                    child: Card(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      color: Colors.white,
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Image.network(
                                            data['image'],
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.85,
                                            height: 1,
                                            decoration: BoxDecoration(
                                              color: Color(0xFFDBE2E7),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    12, 4, 12, 4),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Flexible(
                                                    child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0, 4, 0, 0),
                                                        child: Text(
                                                          data['court_name'],
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Montserrat',
                                                            color: Color(
                                                                0xFF151B1E),
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        )))
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    12, 4, 12, 4),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    data['description'],
                                                    style: TextStyle(
                                                      fontFamily: 'Lexend Deca',
                                                      color: Color(0xFF8B97A2),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    12, 4, 12, 8),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 4),
                                                  child: Icon(
                                                    Icons.schedule,
                                                    color: Color(0xFF4B39EF),
                                                    size: 20,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(4, 0, 0, 0),
                                                  child: Text(
                                                    data['open_time'],
                                                    style: TextStyle(
                                                      fontFamily: 'Lexend Deca',
                                                      color: Color(0xFF4B39EF),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(24, 0, 0, 4),
                                                  child: Icon(
                                                    Icons.location_on_sharp,
                                                    color: Color(0xFF4B39EF),
                                                    size: 20,
                                                  ),
                                                ),
                                                Flexible(
                                                    child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(4, 0, 0, 0),
                                                  child: Text(
                                                    data['address'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: 'Lexend Deca',
                                                      color: Color(0xFF4B39EF),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ))
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 30, 0, 20),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 5, 0, 0),
                                                  child: ArgonButton(
                                                    height: 40,
                                                    width: 130,
                                                    borderRadius: 12.0,
                                                    roundLoadingShape: true,
                                                    color: Colors.black,
                                                    child: Text(
                                                      "View",
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Montserrat',
                                                        color: Colors.white,
                                                        //fontSize: 18,
                                                        //fontWeight: FontWeight.w700
                                                      ),
                                                    ),
                                                    loader: Container(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child:
                                                          SpinKitDoubleBounce(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    onTap: (startLoading,
                                                        stopLoading,
                                                        btnState) async {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => ViewCourtWidget(
                                                              cid: widget.cid,
                                                              pph: int.parse(data[
                                                                  'price_per_hour']),
                                                              cc: int.parse(data[
                                                                  'court_num']),
                                                              img:
                                                                  data['image'],
                                                              cn: data[
                                                                  'court_name'],
                                                              gameType: data['gameType']),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
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
          'VENUE',
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
      body: _buildCourtWidget(context),
    );
  }
}
