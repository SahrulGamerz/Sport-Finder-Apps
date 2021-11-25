import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:sport_finder_app/models/globalVariables.dart';

import 'message.dart';

class MessageList extends StatefulWidget {
  const MessageList({Key? key}) : super(key: key);

  static const String routeName = '/messages';

  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Widget _buildListMessage(
      {required BuildContext context, required Map data, required String id}) {
    String chatOwnerId, chatName = "";
    if (data['chatName'] != "") {
      chatName = data['chatName'];
      chatOwnerId = data['users'][0];
    } else {
      if (data['users'][0] != uid) {
        chatOwnerId = data['users'][0];
      } else {
        chatOwnerId = data['users'][1];
      }
    }
    return FutureBuilder(
      future: firestore.collection("users").doc(chatOwnerId).get(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          DocumentSnapshot documentSnapshot = snapshot.data as DocumentSnapshot;
          Map<String, dynamic> user =
              documentSnapshot.data() as Map<String, dynamic>;
          if (data['chatName'] == "") {
            chatName = user['username'];
          }
          String pattern =
              r'(https://firebasestorage.googleapis.com\/v0\/b\/sport-finder-app.appspot.com)';
          RegExp regExp = new RegExp(pattern);
          String msg = data['last_message'];
          if (regExp.hasMatch(data['last_message'])) msg = "📷 Image";
          return Padding(
            padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                // When the user taps the button, show a snackbar.
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Message(chatName: chatName, chatId: id),
                    ),
                  );
                  /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Message Clicked"),
                    ));*/
                },
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
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: AlignmentDirectional(1, 0),
                          child: Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(2, 0, 15, 0),
                            child: Container(
                              width: 40,
                              height: 40,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Image.network(
                                user['profile_picture'],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 17, 0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Stack(
                            children: [
                              Align(
                                alignment: AlignmentDirectional(-0.95, -0.5),
                                child: Text(
                                  chatName,
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Color(0xFF15212B),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: AlignmentDirectional(-0.93, 0.55),
                                child: Text(
                                  msg,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
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
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                        child: Icon(
                          Icons.chevron_right,
                          color: Color(0xFF8B97A2),
                          size: 28,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return new Text("An error occurred, Please try again!");
        }
        return new LinearProgressIndicator();
      },
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
        title: Text(
          'CHATS',
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 16, 0, 0),
                  child: Text(
                    'Recently',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Color(0xFF8B97A2),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
            Flexible(
              child: PaginateFirestore(
                //item builder type is compulsory.
                itemBuilder: (index, context, documentSnapshot) {
                  final data = documentSnapshot.data() as Map?;
                  if (data != null) {
                    return _buildListMessage(
                        context: context, data: data, id: documentSnapshot.id);
                  } else {
                    print(data);
                    return Text(
                      "No Messages",
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Color(0xFF8B97A2),
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }
                },
                // orderBy is compulsory to enable pagination
                query: firestore
                    .collection("messages")
                    .where("users", arrayContains: uid)
                    .orderBy("last_updated"),
                //Change types accordingly
                itemBuilderType: PaginateBuilderType.listView,
                shrinkWrap: true,
                reverse: true,
                physics: NeverScrollableScrollPhysics(),
                emptyDisplay: Text(
                  "No Messages",
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Color(0xFF8B97A2),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // to fetch real-time data
                isLive: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
