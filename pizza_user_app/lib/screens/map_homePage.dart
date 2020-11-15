import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pizza_user_app/app_config/constant.dart';
import 'package:pizza_user_app/helper/distance_counter.dart';
import 'package:pizza_user_app/helper/helper.dart';
import 'package:pizza_user_app/screens/shop_details.dart';
import 'package:pizza_user_app/widget_utils/display_rating.dart';
import 'package:pizza_user_app/widget_utils/navigation.dart';

class MapHomePage extends StatefulWidget {
  final int distanceRange;
  final String search;

  MapHomePage(this.distanceRange, this.search);

  @override
  MapHomePageState createState() => MapHomePageState();
}

class MapHomePageState extends State<MapHomePage> {
  Completer<GoogleMapController> _controller = Completer();

  displayShopDetails() async {
    return Firestore.instance
        .collection('shopDetails')
    .where('pizzaShopName', isEqualTo: widget.search)
        .orderBy('rating')
        .snapshots();
  }
  bool isLoading = true;
  List<DocumentSnapshot> shopsData = [];
  List<Marker> marker = [];

  var _lat;
  var _lng;

  @override
  void initState() {
    Timer(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
    HelperFunctions.getLat().then((value) {
      print("Lat");
      print(_lat);
      _lat = value;
      setState(() {});
    });
    HelperFunctions.getLng().then((value) {
      _lng = value;
      setState(() {});
    });
    shopsData.clear();
    displayShopDetails().then((val) {
      val.listen((QuerySnapshot val) {
        val.documents.forEach((element) {
print(element.data);
          if (countDistance(element.data['location']['lat'],
                  element.data['location']['long'], _lat, _lng) <=
              widget.distanceRange) {
            shopsData.add(element);
          }
        });
      });

      setState(() {});
    }).then((_) {});
    super.initState();
  }

  getShopData() {
    shopsData.forEach((element) {
      shopsData.forEach((element) {
        marker.add(Marker(
            markerId: MarkerId(element.data['docID']),
            position: LatLng(element.data['location']['lat'],
                element.data['location']['long']),
            infoWindow: InfoWindow(title: element.data['pizzaShopName']),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueViolet,
            )));
        setState(() {});
      });
      setState(() {});
    });
  }

  double zoomVal = 5.0;

