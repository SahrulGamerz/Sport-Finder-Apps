import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sport_finder_app/widgets/drawer.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static const String routeName = '/home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late FToast fToast;

  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () => Navigator.of(context).pop(true),
                  //return true when click on "Yes"
                  child: Text('Yes'),
                ),
              ],
            ),
          ) ??
          false; //if showDialouge had returned null, then return false
    }

    return MaterialApp(
      title: 'Sport Finder App',
      home: WillPopScope(
        onWillPop: showExitPopup, //call function on back button press
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: IconThemeData(color: Colors.white),
            centerTitle: true,
            title: Text(
              'SPORTS FINDER',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Ubuntu',
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: IconButton(
                  onPressed: () {
                    print('IconButton pressed ...');
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
          body: const Center(
            child: Text('Home Page!'),
          ),
          drawer: AppDrawer(currentView: 'Home'),
        ),
      ),
    );
  }
}
