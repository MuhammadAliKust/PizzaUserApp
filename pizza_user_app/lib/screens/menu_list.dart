import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pizza_user_app/app_config/constant.dart';
import 'package:pizza_user_app/screens/dashBoard.dart';
import 'package:pizza_user_app/screens/menu_details.dart';
import 'package:pizza_user_app/screens/shop_details.dart';
import 'package:pizza_user_app/widget_utils/display_rating.dart';
import 'package:pizza_user_app/widget_utils/navigation.dart';

class MenuList extends StatefulWidget {
  @override
  _MenuListState createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  Stream menu;
  List menuDetails = [];
Stream menuRef;
  displayShopDetails() async {
    return Firestore.instance.collection('menuDetails').orderBy('starRating').snapshots();
  }

  @override
  void initState() {
    print("Init State Called");
    super.initState();
    displayShopDetails().then((value) {
      menu = value;
      menuRef = value;
      menuRef.forEach((field) {
        field.documents.asMap().forEach((index, data) {
          menuDetails.add(field.documents[index]);
        });
      });
    });
    displayShopDetails().then((val) {
      menu = val;
      setState(() {});
    });
  }

  Widget _buildScreenUI(BuildContext context) {
    return StreamBuilder(
      stream: menu,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? snapshot.data.documents.length >= 1
                ? _buildListView(snapshot)
                : Text("No Menu Available.")
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildListView(AsyncSnapshot snapshot) {
    return ListView.builder(
      itemCount: snapshot.data.documents.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildListTile(snapshot, index);
      },
    );
  }

  Widget _buildListTile(AsyncSnapshot snapshot, var i) {
    var menuRating = 0;
    var ratingCounter = 0;
    menuDetails[i]['rating'].map((val) {
      print("Rating Value");
      print(val);
      menuRating = val['rating'] + menuRating;
      ratingCounter++;
    }).toList();
    ratingCounter == 0 ? ratingCounter = 1 : ratingCounter;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        elevation: 3,
        child: ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MenuDetails(menuRating / ratingCounter, menuDetails[i] )));
          },
          leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  snapshot.data.documents[i].data['menuPic'] ?? 'N/A')),
          title: Text(
            snapshot.data.documents[i].data['name'].toString().toUpperCase() ?? 'N/A',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: displayRating(menuRating / ratingCounter),
          trailing: Text("\$ "+
            snapshot.data.documents[i].data['price'] ?? 'N/A',
            style: TextStyle(fontWeight: FontWeight.bold),
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
          appBar: _appBar(context, 'Menu List'),
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
