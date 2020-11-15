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
  var value = 0.0;
  Location location = new Location();
  TextEditingController searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  getPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
  }

  getLocation() async {
    return _locationData = await location.getLocation();
  }

  @override
  void initState() {
    getPermission().then((_) {
      getLocation().then((val) {
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
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("What are you looking for?",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .merge(TextStyle(color: Colors.white))),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                validator: (val) =>
                    val.isEmpty ? 'Pizza Shop Name cannot be empty' : null,
                controller: searchController,
                decoration: InputDecoration(
                    errorStyle: TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Pizza Margherita',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(borderSide: BorderSide.none)),
              ),
              SizedBox(
                height: 15,
              ),
              Text("Select Distance..",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .merge(TextStyle(color: Colors.white))),
              Slider(
                activeColor: Colors.white,
                inactiveColor: Colors.white54,
                value: value,
                min: 0,
                max: 10,
                divisions: 10,
                onChanged: (_value) {
                  setState(() {
                    value = _value;
                  });
                },
              ),
              Center(
                child: Text(
                  '${value.toInt()}' + "Km",
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .merge(TextStyle(color: Colors.white)),
                ),
              ),
              Center(
                child: FlatButton(
                  color: Colors.white,
                  onPressed: () {
                    if (!_formKey.currentState.validate()) {
                      return;
                    }
                    NavigationUitls.push(context,
                        MapHomePage(value.toInt(), searchController.text));
                  },
                  child: Text("Search"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
