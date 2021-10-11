import 'package:flutter/material.dart';

class MessageViewPicture extends StatefulWidget {
  final String url;

  const MessageViewPicture({Key? key, required this.url}) : super(key: key);

  @override
  _MessageViewPictureState createState() => _MessageViewPictureState();
}

class _MessageViewPictureState extends State<MessageViewPicture> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
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
          "",
          style: TextStyle(
            fontFamily: 'Ubuntu',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [],
        elevation: 4,
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true, // Set it to false
          minScale: 1,
          maxScale: 5,
          child: Image.network(
            widget.url,
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ),
      ),
    );
  }
}
