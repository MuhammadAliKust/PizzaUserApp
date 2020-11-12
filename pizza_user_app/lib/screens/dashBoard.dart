import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:pizza_user_app/app_config/constant.dart';
import 'package:pizza_user_app/screens/map_homePage.dart';
import 'package:pizza_user_app/screens/menu_list.dart';
import 'package:pizza_user_app/screens/shop_list.dart';
import 'package:pizza_user_app/widget_utils/navigation.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Geolocator geolocator = Geolocator();

  Position userLocation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getLocation().then((position) {
      userLocation = position;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _onBackPressed() {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Do you want to exit?"),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text("No")),
            FlatButton(
                onPressed: () {
                  exit(0);
                },
                child: Text("Yes"))
          ],
        ),
      );
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Dashboard"),
        ),
        body: Column(
          children: [
//            _buildDashBoardCard('Display Resturants',
//                () => NavigationUitls.push(context, MapHomePage())),
            _buildDashBoardCard('Display Menus',
                () => NavigationUitls.push(context, MenuList())),
          ],
        ),
      ),
    );
  }

  _buildDashBoardCard(String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
              leading: Container(
                decoration: BoxDecoration(
                  color: base_color,
                  borderRadius: BorderRadius.circular(7)
                ),
                  child:
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.restaurant_menu, color: Colors.white,),
                  )),
              title: Text(
                label,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () => onTap()),
        ),
      ),
    );
  }

  double _countDistance() {
    return Distance().as(
      LengthUnit.Kilometer,
      LatLng(40, 120),
      LatLng(33, 71),
    );
  }

  Future<Position> _getLocation() async {
    var currentLocation;
    try {
      print("try");
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .then((value) => print(value.longitude));
      print(currentLocation);
      print("----");
    } catch (e) {
      print("Catch");
      currentLocation = null;
    }
    print(currentLocation);
    return currentLocation;
  }
}
