import 'package:sport_finder_app/screens/admin/booking/create_booking_form.dart';
import 'package:sport_finder_app/screens/admin/booking/list_booking.dart';
import 'package:sport_finder_app/screens/admin/manageUsers/list_users.dart';
import 'package:sport_finder_app/screens/admin/report/generateReport.dart';
import 'package:sport_finder_app/screens/errors/loading.dart';
import 'package:sport_finder_app/screens/home/about.dart';
import 'package:sport_finder_app/screens/home/settings/payment/payment_history.dart';
import 'package:sport_finder_app/screens/home/settings/settings.dart';
import 'package:sport_finder_app/screens/home/venue/booking_venue.dart';
import 'package:sport_finder_app/screens/home/contact.dart';
import 'package:sport_finder_app/screens/home/message/message_list.dart';
import 'package:sport_finder_app/screens/home/profile/edit_profile.dart';
import 'package:sport_finder_app/screens/home/home.dart';

class Routes {
  static const String loading = Loading.routeName;
  static const String home = Home.routeName;
  static const String bookingVenue = BookingVenue.routeName;
  static const String editProfile = EditProfile.routeName;
  static const String about = About.routeName;
  static const String contact = Contact.routeName;
  static const String message = MessageList.routeName;
  static const String paymentHistory = PaymentHistory.routeName;
  static const String settings = SettingsWidget.routeName;
  static const String listofuser = ListOfUserWidget.routeName;
  static const String bookingList = ViewBookingWidget.routeName;
  static const String createBooking = CreateBookingWidget.routeName;
  static const String generateReport = GenerateReportWidget.routeName;
}