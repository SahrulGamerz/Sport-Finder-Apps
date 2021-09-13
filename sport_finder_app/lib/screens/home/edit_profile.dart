import 'dart:async';
import 'dart:io' as io;
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sport_finder_app/services/auth.dart';
import 'package:sport_finder_app/widgets/drawer.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);
  static const String routeName = '/profile/editProfile';

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController username;
  late TextEditingController email;
  late TextEditingController playerType;
  late TextEditingController bio;
  late TextEditingController phoneNumber;
  late TextEditingController password;
  late TextEditingController confirmPassword;
  late bool passwordVis;
  late bool confirmPasswordVis;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthService _auth = AuthService();
  late FToast fToast;
  late String profilePicture;
  late String backgroundImage;
  late String uid;
  int timestampBG = DateTime.now().millisecondsSinceEpoch;
  int timestampPP = DateTime.now().millisecondsSinceEpoch;
  XFile? _imageFile;
  bool _buttonEnabled = true;
  late String type1;

  @override
  void initState() {
    super.initState();
    username = TextEditingController();
    email = TextEditingController();
    playerType = TextEditingController();
    bio = TextEditingController();
    phoneNumber = TextEditingController();
    password = TextEditingController();
    passwordVis = false;
    confirmPassword = TextEditingController();
    confirmPasswordVis = false;
    fToast = FToast();
    fToast.init(context);
  }

  void _openCamera(BuildContext context, type) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      _imageFile = pickedFile;
      type1 = type;
    });
    Navigator.pop(context);
  }

  void _openGallery(BuildContext context, type) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _imageFile = pickedFile;
      type1 = type;
    });

    Navigator.pop(context);
  }

  Future<void> _showChoiceDialog(BuildContext context, type) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Choose option",
              style: TextStyle(color: Colors.blue),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _openGallery(context, type);
                    },
                    title: Text("Gallery"),
                    leading: Icon(
                      Icons.account_box,
                      color: Colors.blue,
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _openCamera(context, type);
                    },
                    title: Text("Camera"),
                    leading: Icon(
                      Icons.camera,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future uploadImageToFirebase(BuildContext context, type) async {
    _buttonEnabled = false;
    String fileName = path.basename(_imageFile!.path);
    String extension = path.extension(fileName);
    String newName = uid + "_" + type + extension;
    print(_imageFile!.path);
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users')
        .child(uid)
        .child('/$newName');
    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': newName});
    firebase_storage.UploadTask uploadTask;
    //late StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    uploadTask = ref.putFile(io.File(_imageFile!.path), metadata);

    //firebase_storage.UploadTask task = await Future.value(uploadTask);
    await Future.value(uploadTask).then((value) async {
      if (type == "BG") {
        String downloadURL = await firebase_storage.FirebaseStorage.instance
            .ref(value.ref.fullPath)
            .getDownloadURL();
        setState(() {
          backgroundImage = downloadURL;
          timestampBG = DateTime.now().millisecondsSinceEpoch;
        });
      } else {
        String downloadURL = await firebase_storage.FirebaseStorage.instance
            .ref(value.ref.fullPath)
            .getDownloadURL();
        setState(() {
          profilePicture = downloadURL;
          timestampPP = DateTime.now().millisecondsSinceEpoch;
        });
      }
      print("Upload file path ${value.ref.fullPath}");
    }).onError((error, stackTrace) {
      print("Upload file path error ${error.toString()} ");
      _showToastError(context, "Upload failed!\nPlease try again!");
      _buttonEnabled = true;
    });
  }

  Future getUserData() async {
    Map<String, dynamic> data = await _auth.getUserData();
    backgroundImage = data['background_image'];
    profilePicture = data['profile_picture'];
    username.text = data['username'];
    email.text = data['email'];
    bio.text = data['bio'];
    phoneNumber.text = data['phoneNumber'];
    playerType.text = data['playerType'];
    uid = data['uid'];
    return true;
  }

  Future<void> _showReLogDialog(BuildContext context) {
    TextEditingController emailR = TextEditingController();
    TextEditingController passwordR = TextEditingController();
    bool passwordRVisibility = false;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Please enter your credential",
              style: TextStyle(color: Colors.blue),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  TextFormField(
                    controller: emailR,
                    obscureText: false,
                    decoration: InputDecoration(
                      hintText: 'Email Address',
                      hintStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      filled: true,
                      fillColor: Color(0x00FFFFFF),
                      contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  TextFormField(
                    controller: passwordR,
                    obscureText: !passwordRVisibility,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.black,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      filled: true,
                      fillColor: Color(0x00FFFFFF),
                      contentPadding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                      prefixIcon: Icon(
                        Icons.https_outlined,
                      ),
                      suffixIcon: InkWell(
                        onTap: () => setState(
                          () => passwordRVisibility = !passwordRVisibility,
                        ),
                        child: Icon(
                          passwordRVisibility
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Color(0xFF757575),
                          size: 22,
                        ),
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.start,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      dynamic result = await _auth.reAuthenticateUser(
                          emailR.text, passwordR.text);
                      if (result) {
                        Navigator.of(context).pop(false);
                      }
                    },
                    child: Text('ReLog'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _showToastSuccess(BuildContext context, String text) {
    fToast.init(context);
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
          Text(text),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  _showToastWarning(BuildContext context, String text) {
    fToast.init(context);
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.orangeAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline),
          SizedBox(
            width: 12.0,
          ),
          Text(text),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  _showToastError(BuildContext context, String text) {
    fToast.init(context);
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.redAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline),
          SizedBox(
            width: 12.0,
          ),
          Text(text),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  bool isPasswordCompliant(String password, [int minLength = 8]) {
    if (password == null || password.isEmpty) {
      return false;
    }

    bool hasUppercase = password.contains(new RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(new RegExp(r'[0-9]'));
    bool hasLowercase = password.contains(new RegExp(r'[a-z]'));
    bool hasSpecialCharacters =
        password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    bool hasMinLength = password.length > minLength;

    return hasDigits &
        hasUppercase &
        hasLowercase &
        hasSpecialCharacters &
        hasMinLength;
  }

  Widget _editProfileStuff(BuildContext context) {
    return new FutureBuilder(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _showChoiceDialog(context, "BG");
                                    },
                                    child: Image.network(
                                      backgroundImage,
                                      key: ValueKey(timestampBG),
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(0, 1),
                                    child: Icon(
                                      Icons.circle,
                                      color: Colors.white,
                                      size: 145,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment(0, 0.7),
                                    child: Container(
                                      width: 110,
                                      height: 110,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.network(
                                        profilePicture,
                                        key: ValueKey(timestampPP),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Color(0xFF002A97),
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Edit profile picture',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Colors.lightBlueAccent,
                                        fontSize: 12,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          _showChoiceDialog(context, "PP");
                                        }),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Align(
                      alignment: Alignment(0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Username :',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Expanded(
                                    child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 18, 0, 0),
                                  child: TextFormField(
                                    controller: username,
                                    obscureText: false,
                                    maxLength: 16,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      labelStyle: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Colors.black,
                                        fontSize: 17,
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.black,
                                      fontSize: 17,
                                    ),
                                    keyboardType: TextInputType.name,
                                  ),
                                )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Email          :',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: email,
                                    obscureText: false,
                                    enabled: false,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      labelStyle: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Colors.black,
                                        fontSize: 17,
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1,
                                        ),
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0),
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.black,
                                      fontSize: 17,
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Player         :',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 18, 0, 0),
                                    child: TextFormField(
                                      controller: playerType,
                                      obscureText: false,
                                      maxLength: 16,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        labelStyle: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Colors.black,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Bio               :',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 18, 0, 0),
                                    child: TextFormField(
                                      controller: bio,
                                      obscureText: false,
                                      maxLength: 30,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        labelStyle: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Colors.black,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Contact      :',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 18, 0, 0),
                                    child: TextFormField(
                                      controller: phoneNumber,
                                      obscureText: false,
                                      maxLength: 16,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        labelStyle: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                      ),
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Colors.black,
                                        fontSize: 17,
                                      ),
                                      keyboardType: TextInputType.phone,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(50, 10, 50, 0),
                                  child: ArgonButton(
                                    height: 40,
                                    width: 130,
                                    borderRadius: 12.0,
                                    roundLoadingShape: true,
                                    color: Colors.black,
                                    child: Text(
                                      "Update",
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Colors.white,
                                        //fontSize: 18,
                                        //fontWeight: FontWeight.w700
                                      ),
                                    ),
                                    loader: Container(
                                      padding: EdgeInsets.all(10),
                                      child: SpinKitDoubleBounce(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: (startLoading, stopLoading,
                                        btnState) async {
                                      if (_buttonEnabled) {
                                        _buttonEnabled = false;
                                        startLoading();
                                        if (_imageFile != null) {
                                          if (type1 == "BG") {
                                            await uploadImageToFirebase(
                                                context, "BG");
                                          } else {
                                            await uploadImageToFirebase(
                                                context, "PP");
                                          }
                                        }
                                        Timer.periodic(new Duration(seconds: 1),
                                            (timer) {
                                          if (timer.tick.toInt() == 10) {
                                            timer.cancel();
                                            _buttonEnabled = true;
                                          }
                                        });
                                        bool result =
                                            await _auth.updateUserData(
                                                username.text,
                                                bio.text,
                                                phoneNumber.text,
                                                playerType.text,
                                                profilePicture,
                                                backgroundImage);
                                        print(result);
                                        if (result) {
                                          _showToastSuccess(context,
                                              "Profile updated successfully!");
                                          stopLoading();
                                        } else {
                                          _showToastError(context,
                                              "Profile update failed!");
                                          stopLoading();
                                        }
                                      } else {
                                        _showToastWarning(context,
                                            "Please wait 10 seconds before trying!");
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'New Password     :',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 18, 0, 0),
                                    child: TextFormField(
                                      controller: password,
                                      obscureText: !passwordVis,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        labelStyle: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        suffixIcon: InkWell(
                                          onTap: () => setState(
                                            () => passwordVis = !passwordVis,
                                          ),
                                          child: Icon(
                                            passwordVis
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            color: Color(0xFF757575),
                                            size: 17,
                                          ),
                                        ),
                                      ),
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Colors.black,
                                        fontSize: 17,
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Confirm Password :',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 18, 0, 0),
                                    child: TextFormField(
                                      controller: confirmPassword,
                                      obscureText: !confirmPasswordVis,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        labelStyle: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Colors.black,
                                          fontSize: 17,
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0x00000000),
                                            width: 1,
                                          ),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4.0),
                                            topRight: Radius.circular(4.0),
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        suffixIcon: InkWell(
                                          onTap: () => setState(
                                            () => confirmPasswordVis =
                                                !confirmPasswordVis,
                                          ),
                                          child: Icon(
                                            confirmPasswordVis
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                            color: Color(0xFF757575),
                                            size: 17,
                                          ),
                                        ),
                                      ),
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Colors.black,
                                        fontSize: 17,
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(50, 10, 50, 0),
                                  child: ArgonButton(
                                    height: 40,
                                    width: 130,
                                    borderRadius: 12.0,
                                    roundLoadingShape: true,
                                    color: Colors.black,
                                    child: Text(
                                      "Change Password",
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Colors.white,
                                        //fontSize: 18,
                                        //fontWeight: FontWeight.w700
                                      ),
                                    ),
                                    loader: Container(
                                      padding: EdgeInsets.all(10),
                                      child: SpinKitDoubleBounce(
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: (startLoading, stopLoading,
                                        btnState) async {
                                      if (_buttonEnabled) {
                                        _buttonEnabled = false;
                                        startLoading();
                                        if (!isPasswordCompliant(
                                            password.text)) {
                                          stopLoading();
                                          _buttonEnabled = true;
                                          _showToastWarning(context,
                                              "Password does not meet the requirements.\nUpper & Lower case,\nSpecial characters,\nNumbers");
                                        } else if (password.text !=
                                            confirmPassword.text) {
                                          stopLoading();
                                          _buttonEnabled = true;
                                          _showToastWarning(context,
                                              "Password does not match!");
                                        } else {
                                          Timer.periodic(
                                              new Duration(seconds: 1),
                                              (timer) {
                                            if (timer.tick.toInt() == 10) {
                                              timer.cancel();
                                              _buttonEnabled = true;
                                            }
                                          });
                                          dynamic result = await _auth
                                              .changePassword(password.text);
                                          //print(result);
                                          if (result == "ReLog") {
                                            _showToastWarning(context,
                                                "Please enter your credential and try again!");
                                            stopLoading();
                                            _showReLogDialog(context);
                                          } else if (result) {
                                            _showToastSuccess(context,
                                                "Password changed successfully!");
                                            stopLoading();
                                          } else {
                                            _showToastError(context,
                                                "Password changed failed");
                                            stopLoading();
                                          }
                                        }
                                      } else {
                                        _showToastWarning(context,
                                            "Please wait 10 seconds before trying!");
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return new Text("An error occurred, Please try again!");
          }
          return new LinearProgressIndicator();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          'EDIT PROFILE',
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
      backgroundColor: Colors.white,
      drawer: AppDrawer(currentView: 'editProfile'),
      body: _editProfileStuff(context),
    );
  }
}
