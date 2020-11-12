import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pizza_user_app/app_config/constant.dart';
import 'package:pizza_user_app/helper/url_launcher.dart';
import 'package:pizza_user_app/screens/menu_details.dart';
import 'package:pizza_user_app/widget_utils/build_description.dart';
import 'package:pizza_user_app/widget_utils/build_heading.dart';
import 'package:pizza_user_app/widget_utils/display_rating.dart';
import 'package:pizza_user_app/widget_utils/horizontal_space.dart';
import 'package:pizza_user_app/widget_utils/navigation.dart';
import 'package:pizza_user_app/widget_utils/shop_heder.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ShopDetails extends StatefulWidget {
  var shopID;

  ShopDetails(this.shopID);

  @override
  _ShopDetailsState createState() => _ShopDetailsState();
}

const kExpandedHeight = 220.0;

class _ShopDetailsState extends State<ShopDetails> {
  getSelectedShopData(String id) {
    return Firestore.instance.collection('shopDetails').document(id).get();
  }

  getMenu() async {
    return Firestore.instance
        .collection('menuDetails')
        .where('shopID', isEqualTo: widget.shopID)
        .getDocuments();
  }

  List menuDetails = [];
  List shopDetails = [];
  ScrollController _scrollController;

  @override
  void initState() {
    getMenu().then((val) {
      val.documents.forEach((val) {
        menuDetails.add(val.data);
        setState(() {});
      });
    });

    getSelectedShopData(widget.shopID).then((val) {
      shopDetails.add(val.data);
      setState(() {});
    });
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  Widget _buildMenuCard(Map<String, dynamic> data, int index) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(data['image']),
        ),
        title: Text(data['name'], style: TextStyle(fontWeight: FontWeight.bold),),
        subtitle: Text(data['description']),
        trailing: Text("\$${data['price']},", style: TextStyle(fontWeight: FontWeight.bold),),
        onTap: () {
          NavigationUitls.push(
              context, MenuDetails(data['rating'], menuDetails[index]));
        },
      ),
    );
    return InkWell(
      onTap: () {
        NavigationUitls.push(
            context, MenuDetails(data['rating'], menuDetails[index]));
      },
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Color(0xfff2f2f2))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CachedNetworkImage(
              height: 70,
              imageUrl: data['image'],
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data['name'],
                          style: TextStyle(color: Color(0xff979797))),
                      displayRating(data['rating'].toDouble() == 'NaN'
                          ? 0
                          : data['rating'].toDouble())
                    ],
                  ),
                  Text("\$${data['price']}",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .merge(TextStyle(fontWeight: FontWeight.w500)))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpeningHours() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildHeading(context, 'Opening Hours'),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                shopDetails[0]['openHour'] +
                    " -- " +
                    shopDetails[0]['closeHour'],
                style: TextStyle(
                  color: Color(0xff979797),
                ))),
      ],
    );
  }

  Widget _buildSocialMediaLinks() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildHeading(context, 'Social Media Links'),
          Row(children: [
            IconButton(
                icon: Icon(FontAwesomeIcons.facebook),
                onPressed: () {
                  launchUrl(shopDetails[0]['fb']);
                }),
            horizontalSpace(10),
            IconButton(
                icon: Icon(FontAwesomeIcons.instagram),
                onPressed: () {
                  launchUrl(shopDetails[0]['insta']);
                }),
          ]),
        ],
      ),
    );
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset > kExpandedHeight - kToolbarHeight;
  }

  Widget build(BuildContext context) {
    return shopDetails.isEmpty
        ? Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'Loading....',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              elevation: 0,
              backgroundColor: base_color,
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                shopDetails[0]['pizzaShopName'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              elevation: 0,
              backgroundColor: base_color,
            ),
            body: shopDetails.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundImage:
                                  NetworkImage(shopDetails[0]['thumbnail']),
                            ),
                            SizedBox(width: 20,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(
                                  shopDetails[0]['pizzaShopName'].toString().toUpperCase(),
                                  style:
                                  TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  child: Row(

                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: base_color,
                                      ),
                                      Text(shopDetails[0]['address']),

                                    ],
                                  ),
                                ),
                                displayRating(shopDetails[0]['rating'].toDouble())
                              ],
                            ),

                          ],
                        ),
                      ),
                      Divider(),
                      SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.email, color: Colors.blue,),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(shopDetails[0]['email']),
                              ],
                            ),
                            SizedBox(
                              width:40,
                            ),
                            Row(
                              children: [
                                Icon(Icons.call,color: Colors.blue,),
                                SizedBox(
                                  width: 10,
                                ),
                          Text(shopDetails[0]['phone']??'N/A'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          children: [
                            Icon(Icons.link,color: Colors.blue,),
                            SizedBox(
                              width: 10,
                            ),
                            Text(shopDetails[0]['insta']),
                          ],
                        ),
                      ),
                      Divider(),
                      buildHeading(context, "Description"),
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(shopDetails[0]['description']??'N/A'),
                      ),
                      Divider(),
                      buildHeading(context, "Menu"),
                      SizedBox(height: 10,),
                      Expanded(
                        child: Container(
                          child: menuDetails.length<1?Center(child: Text("NO Menu Available."),): ListView.builder(
                            itemBuilder: (context, index) {
                              return _getSliverGrid(index);
                            },
                            itemCount: menuDetails.length,
                          ),
                        ),
                      )
                    ],
                  ),
          );
