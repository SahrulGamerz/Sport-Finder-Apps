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
  XFile? _imageFileBG;
  XFile? _imageFilePP;
  bool _buttonEnabled = true;
  bool type0 = false;
  bool type1 = false;

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
      imageQuality: 80,
    );
    setState(() {
      if (type == "BG") {
        _imageFileBG = pickedFile;
        type0 = true;
      } else {
        _imageFilePP = pickedFile;
        type1 = true;
      }
    });
    Navigator.pop(context);
  }

  void _openGallery(BuildContext context, type) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    setState(() {
      if (type == "BG") {
        _imageFileBG = pickedFile;
        type0 = true;
      } else {
        _imageFilePP = pickedFile;
        type1 = true;
      }
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
    String fileName;
    if (type == "BG") {
      fileName = path.basename(_imageFileBG!.path);
    } else {
      fileName = path.basename(_imageFilePP!.path);
    }
    String extension = path.extension(fileName);
    String newName = uid + "_" + type + extension;
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

    if (type == "BG") {
      uploadTask = ref.putFile(io.File(_imageFileBG!.path), metadata);
    } else {
      uploadTask = ref.putFile(io.File(_imageFilePP!.path), metadata);
    }
    //firebase_storage.UploadTask task = await Future.value(uploadTask);
    await Future.value(uploadTask).then((value) async {
      if (type == "BG") {
        String downloadURL = await firebase_storage.FirebaseStorage.instance
            .ref(value.ref.fullPath)
            .getDownloadURL();
        backgroundImage = downloadURL;
      } else {
        String downloadURL = await firebase_storage.FirebaseStorage.instance
            .ref(value.ref.fullPath)
            .getDownloadURL();
        profilePicture = downloadURL;
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
                                              0.23,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      minRadius: 15,
                                      maxRadius: 55,
                                      child: CircleAvatar(
                                        key: ValueKey(timestampPP),
                                        backgroundColor: Colors.white,
                                        minRadius: 10,
                                        maxRadius: 50,
                                        backgroundImage:
                                            NetworkImage(profilePicture),
                                      ),
                                    ),
                                  ),
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
                                        if (_imageFileBG != null) {
                                          if (type0) {
                                            await uploadImageToFirebase(
                                                context, "BG");
                                          }
                                        }
                                        if (_imageFilePP != null) {
                                          if (type1) {
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
                                          setState(() {
                                            timestampPP = DateTime.now()
                                                .millisecondsSinceEpoch;
                                            timestampBG = DateTime.now()
                                                .millisecondsSinceEpoch;
                                          });
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
        actions: [],
      ),
      backgroundColor: Colors.white,
      drawer: AppDrawer(
        currentView: 'editProfile',
      ),
      body: _editProfileStuff(context),
    );
  }
}
