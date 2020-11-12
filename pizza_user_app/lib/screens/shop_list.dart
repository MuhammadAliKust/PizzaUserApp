import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:pizza_user_app/app_config/constant.dart';
import 'package:pizza_user_app/screens/dashBoard.dart';
import 'package:pizza_user_app/screens/shop_details.dart';
import 'package:pizza_user_app/widget_utils/display_rating.dart';
import 'package:pizza_user_app/widget_utils/navigation.dart';

class ShopList extends StatefulWidget {
  @override
  _ShopListState createState() => _ShopListState();
}

class _ShopListState extends State<ShopList> {
  Stream shops;

  displayShopDetails() async {
    return Firestore.instance.collection('shopDetails').orderBy('rating').snapshots();
  }
  List<DocumentSnapshot> shopsData = [];
  double _countDistance(double lat, double lng) {

    return Distance().as(
      LengthUnit.Kilometer,
      LatLng(lat, lng),
      LatLng(33, 71),
    );
  }

  @override
  void initState() {
    super.initState();
    displayShopDetails().then((val) {
     val.listen((QuerySnapshot val){
       val.documents.forEach((element) {
         print("Element");
         print(_countDistance( element.data['location']['lat'], element.data['location']['long']));
         if(_countDistance( element.data['location']['lat'], element.data['location']['long'])<=300){
           print("If block");
           print(element.data);
          shopsData.add(element);
          setState(() {

          });
         }
       });
     });
//      if(_countDistance(lat, lng)<=10){
//
//      }

      setState(() {});
    });
  }

  Widget _buildScreenUI(BuildContext context) {
    print(shopsData.length);
    return StreamBuilder(
      stream: shops,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? snapshot.data.documents.length >= 1
                ? _buildListView(snapshot)
                : Text("No Shops")
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildListView(AsyncSnapshot snapshot) {
    return ListView.builder(
      itemCount: snapshot.data.documents.length,
      itemBuilder: (BuildContext context, int index) {
        print("Url of Image");
        print(snapshot.data.documents[index].data['thumbnail']);
        return _buildListTile(snapshot, index);
      },
    );
  }

  Widget _buildListTile(AsyncSnapshot snapshot, var i) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        elevation: 3,
        child: ListTile(
          isThreeLine: true,
          onTap: () {
             Navigator.push(
                 context,
                 MaterialPageRoute(
                     builder: (context) =>
                         ShopDetails(snapshot.data.documents[i].documentID)));
          },
          leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  snapshot.data.documents[i].data['thumbnail'] ?? 'N/A')),
          title: Text(
            snapshot.data.documents[i].data['pizzaShopName'].toString().toUpperCase() ?? 'N/A',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              displayRating(
                  snapshot.data.documents[i].data['rating'].toDouble()),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: base_color,),
                  SizedBox(height: 4,),
                  Text('${_countDistance(snapshot.data.documents[i].data['location']['lat'], snapshot.data.documents[i].data['location']['long'])}' + " Kms"),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=>NavigationUitls.pushReplacement(context, HomeView()),
      child: Scaffold(
        appBar: _appBar(context, 'Manage Your Shops'),
        body: _buildScreenUI(context),
      ),
    );
  }

  _appBar(BuildContext context, String title) {
    return AppBar(
      centerTitle: true,
      elevation: 0,
      backgroundColor: appBarColor,
      title: Text(title),
    );
  }
}
