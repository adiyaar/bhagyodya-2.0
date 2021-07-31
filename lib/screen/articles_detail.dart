import 'dart:convert';
import 'package:bhagyoday/screen/home_slider.dart';
import 'package:bhagyoday/themes/light_color.dart';
import 'package:bhagyoday/widgets/custom_divider_view.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_pro/carousel_pro.dart';


class ArticlesDetails extends StatefulWidget {
  final todo;

  ArticlesDetails({Key key, @required this.todo}) : super(key: key);

  @override
  _ArticlesDetailsState createState() => _ArticlesDetailsState();
}

class _ArticlesDetailsState extends State<ArticlesDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    //List<int> sizeList = [7, 8, 9, 10];
    Color cyan = Color(0xff37d6ba);
    //List<Color> colorsList = [Colors.black, Colors.blue, Colors.red];

    int itemCount = 0;
    var _value;
    return Scaffold(
      key: _scaffoldKey,
      // backgroundColor: LightColor.yellowColor,
      appBar: AppBar(
        title: Text('Article Detail'),

        // backgroundColor: LightColor.whiteColor,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: Container(
                child: Column(children: <Widget>[
                  Expanded(
                    child: Container(
                      //padding: EdgeInsets.only(left: 15, right: 15),
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: <Widget>[
                          Container(
                            // padding: EdgeInsets.only(left: 15, right: 15),
                              height: 300.0,
                              width: 150.0,
                              child: Carousel(
                                images: [
                                  NetworkImage(
                                      'https://bhagyodaycalendar.com/admin/admin/media/articles/' +
                                          widget.todo.img),
                                  NetworkImage(
                                    'https://bhagyodaycalendar.com/admin/admin/media/articles/' +
                                        widget.todo.img,
                                  ),
                                  NetworkImage(
                                    'https://bhagyodaycalendar.com/admin/admin/media/articles/' +
                                        widget.todo.img,
                                  ),
                                ],
                                dotSize: 6.0,
                                dotSpacing: 15.0,
                                dotColor: Colors.white,
                                indicatorBgPadding: 5.0,
                                dotBgColor: LightColor.red.withOpacity(0.5),
                                borderRadius: true,
                              )),

                          SizedBox(height: 10),

                          Container(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: Text(
                              widget.todo.title,
                              style: TextStyle(
                                  fontSize: 20,
                                 // color:LightColor.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),


                          SizedBox(height: 30),

                          /*Container(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: Text(
                              'Short Description',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: LightColor.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 10),*/
                          Container(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: Text(
                             widget.todo.shortdescription,
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 10,
                            ),
                          ),
                          SizedBox(height: 10),

                          SizedBox(height: 10),

                          Divider(
                            color: Colors.grey[200],
                            height: 20,
                            thickness: 10,
                          ),


                    SizedBox(height: 1),

                          /*SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: Text(
                             'Long Description',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: LightColor.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),

                          SizedBox(height: 10),*/
                          Container(
                            padding: EdgeInsets.only(left: 15, right: 15),
                            child: Text(
                              widget.todo.longdescription,
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey),
                              //overflow: TextOverflow.ellipsis, maxLines: 2,
                            ),
                          ),
                          SizedBox(height: 10),

                          CustomDividerView(),
                          footer(),



                        ],
                      ),
                    ),
                  ),

                ]),
              )),

        ],
      ),


    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: Colors.blue,
    ));
  }
}