  @override
  Widget build(BuildContext context) {
    getShopData();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: base_color,
        title: Text("Google Map"),
      ),
      body: isLoading?Center(child: CircularProgressIndicator()): marker.isEmpty
          ? Center(
              child: Text("No Shop Found in specified distance."),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
//                  height: MediaQuery.of(context).size.height*0.5,
                    child: _buildGoogleMap(context)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Pizzeria",
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .merge(TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                Container(
                  child: Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: shopsData.length,
                        itemBuilder: (context, i) {
                          return _buildListTile(
                            lat: shopsData[i].data['location']['lat'],
                            lng: shopsData[i].data['location']['long'],
                            starRating: shopsData[i].data['rating'].toDouble(),
                            imageUrl: shopsData[i].data['thumbnail'],
                            openingHours: shopsData[i].data['openHour'],
                            closingHours: shopsData[i].data['location']
                                ['closeHour'],
                            shopName: shopsData[i].data['pizzaShopName'],
                            shopID: shopsData[i].data['docID'],
                          );
                        }),
                  ),
                ),
              ],
            ),
    );
  }


  Widget _buildListTile(
      {var imageUrl,
      var shopName,
      var starRating,
      var openingHours,
      var closingHours,
      double lat,
      double lng,
      var shopID}) {
    return Card(
      elevation: 3,
      child: ListTile(
        onTap: () {
          _gotoLocation(lat, lng);
        },
        isThreeLine: true,
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            IconButton(
                icon: Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                ),
                onPressed: () {
                  NavigationUitls.push(context, ShopDetails(shopID));
                })
          ],
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            shopName.toString().toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            displayRating(starRating),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.red,
                    ),
                    Text('${countDistance(lat, lng, _lat, _lng)}' + "Kms")
                  ],
                ),

              ],
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }

  Widget _boxes(String _image, double lat, double long, String restaurantName,
      var rating, var openingHours, var closingHours, var shopID) {
    return GestureDetector(
      onTap: () {
        _gotoLocation(lat, long);
      },
      child: Container(
        child: new FittedBox(
          child: Material(
              color: Colors.white,
              elevation: 14.0,
              borderRadius: BorderRadius.circular(24.0),
              shadowColor: Color(0x802196F3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 120,
                    height: 150,
                    child: ClipRRect(
                      borderRadius: new BorderRadius.circular(24.0),
                      child: Image(
                        fit: BoxFit.fill,
                        image: NetworkImage(_image),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: myDetailsContainer1(restaurantName, rating,
                          openingHours, closingHours, shopID),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget myDetailsContainer1(String restaurantName, var rating,
      var closingHours, var openingHours, var shopID) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
              child: Text(
            restaurantName,
            style: TextStyle(
                color: Color(0xff6200ee),
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          )),
        ),
        SizedBox(height: 5.0),
        displayRating(rating),
        SizedBox(height: 5.0),
        SizedBox(height: 5.0),
        Container(
            child: Text(
          "Closing Hours $closingHours",
          style: TextStyle(
              color: Colors.black54,
              fontSize: 15.0,
              fontWeight: FontWeight.bold),
        )),
        FlatButton(
          color: base_color,
          shape: StadiumBorder(),
          onPressed: () {
            NavigationUitls.push(context, ShopDetails(shopID));
          },
          child: Text(
            "Explor Shop",
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    print("From google map controller");
    print(marker.length);
    marker.forEach((element) {
      print(element.markerId);
//     element.forEach(())
    });
    return Container(
      height: MediaQuery.of(context).size.height * 0.45,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition:
            CameraPosition(target: LatLng(_lat, _lng), zoom: 10),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set.of(marker),
      ),
    );
  }

  Future<void> _gotoLocation(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 15,
      tilt: 50.0,
      bearing: 45.0,
    )));
  }
}

List<MarkerDetails> markerDetails = [
  MarkerDetails(
      markerID: 'gramercy',
      lat: 40.738380,
      lng: -73.988426,
      title: 'Gramercy Tavern'),
  MarkerDetails(
      markerID: 'gramesdfrcy',
      lat: 40.742451,
      lng: -74.005959,
      title: 'Gramercy Tavern')
];

class MarkerDetails {
  final String markerID;
  final double lat;
  final double lng;
  final title;

  MarkerDetails({this.markerID, this.lat, this.lng, this.title});
}

//List<Marker> myMarkers = [
//  Marker(
//  markerId: MarkerId('gramercy'),
//  position: LatLng(40.738380, -73.988426),
//  infoWindow: InfoWindow(title: 'Gramercy Tavern'),
//  icon: BitmapDescriptor.defaultMarkerWithHue(
//    BitmapDescriptor.hueViolet,
//  ),
//),Marker(
//  markerId: MarkerId('bernardin'),
//  position: LatLng(40.761421, -73.981667),
//  infoWindow: InfoWindow(title: 'Le Bernardin'),
//  icon: BitmapDescriptor.defaultMarkerWithHue(
//    BitmapDescriptor.hueViolet,
//  ),
//), Marker(
//  markerId: MarkerId('bluehill'),
//  position: LatLng(40.732128, -73.999619),
//  infoWindow: InfoWindow(title: 'Blue Hill'),
//  icon: BitmapDescriptor.defaultMarkerWithHue(
//    BitmapDescriptor.hueViolet,
//  ),
//),Marker(
//  markerId: MarkerId('newyork1'),
//  position: LatLng(40.742451, -74.005959),
//  infoWindow: InfoWindow(title: 'Los Tacos'),
//  icon: BitmapDescriptor.defaultMarkerWithHue(
//    BitmapDescriptor.hueViolet,
//  ),
//),Marker(
//  markerId: MarkerId('newyork2'),
//  position: LatLng(40.729640, -73.983510),
//  infoWindow: InfoWindow(title: 'Tree Bistro'),
//  icon: BitmapDescriptor.defaultMarkerWithHue(
//    BitmapDescriptor.hueViolet,
//  ),
//),Marker(
//  markerId: MarkerId('newyork3'),
//  position: LatLng(40.719109, -74.000183),
//  infoWindow: InfoWindow(title: 'Le Coucou'),
//  icon: BitmapDescriptor.defaultMarkerWithHue(
//    BitmapDescriptor.hueViolet,
//  ),
//)
//];
