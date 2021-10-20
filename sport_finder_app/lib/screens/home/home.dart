import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';
import 'package:sport_finder_app/models/user.dart';
import 'package:sport_finder_app/screens/home/create_game.dart';
import 'package:sport_finder_app/screens/home/join_game.dart';
import 'package:sport_finder_app/screens/home/your_game.dart';
import 'package:sport_finder_app/services/auth.dart';
import 'package:sport_finder_app/widgets/drawer.dart';
import 'message/message_list.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  static const String routeName = '/home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late FToast fToast;
  final AuthService _auth = AuthService();
  late TextEditingController searchFieldController;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late String uid;
  late Query query;
  late String key;
  DateTime _startDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 10, 0, 0);
  DateTime _lastStartDate = DateTime(2099, 12, 31, 19, 0, 0);
  late int _startDateSecond;
  late int _lastStartDateSecond;
  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    searchFieldController = TextEditingController();
    refreshUser();
    key = "";
    _startDateSecond = _startDate.millisecondsSinceEpoch ~/ 1000;
    _lastStartDateSecond = _lastStartDate.millisecondsSinceEpoch ~/ 1000;
    query = firestore
        .collection("games")
        .where("gameDetails.date", isGreaterThanOrEqualTo: Timestamp(_startDateSecond, 0))
        .where("gameDetails.date", isLessThanOrEqualTo: Timestamp(_lastStartDateSecond, 0))
        .where("game_full", isEqualTo: "false")
        .where("game_finish", isEqualTo: "false")
        .orderBy("gameDetails.date");
    super.initState();
  }

  Future refreshUser() async {
    //refresh user
    await _auth.refreshUser();
    print("User refresh success");
  }

  Widget _buildGame(
      {required BuildContext context, required Map data, required String id, required int type}) {
    Map<String, dynamic> creator = data['creator'];
    Map<String, dynamic> gameDetails = data['gameDetails'];
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

            return Padding(
              padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: InkWell(
                // When the user taps the button, show a snackbar.
                onTap: () {
                  if(data['joined'].contains(uid)){
                    type = 0;
                  }
                  if(type == 0){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => YourGameWidget(id:id, data: data,),
                        ));
                  }
                  else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JoinGameWidget(id:id, data:data),

                        ));
                  }
                  /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Game ID: " + id),
                  ));*/
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
                          padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment(-0.1, -0.5),
                                child: Text(
                                  gameDetails["gameType"].toUpperCase(),
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Color(0xFF15212B),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment(2.64, 0.55),
                                child: Text(
                                  '${gameDetails["slots"]} Players, ${gameDetails["court_name"]}',
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
                            alignment: Alignment(1, 0),
                            child: Container(
                              width: 40,
                              height: 40,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Image.network(
                                '${user["profile_picture"]}',
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                          child: Text(
                            '${data["joined"].length} / ${gameDetails["slots"]}',
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
              ),
            );
          } else if (snapshot.hasError) {
            return new Text("An error occurred, Please try again!");
          }
          return new LinearProgressIndicator();
        });
  }

  /*Widget _buildGame(
      {required BuildContext context, required Map data, required String id}) {
    Map<String, dynamic> creator = data['creator'];
    Map<String, dynamic> gameDetails = data['gameDetails'];
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: InkWell(
        // When the user taps the button, show a snackbar.
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Game ID: " + id),
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
                  padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment(-0.1, -0.5),
                        child: Text(
                          gameDetails["gameType"].toUpperCase(),
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Color(0xFF15212B),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment(2.64, 0.55),
                        child: Text(
                          '${gameDetails["slots"]} Players, ${gameDetails["court_name"]}',
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
                    alignment: Alignment(1, 0),
                    child: Container(
                      width: 40,
                      height: 40,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.network(
                        '${creator["profile_picture"]}',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Text(
                    '${data["joined"].length} / ${gameDetails["slots"]}',
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
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserInfoRetrieve?>(context);
    uid = user!.uid;
    Future<bool> showExitPopup() async {
      return await showDialog(
            //show confirm dialogue
            //the return value will be from "Yes" or "No" options
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Exit App'),
              content: Text('Do you want to exit an App?'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  //return false when click on "NO"
                  child: Text('No'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    SystemNavigator.pop();
                  },
                  //return true when click on "Yes"
                  child: Text('Yes'),
                ),
              ],
            ),
          ) ??
          false; //if showDialog had returned null, then return false
    }

    return WillPopScope(
      onWillPop: showExitPopup,
      //call function on back button press
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          brightness: Brightness.dark,
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          title: Text(
            'SPORTS FINDER',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Ubuntu',
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MessageList(),
                    ),
                  );
                  /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Message button pressed"),
                  ));*/
                },
                icon: Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: Colors.white,
                  size: 25,
                ),
                iconSize: 25,
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          mini: true,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateWidget(),
              ),
            );
          },
          child: Icon(Icons.add),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: TextFormField(
                        onChanged: (_) => setState(() {
                          if (searchFieldController.text.isEmpty) {
                            key = searchFieldController.text;
                            query = firestore
                                .collection("games")
                                .where("game_full", isEqualTo: "false")
                                .where("game_finish", isEqualTo: "false")
                                .where("gameDetails.date", isGreaterThanOrEqualTo: Timestamp(_startDateSecond, 0))
                                .where("gameDetails.date", isLessThanOrEqualTo: Timestamp(_lastStartDateSecond, 0))
                                .orderBy("gameDetails.date");
                          } else {
                            key = searchFieldController.text;
                            query = firestore
                                .collection("games")
                                .where("search_param",
                                    arrayContains: searchFieldController.text
                                        .toLowerCase())
                                .where("game_full", isEqualTo: "false")
                                .where("game_finish", isEqualTo: "false")
                                .where("gameDetails.date", isGreaterThanOrEqualTo: Timestamp(_startDateSecond, 0))
                                .where("gameDetails.date", isLessThanOrEqualTo: Timestamp(_lastStartDateSecond, 0))
                                .orderBy("gameDetails.date");
                          }
                        }),
                        controller: searchFieldController,
                        obscureText: false,
                        decoration: InputDecoration(
                          isDense: true,
                          labelText: 'Search ',
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
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: Color(0xFF8B97A2),
                            size: 20,
                          ),
                          suffixIcon: searchFieldController.text.isNotEmpty
                              ? InkWell(
                                  onTap: () {
                                    setState(() {
                                      searchFieldController.clear();
                                      key = searchFieldController.text;
                                      query = firestore
                                          .collection("games")
                                          .where("game_full",
                                              isEqualTo: "false")
                                          .where("game_finish",
                                              isEqualTo: "false")
                                          .where("gameDetails.date", isGreaterThanOrEqualTo: Timestamp(_startDateSecond, 0))
                                          .where("gameDetails.date", isLessThanOrEqualTo: Timestamp(_lastStartDateSecond, 0))
                                          .orderBy("gameDetails.date");
                                    });
                                  },
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
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 16, 0, 0),
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
              Flexible(
                child: PaginateFirestore(
                  //item builder type is compulsory.
                  itemBuilder: (index, context, documentSnapshot) {
                    final data = documentSnapshot.data() as Map?;
                    if (data != null) {
                      return _buildGame(
                          context: context,
                          data: data,
                          id: documentSnapshot.id, type: 0);
                    } else {
                      print(data);
                      return Text(
                        "You didn't join any game(s)",
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
                      .collection("games")
                      .where("joined", arrayContains: uid)
                      .where("game_finish", isEqualTo: "false")
                      .where("gameDetails.date", isGreaterThanOrEqualTo: Timestamp(_startDateSecond, 0))
                      .where("gameDetails.date", isLessThanOrEqualTo: Timestamp(_lastStartDateSecond, 0))
                      .orderBy("gameDetails.date"),
                  //Change types accordingly
                  itemBuilderType: PaginateBuilderType.listView,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  emptyDisplay: Text(
                    "You didn't join any game(s)",
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
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 16, 0, 0),
                    child: Text(
                      'Available',
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
                      return _buildGame(
                          context: context,
                          data: data,
                          id: documentSnapshot.id, type: 1);
                    } else {
                      return Text(
                        "No game(s) available",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Color(0xFF8B97A2),
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }
                  },
                  key: ValueKey<String>(key),
                  // orderBy is compulsory to enable pagination
                  query: query,
                  //Change types accordingly
                  itemBuilderType: PaginateBuilderType.listView,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  emptyDisplay: Text(
                    "No game(s) available",
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
        drawer: AppDrawer(
          currentView: 'Home',
        ),
      ),
    );
  }
}
