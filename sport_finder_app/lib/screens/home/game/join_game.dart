import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sport_finder_app/models/globalVariables.dart';

class JoinGameWidget extends StatefulWidget {
  final String id;
  final Map data;

  const JoinGameWidget({Key? key, required this.id, required this.data})
      : super(key: key);

  @override
  _JoinGameWidgetState createState() => _JoinGameWidgetState();
}

class _JoinGameWidgetState extends State<JoinGameWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool _btnOnce = true;
  late FToast fToast;

  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  Future<void> joinGame() async {
    // Join games
    DocumentReference games = firestore.collection('games').doc(widget.id);
    await games.update({
      "joined": FieldValue.arrayUnion([uid]),
    });

    // Join group chat
    DocumentReference msgRef = firestore.collection('messages').doc(widget.id);
    await msgRef.update({
      "users": FieldValue.arrayUnion([uid]),
    });

    // Send message
    CollectionReference msgSRef =
        firestore.collection('messages').doc(widget.id).collection("messages");
    await msgSRef
        .doc()
        .set({
          'uid': uid,
          "timestamp": DateTime.now(),
          "msg": "$username joined the game!",
        })
        .then((value) => {print("Message sent")})
        .catchError((error) {
          print("Failed to send msg: $error");
        });

    //update message
    CollectionReference msgIRef = firestore.collection('messages');
    await msgIRef
        .doc(widget.id)
        .update({
          "last_updated": DateTime.now(),
          "last_message": "$username joined the game!",
        })
        .then((value) => {print("Message Update")})
        .catchError((error) {
          print("Failed to update msg: $error");
        });

    return;
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

  Widget _buildJoinGame(BuildContext context) {
    Map<String, dynamic> creator = widget.data['creator'];
    Map<String, dynamic> gameDetails = widget.data['gameDetails'];
    DateTime date1 = gameDetails['date'].toDate();
    DateTime date2 = gameDetails['to'].toDate();

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
                        'Game Details',
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    height:
                                        MediaQuery.of(context).size.width * 0.2,
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
                                      widget.data['joined'].length.toString() +
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
                                roundLoadingShape: true,
                                color: Colors.black,
                                child: Text(
                                  "Join",
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
                                  if (_btnOnce) {
                                    startLoading();
                                    await joinGame();
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
          'Join Game',
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
      body: _buildJoinGame(context),
    );
  }
}
