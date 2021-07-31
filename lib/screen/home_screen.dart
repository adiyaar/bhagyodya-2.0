import 'dart:convert';

import 'package:bhagyoday/TodoList/todoform.dart';
import 'package:bhagyoday/screen/articles.dart';
import 'package:bhagyoday/screen/blogs_screen.dart';
import 'package:bhagyoday/screen/calendar_screen.dart';
import 'package:bhagyoday/screen/home_slider.dart';
import 'package:bhagyoday/screen/moon.dart';

import 'package:bhagyoday/themes/light_color.dart';
import 'package:bhagyoday/widgets/AppDrawer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  //final String email;

// Receiving Email using Constructor.
  // HomeScreen ({Key key, @required this.email}) : super(key: key);
  @override
  _HomeStateScreen createState() => _HomeStateScreen();
}

class _HomeStateScreen extends State<HomeScreen> {
  String email;
  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String useridValue = prefs.getString('userid');
    print(useridValue);
    //return useridValue;
    setState(() {
      email = prefs.getString("email");
      // id = prefs.getString('userid');
    });
  }

  var wifiBSSID;
  var wifiIP;
  var wifiName;
  bool iswificonnected = false;
  bool isInternetOn = true;

  static const routeName = "/";

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Select Your Language",
            textAlign: TextAlign.center,
          ),
          content: Container(
            height: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    SharedPreferences pf =
                        await SharedPreferences.getInstance();
                    pf.setString("language", "EN");
                    print("TAPPPP");
                    print(pf.getString("language"));
                    // Navigator.of(context).pop();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  child: Container(
                    width: 200,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(25.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "English",
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                InkWell(
                  onTap: () async {
                    SharedPreferences pf =
                        await SharedPreferences.getInstance();
                    pf.setString("language", "HI");
                    print("TAPPPP");
                    print(pf.getString("language"));
                    //Navigator.of(context).pop();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  child: Container(
                    width: 200,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(25.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "हिंदी",
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                InkWell(
                  onTap: () async {
                    SharedPreferences pf =
                        await SharedPreferences.getInstance();
                    pf.setString("language", "MA");
                    print("TAPPPP");
                    print(pf.getString("language"));
                    //  Navigator.of(context).pop();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  child: Container(
                    width: 200,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(25.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "मराठी",
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                InkWell(
                  onTap: () async {
                    SharedPreferences pf =
                        await SharedPreferences.getInstance();
                    pf.setString("language", "KA");
                    print("TAPPPP");
                    print(pf.getString("language"));
                    // Navigator.of(context).pop();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  child: Container(
                    width: 200,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(25.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "ಕನ್ನಡ",
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // actions: <Widget>[
          //   // usually buttons at the bottom of the dialog
          //   new FlatButton(
          //     child: new Text("Close"),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //   ),
          // ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStringValuesSF();
    GetConnect(); // calls getconnect method to check which type if connection it
  }

// Receiving Email using Constructor.

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Bhagyoday"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.language_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              _showDialog();
            },
          ),
          IconButton(
            icon: Icon(
              Icons.circle,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => moonf()));
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: isInternetOn
          // ? iswificonnected ? new Language() : new Language()
          ? iswificonnected
              ? new SliderPage()
              : new SliderPage()
          : nointernet(),

      /*bottomNavigationBar: TitledBottomNavigationBar(
            currentIndex: 0, // Use this to update the Bar giving a position
          activeColor: Colors.red,
            onTap: (index){
              if(index==0){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => HomeScreen()));
              }
              else if(index==1){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Articles()));
              }
              else if(index==2){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Calender()));
              }
              else if(index==3){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Blogs()));
              }
              else if(index==4){

                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Todo_list_()));
              }
              print("Selected Index: $index");
            },
            items: [
              TitledNavigationBarItem(
                title: Text(
                  'Home',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                icon: Icons.home,
              ),
              TitledNavigationBarItem(
                  title: Text(
                    'Articles',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  icon: Icons.art_track),
              TitledNavigationBarItem(
                  title: Text(
                    'Calendar',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  icon: Icons.list),
              TitledNavigationBarItem(
                  title: Text(
                    'Blogs',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  icon: Icons.library_books),
              TitledNavigationBarItem(
                  title: Text(
                    'Todo List',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  icon: Icons.list),
            ]
        )*/
    );
  }

  void GetConnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isInternetOn = false;
      });
    } else if (connectivityResult == ConnectivityResult.mobile) {
      iswificonnected = false;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      iswificonnected = true;
      // setState(() async {
      //   wifiBSSID = await (Connectivity().getWifiBSSID());
      //   wifiIP = await (Connectivity().getWifiIP());
      //   wifiName = await (Connectivity().getWifiName());
      // });
    }
  }
}

nointernet() {
  return Stack(children: <Widget>[
    Image.asset(
      "assets/no-int.gif",
    ),
    Center(
        child: Text(
      "\n\n\n\n  No Internet Connection",
      style: TextStyle(
          fontSize: 24,
          color: LightColor.midnightBlue,
          fontWeight: FontWeight.bold),
    )),
  ]);
}

AlertDialog buildAlertDialog() {
  return AlertDialog(
    title: Text(
      "No Internet Connection Failed to Connect to Bhagyoday. Please Check your Device's network connection and try again",
      style: TextStyle(fontStyle: FontStyle.italic),
    ),
  );
}
