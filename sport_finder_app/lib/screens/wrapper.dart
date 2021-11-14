import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sport_finder_app/models/user.dart';
import 'package:sport_finder_app/routes/routes.dart';
import 'package:sport_finder_app/screens/admin/list_users.dart';
import 'package:sport_finder_app/screens/authenticate/authenticate.dart';

import 'home/about.dart';
import 'home/settings/payment/payment_history.dart';
import 'home/settings/settings.dart';
import 'home/venue/booking_venue.dart';
import 'home/contact.dart';
import 'home/profile/edit_profile.dart';
import 'home/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserInfoRetrieve?>(context);
    //return either Home or Authenticate Widget
    if (user == null) {
      return Authenticate(toggleView: 0);
    } else if (!user.emailVerified) {
      return Authenticate(toggleView: 2);
    } else {
      return MaterialApp(
          title: 'Sports Finder App',
          theme:
              ThemeData(primaryColor: Colors.grey, accentColor: Colors.white),
          initialRoute: Routes.home,
          routes: {
            Routes.home: (context) => Home(),
            Routes.bookingVenue: (context) => BookingVenue(),
            Routes.editProfile: (context) => EditProfile(),
            Routes.about: (context) => About(),
            Routes.contact: (context) => Contact(),
            Routes.paymentHistory: (context) => PaymentHistory(),
            Routes.settings: (context) => SettingsWidget(),
            Routes.listofuser: (context) => ListOfUserWidget(),
          });
    }
  }
}
