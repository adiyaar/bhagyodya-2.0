import 'package:bhagyoday/themes/light_color.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class moon {
  final String language;
  final String date;
  final String time;
  final String type;
  final String precautions;

  moon({
    this.language,
    this.date,
    this.type,
    this.time,
    this.precautions,
  });

  factory moon.fromJson(Map<String, dynamic> json) {
    return moon(
      language: json['language'],
      date: json['datee'],
      type: json['type'],
      time: json['time'],
      precautions: json['precautions'],
    );
  }
}

class moonf extends StatefulWidget {
  @override
  _faqState createState() => _faqState();
}

const List<Tab> tabs = <Tab>[
  Tab(text: 'Sun'),
  Tab(text: 'Moon'),
];

Future<List<moon>> _fetchCartItem() async {
  var url = 'https://bhagyodaycalendar.com/admin/api/moon.php';
  SharedPreferences pf = await SharedPreferences.getInstance();
  String lang = pf.getString("language");
  var data = {"language": lang};
  var response = await http.post(Uri.parse(url),body: json.encode(data));

  List jsonResponse = json.decode(response.body);

  return jsonResponse.map((item) => new moon.fromJson(item)).toList();
}

Future<List<moon>> _fethcsun() async {
  var url = 'https://bhagyodaycalendar.com/admin/api/sun.php';
  SharedPreferences pf = await SharedPreferences.getInstance();
  String lang = pf.getString("language");
  var data = {"language": lang};
  var response = await http.post(Uri.parse(url),body: json.encode(data));

  List jsonResponse = json.decode(response.body);

  return jsonResponse.map((item) => new moon.fromJson(item)).toList();
}

imageSlider(context, data) {
  return ListView.builder(
    scrollDirection: Axis.vertical,
    itemCount: data.length,
    itemBuilder: (context, index) {
      return ExpansionTile(
        title: Text(data[index].date),
        children: <Widget>[
          Text(
            data[index].time,
            style: TextStyle(fontSize: 13),
          ),
          Text(
            data[index].precautions,
            style: TextStyle(fontSize: 13),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      );
    },
  );
}

class _faqState extends State<moonf> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      // The Builder widget is used to have a different BuildContext to access
      // closest DefaultTabController.
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context);
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {
            // Your code goes here.
            // To get index of current tab use tabController.index
          }
        });
        return Scaffold(
          appBar: AppBar(
            title: Text("Sun / Moon Eclipse"),
            bottom: const TabBar(
              tabs: tabs,
              labelColor: Colors.white,
            ),
          ),
          body: TabBarView(children: [
            FutureBuilder<List<moon>>(
              future: _fethcsun(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<moon> data = snapshot.data;
                  if (snapshot.data.length == 0) {
                    return Container(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 80),
                        child: Image.asset("assets/cart.png"));
                  }

                  return imageSlider(context, data);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return Center(
                    child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(LightColor.midnightBlue),
                ));
              },
            ),
            FutureBuilder<List<moon>>(
              future: _fetchCartItem(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<moon> data = snapshot.data;
                  if (snapshot.data.length == 0) {
                    return Container(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 80),
                        child: Image.asset("assets/cart.png"));
                  }

                  return imageSlider(context, data);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return Center(
                    child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(LightColor.midnightBlue),
                ));
              },
            ),
          ]),
        );
      }),
    );
  }
}
