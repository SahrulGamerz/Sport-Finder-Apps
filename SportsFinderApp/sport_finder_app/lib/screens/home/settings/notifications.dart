import 'package:flutter/material.dart';

class NotificationWidget extends StatefulWidget {
  NotificationWidget({Key? key}) : super(key: key);
  static const String routeName = '/settings/notifications';

  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  bool switchListTileValue1 = true;
  bool switchListTileValue2 = true;
  bool switchListTileValue3 = true;
  final scaffoldKey = GlobalKey<ScaffoldState>();

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
          'NOTIFICATIONS',
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
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Text(
                    'Choose what notifications you want to receive below and we will update the settings.',
                    style: TextStyle(
                      fontFamily: 'Lexend Deca',
                      color: Color(0xFF8B97A2),
                      fontSize: 1,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
            child: SwitchListTile.adaptive(
              value: switchListTileValue1,
              onChanged: (newValue) =>
                  setState(() => switchListTileValue1 = newValue),
              title: Text(
                'Push Notifications',
                style: TextStyle(
                  fontFamily: 'Lexend Deca',
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Receive Push notifications from our application on a semi regular basis.',
                style: TextStyle(
                  fontFamily: 'Lexend Deca',
                  color: Color(0xFF8B97A2),
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              activeColor: Colors.black,
              activeTrackColor: Colors.cyan,
              dense: false,
              controlAffinity: ListTileControlAffinity.trailing,
              contentPadding: EdgeInsetsDirectional.fromSTEB(24, 12, 24, 12),
            ),
          ),
          SwitchListTile.adaptive(
            value: switchListTileValue2,
            onChanged: (newValue) =>
                setState(() => switchListTileValue2 = newValue),
            title: Text(
              'Email Notifications',
              style: TextStyle(
                fontFamily: 'Lexend Deca',
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Receive email notifications from our marketing team about new features.',
              style: TextStyle(
                fontFamily: 'Lexend Deca',
                color: Color(0xFF8B97A2),
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
            activeColor: Colors.black,
            activeTrackColor: Colors.cyan,
            dense: false,
            controlAffinity: ListTileControlAffinity.trailing,
            contentPadding: EdgeInsetsDirectional.fromSTEB(24, 12, 24, 12),
          ),
          SwitchListTile.adaptive(
            value: switchListTileValue3,
            onChanged: (newValue) =>
                setState(() => switchListTileValue3 = newValue),
            title: Text(
              'Location Services',
              style: TextStyle(
                fontFamily: 'Lexend Deca',
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Allow us to track your location, this helps keep track of spending and keeps you safe.',
              style: TextStyle(
                fontFamily: 'Lexend Deca',
                color: Color(0xFF8B97A2),
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
            activeColor: Colors.black,
            activeTrackColor: Colors.cyan,
            dense: false,
            controlAffinity: ListTileControlAffinity.trailing,
            contentPadding: EdgeInsetsDirectional.fromSTEB(24, 12, 24, 12),
          )
        ],
      ),
    );
  }
}