//    return MaterialApp(
//        home: Scaffold(
//      body: shopDetails.isEmpty
//          ? Center(child: CircularProgressIndicator())
//          : CustomScrollView(
//              controller: _scrollController,
//              slivers: <Widget>[
//                SliverAppBar(
//                  expandedHeight: kExpandedHeight,
//                  floating: false,
//                  pinned: true,
//                  elevation: 50,
//                  backgroundColor: base_color,
//                  flexibleSpace: FlexibleSpaceBar(
//                      title: _showTitle ? Text('Shop Name') : null,
//                      background: CachedNetworkImage(
//                        fit: BoxFit.cover,
//                        imageUrl:   shopDetails[0]['thumbnail'],
//                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
//                        errorWidget: (context, url, error) => Icon(Icons.error),
//                      )),
//                ),
//                new SliverList(
//                    delegate: new SliverChildListDelegate([
//                  buildShopName(context,
//                      shopName: shopDetails[0]['pizzaShopName'],
//                      rating: shopDetails[0]['rating'].toDouble()),
//                  Divider(
//                    thickness: 1.2,
//                    color: Color(0xffe6e6e6),
//                  ),
//                  buildHeading(context, 'Description'),
//                  buildDescription(shopDetails[0]['description'], context),
//                  SizedBox(
//                    height: 10,
//                  ),
//                  Divider(
//                    thickness: 1.2,
//                    color: Color(0xffe6e6e6),
//                  ),
//                  _buildOpeningHours(),
//                  Divider(
//                    thickness: 1.2,
//                    color: Color(0xffe6e6e6),
//                  ),
//                  _buildSocialMediaLinks(),
//                  Divider(
//                    thickness: 1.2,
//                    color: Color(0xffe6e6e6),
//                  ),
//                  buildHeading(context, 'Our Products')
//                ])),
//                SliverPadding(
//                  padding: const EdgeInsets.all(2.0),
//                  sliver: SliverGrid(
//                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                          crossAxisCount: 2,
//                          childAspectRatio: 1,
//                          crossAxisSpacing: 0,
//                          mainAxisSpacing: 0),
//                      delegate: SliverChildBuilderDelegate(
//                        (context, index) {
//                          return _getSliverGrid(index);
//                        },
//                        childCount: menuDetails.length,
//                      )),
//                ),
//              ],
//            ),
//
//    ));
  }

  _getSliverGrid(var index) {
    var menuRating = 0;
    var ratingCounter = 0;
    menuDetails[index]['rating'].map((val) {
      print("Rating Value");
      print(val);
      menuRating = val['rating'] + menuRating;
      ratingCounter++;
    }).toList();
    ratingCounter == 0 ? ratingCounter = 1 : ratingCounter;
    return _buildMenuCard({
      'image': menuDetails[index]['menuPic'],
      'name': menuDetails[index]['name'],
      'rating': menuRating / ratingCounter,
      'price': menuDetails[index]['price'],
      'description': menuDetails[index]['description']
    }, index);
  }
}
