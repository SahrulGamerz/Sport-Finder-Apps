import 'package:flutter/material.dart';
import 'package:sport_finder_app/services/auth.dart';
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
    return Scaffold(
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
                Icons.message,
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
      drawer: AppDrawer(),
    );
  }
}

