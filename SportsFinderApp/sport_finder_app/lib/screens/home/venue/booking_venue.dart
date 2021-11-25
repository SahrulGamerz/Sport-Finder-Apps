import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';
import 'package:sport_finder_app/screens/home/venue/venue.dart';
import 'package:sport_finder_app/widgets/drawer.dart';

class BookingVenue extends StatefulWidget {
  const BookingVenue({Key? key}) : super(key: key);

  static const String routeName = '/booking_venue';

  @override
  _BookingVenueState createState() => _BookingVenueState();
}

class _BookingVenueState extends State<BookingVenue> {
  late TextEditingController search;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late Future query;
  late String key;
  List<LatLng> markers = [];
  List id = [];
  late Iterable<Widget> markerWidgets;

  @override
  void initState() {
    super.initState();
    search = TextEditingController();
    key = "";
    query = FirebaseFirestore.instance.collection('locations').get();
  }

  final controller = MapController(
    location: LatLng(3.0311231, 101.7603368),
  );

  void _onDoubleTap() {
    controller.zoom += 0.5;
    setState(() {});
  }

  Offset? _dragStart;
  double _scaleStart = 1.0;

  void _onScaleStart(ScaleStartDetails details) {
    _dragStart = details.focalPoint;
    _scaleStart = 1.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final scaleDiff = details.scale - _scaleStart;
    _scaleStart = details.scale;

    if (scaleDiff > 0) {
      controller.zoom += 0.02;
      setState(() {});
    } else if (scaleDiff < 0) {
      controller.zoom -= 0.02;
      setState(() {});
    } else {
      final now = details.focalPoint;
      final diff = now - _dragStart!;
      _dragStart = now;
      controller.drag(diff.dx, diff.dy);
      setState(() {});
    }
  }

  Widget _buildMarkerWidget(
      BuildContext context, Offset pos, LatLng pos2, String id, Color color,
      [IconData icon = Icons.location_on]) {
    return Positioned(
      left: pos.dx - 24,
      top: pos.dy - 24,
      width: 48,
      height: 48,
      child: GestureDetector(
        child: Icon(
          icon,
          color: color,
          size: 48,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VenueWidget(cid: id),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMapWidget(BuildContext context) {
    return new FutureBuilder(
        key: ValueKey<String>(key),
        future: query,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            int count = 0;
            markers = [];
            List dataId = [];
            QuerySnapshot documents = snapshot.data as QuerySnapshot;
            List<DocumentSnapshot> docs = documents.docs;
            if (docs.length > 0) {
              return Container(
                height: MediaQuery.of(context).size.height * 1,
                decoration: BoxDecoration(),
                child: MapLayoutBuilder(
                  controller: controller,
                  builder: (context, transformer) {
                    docs.forEach((data) {
                      LatLng latLng = new LatLng(
                          data["latlong"].latitude, data["latlong"].longitude);
                      markers.add(latLng);
                      dataId.add(data.id);
                      final markerPositions = markers
                          .map(transformer.fromLatLngToXYCoords)
                          .toList();
                      markerWidgets = markerPositions.map((pos) {
                        count++;
                        return _buildMarkerWidget(
                            context,
                            pos,
                            transformer.fromXYCoordsToLatLng(pos),
                            dataId[count - 1],
                            Colors.red);
                      });
                    });

                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onDoubleTap: _onDoubleTap,
                      onScaleStart: _onScaleStart,
                      onScaleUpdate: _onScaleUpdate,
                      child: Listener(
                        behavior: HitTestBehavior.opaque,
                        onPointerSignal: (event) {
                          if (event is PointerScrollEvent) {
                            final delta = event.scrollDelta;

                            controller.zoom -= delta.dy / 1000.0;
                            setState(() {});
                          }
                        },
                        child: Stack(
                          children: [
                            Map(
                              controller: controller,
                              builder: (context, x, y, z) {
                                //Legal notice: This url is only used for demo and educational purposes. You need a license key for production use.
                                //Google Maps
                                final url =
                                    'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/$z/$x/$y'
                                    '?access_token=pk.eyJ1Ijoic2FocnVsMDEyIiwiYSI6ImNrbGFrMmdqYjBpOWMycHRrYnpjYnAxb3UifQ.D3EotTV9rjSdahySy3FeBg';
                                return CachedNetworkImage(
                                  imageUrl: url,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                            ...markerWidgets,
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return Container(
                height: MediaQuery.of(context).size.height * 1,
                decoration: BoxDecoration(),
                child: MapLayoutBuilder(
                  controller: controller,
                  builder: (context, transformer) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onDoubleTap: _onDoubleTap,
                      onScaleStart: _onScaleStart,
                      onScaleUpdate: _onScaleUpdate,
                      child: Listener(
                        behavior: HitTestBehavior.opaque,
                        onPointerSignal: (event) {
                          if (event is PointerScrollEvent) {
                            final delta = event.scrollDelta;

                            controller.zoom -= delta.dy / 1000.0;
                            setState(() {});
                          }
                        },
                        child: Stack(
                          children: [
                            Map(
                              controller: controller,
                              builder: (context, x, y, z) {
                                //Legal notice: This url is only used for demo and educational purposes. You need a license key for production use.
                                //Google Maps
                                final url =
                                    'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/$z/$x/$y'
                                    '?access_token=pk.eyJ1Ijoic2FocnVsMDEyIiwiYSI6ImNrbGFrMmdqYjBpOWMycHRrYnpjYnAxb3UifQ.D3EotTV9rjSdahySy3FeBg';
                                return CachedNetworkImage(
                                  imageUrl: url,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          'BOOKING VENUE',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Ubuntu',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Color(0xFFEFEFEF),
      drawer: AppDrawer(
        currentView: 'BookingVenue',
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Stack(
              children: [
                Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: _buildMapWidget(context),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                      child: Material(
                        color: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 2,
                                color: Color(0x4E000000),
                                offset: Offset(0, 4),
                              )
                            ],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Color(0xFFEEEEEE),
                              width: 2,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      4, 0, 4, 0),
                                  child: Icon(
                                    Icons.search_rounded,
                                    color: Color(0xFF95A1AC),
                                    size: 24,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        4, 0, 0, 0),
                                    child: TextFormField(
                                      controller: search,
                                      onChanged: (_) => setState(() {
                                        if (search.text.isEmpty) {
                                          key = search.text;
                                          query = FirebaseFirestore.instance
                                              .collection('locations')
                                              .get();
                                        } else {
                                          key = search.text;
                                          query = FirebaseFirestore.instance
                                              .collection('locations')
                                              .where("search_param",
                                                  arrayContains:
                                                      search.text.toLowerCase())
                                              .get();
                                        }
                                      }),
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelText: 'Search',
                                        labelStyle: TextStyle(
                                          fontFamily: 'Lexend Deca',
                                          color: Color(0xFF95A1AC),
                                          fontSize: 14,
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
                                        color: Color(0xFF95A1AC),
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: AlignmentDirectional(0.95, 0),
                                    child: Icon(
                                      Icons.tune_rounded,
                                      color: Color(0xFF95A1AC),
                                      size: 24,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
