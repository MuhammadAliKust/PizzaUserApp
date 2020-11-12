import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pizza_user_app/app_config/constant.dart';
import 'package:pizza_user_app/screens/distance_selecter.dart';
import 'package:pizza_user_app/widget_utils/navigation.dart';

class DataNotAvailable extends StatefulWidget {
  final IconData icon;
  final String text;
  DataNotAvailable(this.icon, this.text);

  @override
  _DataNotAvailableState createState() => _DataNotAvailableState();
}

class _DataNotAvailableState extends State<DataNotAvailable> {
  bool loading = true;

  @override
  void initState() {
    Timer(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Column(
        children: <Widget>[
          loading
              ? SizedBox(
                  height: 3,
                  child: LinearProgressIndicator(
                    backgroundColor: Color(0xff93bbe8),
                  ),
                )
              : SizedBox(),
          SizedBox(
            height: 0.4 * MediaQuery.of(context).size.width,
          ),
          Center(
            child: Column(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(90)),
                      child: Padding(
                        padding: const EdgeInsets.all(38.0),
                        child: Icon(
                          widget.icon,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        
                        widget.text,
                        style: Theme.of(context).textTheme.title.merge(TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey)),
                            textAlign: TextAlign.center,
                      ),
                    ),
                    FlatButton(
                      shape: StadiumBorder(),
                      color: base_color,
                      onPressed: (){
NavigationUitls.push(context, DistanceSelecter());
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text("Continue", style: TextStyle(color: Colors.white),),
                    ),)
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
