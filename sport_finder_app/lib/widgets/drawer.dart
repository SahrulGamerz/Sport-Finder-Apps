import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sport_finder_app/routes/routes.dart';
import 'package:sport_finder_app/services/auth.dart';

class AppDrawer extends StatefulWidget {
  //const AppDrawer({Key? key}) : super(key: key);
  final String currentView;

  AppDrawer({required this.currentView});

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  //const AppDrawer({Key? key}) : super(key: key);
  final AuthService _auth = AuthService();
  late FToast fToast;
  late String username;
  late String email;
  late String profilePicture;
  late String backgroundImage;
  late Map<String, dynamic> data;

  Future getUserData() async {
    data = await _auth.getUserData();
    backgroundImage = data['background_image'];
    profilePicture = data['profile_picture'];
    username = data['username'];
    email = data['email'];
    return true;
  }

  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  Widget _createHeader(context) {
    return new FutureBuilder(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: NetworkImage(backgroundImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.20,
                      height: MediaQuery.of(context).size.width * 0.20,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(profilePicture),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    username,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                  Text(
                    email,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Color(0xFF8B97A2),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return new DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: NetworkImage("https://picsum.photos/seed/857/600"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.20,
                      height: MediaQuery.of(context).size.width * 0.20,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(
                              "https://picsum.photos/seed/298/600"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "Error",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                  Text(
                    "Error",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Color(0xFF8B97A2),
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }
          return new LinearProgressIndicator();
        });
  }

  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      required GestureTapCallback onTap}) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.black,
      ),
      title: Text(
        text,
        style: TextStyle(
          fontFamily: 'Montserrat',
          color: Colors.black,
        ),
      ),
      onTap: onTap,
    );
  }

  void _showToast(String msg, Color backgroundColor, Color textColor) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: 16.0);
  }

/*
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
*/
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(context),
          _createDrawerItem(
              icon: Icons.home_outlined,
              text: "Home",
              onTap: () => {
                    Navigator.of(context).pop(),
                    if (widget.currentView != "Home")
                      {Navigator.pushNamed(context, Routes.home)}
                  }),
          _createDrawerItem(
              icon: Icons.location_city,
              text: "Booking Venue",
              onTap: () => {
                    Navigator.of(context).pop(),
                  }),
          _createDrawerItem(
              icon: Icons.person_outline,
              text: "Profile",
              onTap: () => {
                    Navigator.of(context).pop(),
                    if (widget.currentView != "editProfile")
                      {Navigator.pushNamed(context, Routes.editProfile)}
                  }),
          Divider(
            color: Colors.grey,
          ),
          _createDrawerItem(
              icon: Icons.people_outline,
              text: "About Us",
              onTap: () => {
                    Navigator.of(context).pop(),
                    if (widget.currentView != "About")
                      {Navigator.pushNamed(context, Routes.about)}
                  }),
          _createDrawerItem(
              icon: Icons.call_outlined,
              text: "Contact Us",
              onTap: () => {
                    Navigator.of(context).pop(),
                    if (widget.currentView != "Contact")
                      {Navigator.pushNamed(context, Routes.contact)}
                  }),
          Divider(
            color: Colors.grey,
          ),
          _createDrawerItem(
            icon: Icons.settings_outlined,
            text: "Settings",
            onTap: () => {
              Navigator.of(context).pop(),
            },
          ),
          _createDrawerItem(
              icon: Icons.logout,
              text: "Log Out",
              onTap: () async {
                Navigator.of(context).pop();
                //_showToastSignout();
                await _auth.signOut();
                _showToast("Logged Out!", Colors.greenAccent, Colors.black);
              }),
          Divider(
            color: Colors.grey,
          ),
          ListTile(
            title: Text('App Ver: 1.2.0'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
