import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:sport_finder_app/screens/admin/edit_user.dart';

class ListOfUserWidget extends StatefulWidget {
  ListOfUserWidget({Key? key}) : super(key: key);

  static const String routeName = '/admin/listofuser';

  @override
  _ListOfUserWidgetState createState() => _ListOfUserWidgetState();
}

class _ListOfUserWidgetState extends State<ListOfUserWidget> {
  late TextEditingController searchFieldController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    searchFieldController = TextEditingController();
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
                      Icons.account_box,
                      color: Colors.blue,
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                     
                    },
                    title: Text("Delete"),
                    leading: Icon(
                      Icons.camera,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget build_ListOfUser({required BuildContext context,required Map<String, dynamic>  data,required String id}) {
    DateTime date = data['created_at'].toDate();
  return  InkWell(onTap:  ()async{
    await _showChoiceDialog(context, data);
  },
      child: Padding(
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
              padding: EdgeInsetsDirectional.fromSTEB(
                  16, 0, 0, 0),
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
                      '${DateFormat('dd/MM/yyyy').format(date)}',
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
                  EdgeInsetsDirectional.fromSTEB(0, 0, 38, 0),
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
  Widget build(BuildContext context)
    {
      return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
          automaticallyImplyLeading: true,
          title: Text(
            'VIEW LIST',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontFamily: 'Ubuntu',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 14, 20, 0),
              child: FaIcon(
                FontAwesomeIcons.ellipsisV,
                color: Colors.white,
                size: 24,
              ),
            )
          ],
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
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                        child: TextFormField(
                          onChanged: (_) => setState(() {}),
                          controller: searchFieldController,
                          obscureText: false,
                          decoration: InputDecoration(
                            isDense: true,
                            labelText: 'Account Name',
                            labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Color(0xFF8B97A2),
                              fontWeight: FontWeight.w500,
                            ),
                            hintText: 'Search by name, location etc...',
                            hintStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Color(0xFF8B97A2),
                              fontWeight: FontWeight.w500,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            suffixIcon: searchFieldController.text.isNotEmpty
                                ? InkWell(
                              onTap: () =>
                                  setState(
                                        () => searchFieldController.clear(),
                                  ),
                              child: Icon(
                                Icons.clear,
                                color: Color(0xFF8B97A2),
                                size: 22,
                              ),
                            )
                                : null,
                          ),
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Color(0xFF8B97A2),
                            fontWeight: FontWeight.w500,
                          ),
                          keyboardType: TextInputType.name,
                        ),
                      ),
                    )
                  ],
                ),
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
                Flexible(child:PaginateFirestore(
                  //item builder type is compulsory.
                  itemBuilder: (index, context, documentSnapshot) {
                    final data = documentSnapshot.data() as Map<String, dynamic>;
                    if (data != null) {
                      return build_ListOfUser(
                          context: context,
                          data: data,
                          id: documentSnapshot.id,);
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
                      .orderBy("created_at"),
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
