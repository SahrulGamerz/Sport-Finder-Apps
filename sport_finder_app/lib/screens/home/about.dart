import 'package:flutter/material.dart';
import 'package:sport_finder_app/widgets/drawer.dart';

class About extends StatelessWidget {
  //const About({Key? key}) : super(key: key);
  static const String routeName = '/about';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sport Finder App',
      home: Scaffold(
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
        drawer: AppDrawer(currentView: 'About'),
        body: const Center(
          child: Text('About Page!'),
        ),
      ),
    );
  }
}
