import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pizza_user_app/app_config/constant.dart';
import 'package:pizza_user_app/helper/helper.dart';
import 'package:pizza_user_app/screens/authentication/auth_screens.dart/login.dart';
import 'package:pizza_user_app/screens/menu_list.dart';
import 'package:pizza_user_app/screens/thank_note.dart';
import 'package:pizza_user_app/widget_utils/build_description.dart';
import 'package:pizza_user_app/widget_utils/build_heading.dart';
import 'package:pizza_user_app/widget_utils/display_rating.dart';
import 'package:pizza_user_app/widget_utils/horizontal_space.dart';
import 'package:pizza_user_app/widget_utils/navigation.dart';
import 'package:pizza_user_app/widget_utils/shop_heder.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class MenuDetails extends StatefulWidget {
  final rating;
  var data;

  MenuDetails(this.rating, this.data);

  @override
  _MenuDetailsState createState() => _MenuDetailsState();
}

const kExpandedHeight = 220.0;

class _MenuDetailsState extends State<MenuDetails> {
  ScrollController _scrollController;
  List menuDetails = [];
  int ratingCounter = 0;
  int menuRating = 0;
  int shopTotalRating = 0;
  bool isUserLoggedIn = false;

  getUserName()async{
    return Firestore.instance.collection('users').where('email', isEqualTo: await HelperFunctions.getCurrentUserEmailId()).getDocuments();
  }
  _calculateShopRating() {
    return Firestore.instance
        .collection('menuDetails')
        .where('shopID', isEqualTo: widget.data['shopID'])
        .getDocuments();
  }

  var totalStars = 0.0;
  var counter = 0;
  var userName;
List userDetails = [];
  @override
  void initState() {
    getUserName().then((val){
      print(val.documents.forEach((v){
        userName = v['name'];
        setState(() {
print(userName);
        });
      }));
//      userDetails.add(val[0]['name']);
    });
    HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      setState(() {
        value == null?isUserLoggedIn=false:isUserLoggedIn=value;

      });
    }
    );
    _calculateShopRating().then((QuerySnapshot val) {
      val.documents.forEach((element) {
        print("Star Rating");
        print(element.data['starRating']);
        totalStars += element.data['starRating'];
        counter++;
        setState(() {});
      });
      print("Shop Rating");
      print(totalStars / counter);
    });
    print("from initState");
    if (widget.data['rating'].isNotEmpty) {
      widget.data['rating'].map((e) {
        print("From map");
        menuRating += e['rating'];
        print(menuRating);
        ratingCounter++;
        setState(() {});
      }).toList();
    }

    print("rating counter");
    print(ratingCounter);
    super.initState();
    _scrollController = ScrollController()..addListener(() => setState(() {}));
  }

  bool get _showTitle {
    return _scrollController.hasClients &&
        _scrollController.offset > kExpandedHeight - kToolbarHeight;
  }

  TextEditingController _ratingController = TextEditingController();
  var rating = 0.0;

  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: kExpandedHeight,
            centerTitle: true,
            floating: false,
            pinned: true,
            elevation: 50,
            backgroundColor: base_color,
            flexibleSpace: FlexibleSpaceBar(
                title: _showTitle ? Text('Shop Name') : null,
                background: Image.network(
                  widget.data['menuPic'],
                  fit: BoxFit.cover,
                )),
          ),
          new SliverList(
              delegate: new SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildShopName(context,
                      shopName: widget.data['name'],
                      rating: widget.rating.toDouble()),
                  Text("\$${widget.data['price']}",
                      style: Theme.of(context).textTheme.headline6)
                ],
              ),
            ),
            Divider(
              thickness: 1.2,
              color: Color(0xffe6e6e6),
            ),
            buildHeading(context, 'Description'),
            buildDescription(widget.data['description'], context),
            Divider(
              thickness: 1.2,
              color: Color(0xffe6e6e6),
            ),
            buildHeading(context, 'Reviews Rating'),
            Divider(),
            ...widget.data['rating'].map((val) {
              return Column(
                children: [
                  ListTile(
                      leading: CircleAvatar(
                        child: Text(val['name'].toString().substring(0, 1)??'N/A'),
                      ),
                      title: Text(val['name']??'N/A'),
                      trailing: displayRating(val['rating'].toDouble() == 'NaN'
                          ? 0
                          : val['rating'].toDouble())),
                  Divider()
                ],
              );
            }).toList()
          ])),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: base_color,
        onPressed: () {
          print(widget.data['docID']);

          isUserLoggedIn
              ? showDialog(
                  barrierDismissible: false,
                  context: (context),
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Give your Feedback!"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [_getRating()],
                      ),
                      actions: [
                        FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {
                              rating = 0;
                            });
                          },
                          child: Text("Cancel"),
                        ),
                        FlatButton(
                          onPressed: () {
                            Firestore.instance
                                .collection('menuDetails')
                                .document(widget.data['docID'])
                                .updateData({
                                  'rating': FieldValue.arrayUnion([
                                    {
                                      'name': userName,
                                      'rating': rating.toInt()
                                    }
                                  ])
                                })
                                .then((value) => Firestore.instance
                                        .collection('menuDetails')
                                        .document(widget.data['docID'])
                                        .updateData({
                                      'starRating': (menuRating + rating) /
                                          (ratingCounter + 1)
                                    }))
                                .then((value) {
                              widget.data['rating'].isNotEmpty? Firestore.instance
                                      .collection('shopDetails')
                                      .document(widget.data['shopID'])
                                      .updateData(
                                          {'rating': (totalStars / counter)}): Firestore.instance
                                  .collection('shopDetails')
                                  .document(widget.data['shopID'])
                                  .updateData(
                                  {'rating': rating});
                                })
                                .then((value) {
                                  setState(() {
                                    rating = 0;
                                  });
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ThanksNote()),
                                      (route) => false);
                                });
                          },
                          child: Text("Submit"),
                        ),
                      ],
                    );
                  })
              : showDialog(
                  barrierDismissible: false,
                  context: (context),
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Message!"),
                      content:
                          Text("Kindly login first befor rating our shop."),
                      actions: [
                        FlatButton(
                          onPressed: () {
                            NavigationUitls.push(context, Login());
                          },
                          child: Text("Go to Login"),
                        ),
                        FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancel"),
                        )
                      ],
                    );
                  });
        },
        label: Row(
          children: [
            Icon(Icons.star),
            horizontalSpace(10),
            Text("Give your Feedback!"),
          ],
        ),
      ),
    ));
  }

  _calculateRating() {
    var menuRating = 0;
    var ratingCounter = 0;
    menuDetails[0]['rating'].map((val) {
      print("Rating Value");
      print(val);
      menuRating = val['rating'] + menuRating;
      ratingCounter++;
    }).toList();
    ratingCounter == 0 ? ratingCounter = 1 : ratingCounter;

    print(menuRating / ratingCounter);
  }

  _getRating() {
    return SmoothStarRating(
      allowHalfRating: false,
      isReadOnly: false,
      starCount: 5,
      rating: rating,
      size: 35.0,
      color: Colors.yellow,
      borderColor: Colors.yellow,
      spacing: 0.0,
      onRated: (value) {
        setState(() {
          rating = value;
        });
      },
    );
  }
}
