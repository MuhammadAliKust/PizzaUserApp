import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:pizza_user_app/app_config/constant.dart';
import 'package:pizza_user_app/helper/helper.dart';
import 'package:pizza_user_app/screens/map_homePage.dart';
import 'package:pizza_user_app/widget_utils/navigation.dart';

class DistanceSelecter extends StatefulWidget {
  @override
  _DistanceSelecterState createState() => _DistanceSelecterState();
}

class _DistanceSelecterState extends State<DistanceSelecter> {
  var value = 1.0;
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

 getPermission()async{
   _serviceEnabled = await location.serviceEnabled();
   if (!_serviceEnabled) {
     _serviceEnabled = await location.requestService();
     if (!_serviceEnabled) {
       return;
     }
   }
 }

  getLocation()async{

    return _locationData = await location.getLocation();
  }
  @override
  void initState() {
   getPermission().then((_){
     getLocation().then((val){
       print(val.latitude);
       HelperFunctions.saveLat(val.latitude);
       HelperFunctions.saveLng(val.longitude);
     });
   });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: base_color,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Choose distance range for pizza shop..",
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .merge(TextStyle(color: Colors.white))),
          Slider(
            activeColor: Colors.white,
            inactiveColor: Colors.white54,
            value: value,
            min: 1,
            max: 10,
            divisions: 10,
            onChanged: (_value) {
              setState(() {
                value = _value;
              });
            },
          ),
          Text(
            '${value.toInt()}' + "Km",
            style: Theme.of(context)
                .textTheme
                .headline6
                .merge(TextStyle(color: Colors.white)),
          ),
          FlatButton(
            color: Colors.white,
            onPressed: () {
              NavigationUitls.push(context, MapHomePage(value.toInt()));
            },
            child: Text("Search"),
          )
        ],
      ),
    );
  }
}
