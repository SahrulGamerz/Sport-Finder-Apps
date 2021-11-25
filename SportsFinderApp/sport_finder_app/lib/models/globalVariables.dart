bool isAdmin = false;
late String uid;
late String username;
// Payment information
String firstName = '';
String lastName = '';
String addressCity = '';
String addressStreet = '';
String addressZipCode = '';
String addressCountry = '';
String addressState = '';
String addressPhoneNumber = '';

bool checkPaymentInfo() {
  if (firstName == '') return false;
  if (lastName == '') return false;
  if (addressCity == '') return false;
  if (addressStreet == '') return false;
  if (addressZipCode == '') return false;
  if (addressCountry == '') return false;
  if (addressState == '') return false;
  if (addressPhoneNumber == '') return false;
  return true;
}
