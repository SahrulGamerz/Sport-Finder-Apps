import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:sport_finder_app/screens/admin/manageUsers/edit_user.dart';
import 'package:http/http.dart' as http;

class ListOfUserWidget extends StatefulWidget {
  ListOfUserWidget({Key? key}) : super(key: key);

  static const String routeName = '/admin/listofuser';

  @override
  _ListOfUserWidgetState createState() => _ListOfUserWidgetState();
}

class _ListOfUserWidgetState extends State<ListOfUserWidget> {
  late TextEditingController searchFieldController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late FToast fToast;

  @override
  void initState() {
    super.initState();
    searchFieldController = TextEditingController();
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

  Future<void> _showChoiceDialog(BuildContext context, data) {
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
                            builder: (context) => EditUser(userdata: data),
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
                      final resp = await http.post(
                        Uri.parse(
                            'https://accmngt.sfa.yewonkim.tk/admin/accmngt/delete'),
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                        body: jsonEncode(<String, String>{
                          'uid': data['uid'],
                        }),
                      );
                      Map<String, dynamic> status = jsonDecode(resp.body);
                      print(status['status']);
                      if (status['status'] == "Success") {
                        CollectionReference users =
                            FirebaseFirestore.instance.collection('users');
                        users.doc(data['uid']).delete().then((value) {
                          print("User Deleted");
                          _showToastSuccess(
                              context, "User deleted successfully");
                        }).catchError((error) {
                          print("Failed to delete user: $error");
                          _showToastError(
                              context, "Failed to delete userdata in Database");
                        });
                      } else {
                        _showToastError(context, "Failed to delete user");
                      }
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

  Widget build_ListOfUser(
      {required BuildContext context,
      required Map<String, dynamic> data,
      required String id}) {
    DateTime date = data['created_at'].toDate();
    return InkWell(
        onTap: () async {
          await _showChoiceDialog(context, data);
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
                    padding: EdgeInsetsDirectional.fromSTEB(16, 0, 0, 0),
                    child: Stack(
                      children: [
                        Align(
                          alignment: AlignmentDirectional(-0.1, -0.5),
                          child: Text(
                            '${data['username']}',
                            style: TextStyle(
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
                            'Created At: ${DateFormat('dd/MM/yyyy').format(date)}',
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
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        child: Container(
                          width: 40,
                          height: 40,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.network(
                            '${data['profile_picture']}',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        title: Text(
          'USER LIST',
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 16, 0, 0),
                    child: Text(
                      'List Of User',
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
                    final data =
                        documentSnapshot.data() as Map<String, dynamic>;
                    if (data != null) {
                      return build_ListOfUser(
                        context: context,
                        data: data,
                        id: documentSnapshot.id,
                      );
                    } else {
                      print(data);
                      return Text(
                        "You didn't have any user",
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
                      .collection("users")
                      .orderBy("created_at", descending: true),
                  //Change types accordingly
                  itemBuilderType: PaginateBuilderType.listView,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  emptyDisplay: Text(
                    "You didn't have any user",
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
