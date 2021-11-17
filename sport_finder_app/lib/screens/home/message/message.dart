import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:sport_finder_app/models/globalVariables.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io' as io;
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

import 'message_view_picture.dart';

class Message extends StatefulWidget {
  final String chatName, chatId;

  const Message({Key? key, required this.chatName, required this.chatId})
      : super(key: key);

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  late TextEditingController textController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late FToast fToast;
  bool btnState = true;
  bool imgState = true;
  bool emojiShowing = false;
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    fToast = FToast();
    fToast.init(context);
  }

  /*_showToastSuccess({required BuildContext context, required String msg}) {
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
          Text(msg),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  _showToastWarning({required BuildContext context, required String msg}) {
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
          Text(msg),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }*/

  _showToastError({required BuildContext context, required String msg}) {
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
          Icon(Icons.highlight_off),
          SizedBox(
            width: 12.0,
          ),
          Text(msg),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    setState(() {
      _imageFile = pickedFile;
    });
    Navigator.pop(context);
  }

  void _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    setState(() {
      _imageFile = pickedFile;
    });

    Navigator.pop(context);
  }

  Future<void> _showChoiceDialog(BuildContext context) {
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
                      _openGallery(context);
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
                      _openCamera(context);
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

  Future<String> uploadImageToFirebase(BuildContext context) async {
    String fileName = path.basename(_imageFile!.path);
    String extension = path.extension(fileName);
    String newName = widget.chatId +
        "-" +
        DateTime.now().millisecondsSinceEpoch.toString() +
        extension;
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('messages')
        .child(widget.chatId)
        .child('/$newName');
    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': newName});
    firebase_storage.UploadTask uploadTask;
    //late StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);

    uploadTask = ref.putFile(io.File(_imageFile!.path), metadata);
    //firebase_storage.UploadTask task = await Future.value(uploadTask);
    String downloadURL = "";
    await Future.value(uploadTask).then((value) async {
      downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref(value.ref.fullPath)
          .getDownloadURL();
      print("Upload file path ${value.ref.fullPath}");
      return downloadURL;
    }).onError((error, stackTrace) {
      print("Upload file path error ${error.toString()} ");
      _showToastError(
          context: context, msg: "Upload failed!\nPlease try again!");
      return "false";
    });
    return downloadURL;
  }

  Future<bool> sendMessage({required String msg}) async {
    bool sendState = false, updateState = false;
    DateTime now = DateTime.now();
    //send message
    CollectionReference msgSRef = firestore
        .collection('messages')
        .doc(widget.chatId)
        .collection("messages");
    await msgSRef
        .doc()
        .set({
          'uid': uid,
          "timestamp": now,
          "msg": msg,
        })
        .then(
          (value) => sendState = true,
        )
        .catchError((error) {
          print("Failed to send msg: $error");
          return sendState;
        });

    //update message
    CollectionReference msgIRef = firestore.collection('messages');
    await msgIRef
        .doc(widget.chatId)
        .update({
          "chatName": widget.chatName,
          "last_updated": now,
          "last_message": msg,
        })
        .then((value) => updateState = true)
        .catchError((error) {
          print("Failed to update msg: $error");
          return updateState;
        });

    return sendState & updateState;
  }

  Widget _buildMessage(
      {required BuildContext context, required Map data, required String id}) {
    String pattern =
        r'(https://firebasestorage.googleapis.com\/v0\/b\/sport-finder-app.appspot.com)';
    RegExp regExp = new RegExp(pattern);
    if (data['uid'] == uid) {
      if (regExp.hasMatch(data['msg'])) {
        return Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 5, 5, 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                    shape: BoxShape.rectangle,
                  ),
                  child: InkWell(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            data['msg'],
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.35,
                            height: MediaQuery.of(context).size.height * 0.25,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MessageViewPicture(url: data['msg']),
                          ),
                        );
                      })),
            ],
          ),
        );
      } else {
        return Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 5, 5, 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  shape: BoxShape.rectangle,
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 5, 10, 5),
                  child: Text(
                    data['msg'],
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }
    } else {
      if (regExp.hasMatch(data['msg'])) {
        return Padding(
          padding: EdgeInsetsDirectional.fromSTEB(5, 5, 0, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF404040),
                    borderRadius: BorderRadius.circular(20),
                    shape: BoxShape.rectangle,
                  ),
                  child: InkWell(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            data['msg'],
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.35,
                            height: MediaQuery.of(context).size.height * 0.25,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MessageViewPicture(url: data['msg']),
                          ),
                        );
                      })),
            ],
          ),
        );
      } else {
        return Padding(
          padding: EdgeInsetsDirectional.fromSTEB(5, 5, 0, 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  color: Color(0xFF404040),
                  borderRadius: BorderRadius.circular(20),
                  shape: BoxShape.rectangle,
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 5, 10, 5),
                  child: Text(
                    data['msg'],
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }
    }
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
          widget.chatName,
          style: TextStyle(
            fontFamily: 'Ubuntu',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [],
        elevation: 4,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: PaginateFirestore(
              //item builder type is compulsory.
              itemBuilder: (index, context, documentSnapshot) {
                final data = documentSnapshot.data() as Map?;
                if (data != null) {
                  return _buildMessage(
                      context: context, data: data, id: documentSnapshot.id);
                } else {
                  print(data);
                  return Text(
                    "No Message",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: Color(0xFF8B97A2),
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }
              },
              // orderBy is compulsory to enable pagination
              query: firestore
                  .collection("messages")
                  .doc(widget.chatId)
                  .collection("messages")
                  .orderBy("timestamp", descending: true),
              //Change types accordingly
              itemBuilderType: PaginateBuilderType.listView,
              shrinkWrap: true,
              reverse: true,
              itemsPerPage: 10,
              emptyDisplay: Text(
                "No Messages",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Color(0xFF8B97A2),
                  fontWeight: FontWeight.w500,
                ),
              ),
              // to fetch real-time data
              isLive: true,
            ),
          ),
          //
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 5, 10, 5),
            child: Material(
              color: Colors.black,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    InkWell(
                        borderRadius: BorderRadius.circular(50),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                          child: Icon(
                            Icons.emoji_emotions,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            emojiShowing = !emojiShowing;
                          });
                        }),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                        child: TextFormField(
                          controller: textController,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                              fontFamily: 'Lexend Deca',
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                            hintText: 'Type here...',
                            hintStyle: TextStyle(
                              fontFamily: 'Lexend Deca',
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                            helperStyle: TextStyle(
                              fontFamily: 'Lexend Deca',
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
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
                          ),
                          style: TextStyle(
                            fontFamily: 'Lexend Deca',
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(50),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                        child: Align(
                          alignment: AlignmentDirectional(1, 0),
                          child: Icon(
                            Icons.photo_camera,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      onTap: () async {
                        await _showChoiceDialog(context);
                        if (_imageFile != null) {
                          String imgUrl = await uploadImageToFirebase(context);
                          if (imgUrl != "false")
                            sendMessage(msg: imgUrl);
                          else
                            _showToastError(
                                context: context,
                                msg: "Failed to upload image!");
                        }
                      },
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(50),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                        child: Align(
                          alignment: AlignmentDirectional(1, 0),
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      onTap: () async {
                        if (!btnState) return;
                        if (textController.text.length > 0) {
                          btnState = false;
                          bool status =
                              await sendMessage(msg: textController.text);
                          if (status) {
                            textController.text = "";
                            btnState = true;
                            return;
                          }
                          btnState = true;
                          _showToastError(
                              context: context, msg: "Message failed to send!");
                          return;
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          //
          Offstage(
            offstage: !emojiShowing,
            child: SizedBox(
              height: 250,
              child: EmojiPicker(
                  onEmojiSelected: (Category category, Emoji emoji) {
                    textController
                      ..text += emoji.emoji
                      ..selection = TextSelection.fromPosition(
                          TextPosition(offset: textController.text.length));
                  },
                  onBackspacePressed: () {
                    textController
                      ..text =
                          textController.text.characters.skipLast(1).toString()
                      ..selection = TextSelection.fromPosition(
                          TextPosition(offset: textController.text.length));
                  },
                  config: Config(
                      columns: 7,
                      // Issue: https://github.com/flutter/flutter/issues/28894
                      emojiSizeMax: 32 * (io.Platform.isIOS ? 1.30 : 1.0),
                      verticalSpacing: 0,
                      horizontalSpacing: 0,
                      initCategory: Category.RECENT,
                      bgColor: const Color(0xFFF2F2F2),
                      indicatorColor: Colors.blue,
                      iconColor: Colors.grey,
                      iconColorSelected: Colors.blue,
                      progressIndicatorColor: Colors.blue,
                      backspaceColor: Colors.blue,
                      showRecentsTab: true,
                      recentsLimit: 28,
                      noRecentsText: 'No Recent',
                      noRecentsStyle:
                          const TextStyle(fontSize: 20, color: Colors.black26),
                      tabIndicatorAnimDuration: kTabScrollDuration,
                      categoryIcons: const CategoryIcons(),
                      buttonMode: ButtonMode.MATERIAL)),
            ),
          ),
        ],
      ),
    );
  }
}
