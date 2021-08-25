import 'package:flutter/material.dart';
import 'package:sport_finder_app/services/auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  late FToast fToast;
  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }
  _showToastSignout() {
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
          Text("Logged Out!"),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
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
        child: Text('My Page!'),
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: NetworkImage('https://picsum.photos/seed/857/600'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0,0,0,10),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.20,
                      height: MediaQuery.of(context).size.width * 0.20,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage('https://picsum.photos/seed/298/600'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Awieknd',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                  Text(
                    'awiecomeii@gmail.com',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Color(0xFF8B97A2),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.home_outlined,
                      color: Colors.black,
                    ),
                    title: const Text(
                      'Home',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.location_city,
                      color: Colors.black,
                    ),
                    title: const Text(
                      'Booking Venue',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.person_outline,
                      color: Colors.black,
                    ),
                    title: const Text(
                      'Profile',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.settings_outlined,
                      color: Colors.black,
                    ),
                    title: const Text(
                      'Settings',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.people_outline,
                      color: Colors.black,
                    ),
                    title: const Text(
                      'About Us',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.call_outlined,
                      color: Colors.black,
                    ),
                    title: const Text(
                      'Contact Us',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Colors.black,
                    ),
                    title: const Text(
                      'Log Out',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                      ),
                    ),
                    onTap: () async {
                      await _auth.signOut();
                      _showToastSignout();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

