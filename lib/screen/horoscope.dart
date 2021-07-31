import 'dart:convert';

import 'package:bhagyoday/TodoList/todoform.dart';
import 'package:bhagyoday/screen/articles.dart';
import 'package:bhagyoday/screen/articles_detail.dart';
import 'package:bhagyoday/screen/blogs_screen.dart';
import 'package:bhagyoday/screen/calendar_screen.dart';
import 'package:bhagyoday/screen/home_screen.dart';
import 'package:bhagyoday/themes/light_color.dart';
import 'package:bhagyoday/widgets/AppDrawer.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

class Horoscope extends StatefulWidget {
  @override
  _HoroscopeState createState() => _HoroscopeState();
}

class HoroscopeData {
  final String id;
  final String title;
  final String month;
  final String year;

  HoroscopeData({
    this.id,
    this.title,
    this.month,
    this.year,
  });

  factory HoroscopeData.fromJson(Map<String, dynamic> json) {
    return HoroscopeData(
      id: json['id'],
      title: json['title'],
      month: json['month'],
      year: json['year'],
    );
  }
}

class _HoroscopeState extends State<Horoscope> {
  var active = 'false', id;
  @override
  void initState() {
    super.initState();
    active = 'false';
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height=MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text("Horoscope"),
        ),
        drawer: AppDrawer(),
        body:  Column(children: <Widget>[
          Container(
              height: height/13,
              child: FutureBuilder<List<HoroscopeData>>(
                future: _fetchHoroscopeData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<HoroscopeData> data = snapshot.data;
                    return Grid(context, data);
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return Center(child: CircularProgressIndicator( valueColor:AlwaysStoppedAnimation<Color>(Colors.red),));
                },
              )),
          active == 'false'
              ? Container(
                  height: 250,
                )
              : Container(height: height/1.4, child: Horoscope_Details(todo: id)),
        ]),
        bottomNavigationBar: ConvexAppBar(
          backgroundColor:LightColor.red,
          items: [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.art_track, title: 'Articles'),
            TabItem(icon: Icons.event, title: 'Calender'),
            TabItem(icon: Icons.library_books, title: 'Blogs'),
            TabItem(icon: Icons.list, title: 'To-Do'),
          ],
          initialActiveIndex: 2,//optional, default as 0

          onTap: (index) {
            if (index == 0) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            } else if (index == 1) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Articles()));
            } else if (index == 2) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Calender()));
            } else if (index == 3) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Blogs()));
            } else if (index == 4) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Todo_list_()));
            }
          },
        )
    );

  }

  Future<List<HoroscopeData>> _fetchHoroscopeData() async {
    SharedPreferences pf = await SharedPreferences.getInstance();
    String lang;
    if (pf.containsKey("language")) {
      lang = pf.getString("language");
      print(lang);
    } else {
      lang = "EN";
      print(lang);
    }
    final url = 'https://bhagyodaycalendar.com/admin/api/horoscope.php';
    var data ={'language': lang };
    var response = await http.post(Uri.parse(url), body: json.encode(data));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((job) => new HoroscopeData.fromJson(job))
          .toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  Grid(context, data) {
    var initPosition;
    return Container(
        decoration: BoxDecoration(
            color: Colors.red[100],
            border: Border(
              bottom: BorderSide(color: Colors.red[100], width: 1.5),
              top: BorderSide(color: Colors.red[100], width: 1.5),
            )),
        child:CustomTabView(
          initPosition: initPosition,

          itemCount: data.length,
          tabBuilder: (context, index) => Tab(text: data[index].month,),
          pageBuilder: (context, index) => Center(child: Text('')),
          onPositionChange: (index){
            print('current position: $index');
            initPosition = index;
            setState(() {
              active = 'true';
              id = data[index];
            });
          },
          onScroll: (position) =>  Horoscope_Details(todo: id),
        ),);
  }
}

class CustomTabView extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder tabBuilder;
  final IndexedWidgetBuilder pageBuilder;
  final Widget stub;
  final ValueChanged<int> onPositionChange;
  final ValueChanged<double> onScroll;
  final int initPosition;

  CustomTabView({
    @required this.itemCount,
    @required this.tabBuilder,
    @required this.pageBuilder,
    this.stub,
    this.onPositionChange,
    this.onScroll,
    this.initPosition,
  });

  @override
  _CustomTabsState createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabView> with TickerProviderStateMixin {
  TabController controller;
  int _currentCount;
  int _currentPosition;

  @override
  void initState() {
    _currentPosition = widget.initPosition ?? 0;
    controller = TabController(
      length: widget.itemCount,
      vsync: this,
      initialIndex: _currentPosition,
    );
    controller.addListener(onPositionChange);
    controller.animation.addListener(onScroll);
    _currentCount = widget.itemCount;
    super.initState();
  }

  @override
  void didUpdateWidget(CustomTabView oldWidget) {
    if (_currentCount != widget.itemCount) {
      controller.animation.removeListener(onScroll);
      controller.removeListener(onPositionChange);
      controller.dispose();

      if (widget.initPosition != null) {
        _currentPosition = widget.initPosition;
      }

      if (_currentPosition > widget.itemCount - 1) {
        _currentPosition = widget.itemCount - 1;
        _currentPosition = _currentPosition < 0 ? 0 :
        _currentPosition;
        if (widget.onPositionChange is ValueChanged<int>) {
          WidgetsBinding.instance.addPostFrameCallback((_){
            if(mounted) {
              widget.onPositionChange(_currentPosition);
            }
          });
        }
      }

      _currentCount = widget.itemCount;
      setState(() {
        controller = TabController(
          length: widget.itemCount,
          vsync: this,
          initialIndex: _currentPosition,
        );
        controller.addListener(onPositionChange);
        controller.animation.addListener(onScroll);
      });
    } else if (widget.initPosition != null) {
      controller.animateTo(widget.initPosition);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.animation.removeListener(onScroll);
    controller.removeListener(onPositionChange);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount < 1) return widget.stub ?? Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: TabBar(
            isScrollable: true,
            controller: controller,
            labelColor:Colors.white,
            unselectedLabelColor: Colors.black,
            indicator:BubbleTabIndicator(
              indicatorHeight: 25.0,
              indicatorColor: Colors.red,
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
              // Other flags
              // indicatorRadius: 1,
              // insets: EdgeInsets.all(1),
              // padding: EdgeInsets.all(10)
            ),
            tabs: List.generate(
              widget.itemCount,
                  (index) => widget.tabBuilder(context, index),
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: List.generate(
              widget.itemCount,
                  (index) => widget.pageBuilder(context, index),
            ),
          ),
        ),
      ],
    );
  }

  onPositionChange() {
    if (!controller.indexIsChanging) {
      _currentPosition = controller.index;
      if (widget.onPositionChange is ValueChanged<int>) {
        widget.onPositionChange(_currentPosition);
      }
    }
  }

  onScroll() {
    if (widget.onScroll is ValueChanged<double>) {
      widget.onScroll(controller.animation.value);
    }
  }
}
class Horoscope_Details extends StatefulWidget {
  final todo;

  Horoscope_Details({
    Key key,
    @required this.todo,
  }) : super(key: key);
  @override
  _Horoscope_DetailsState createState() => _Horoscope_DetailsState();
}

class _Horoscope_DetailsData {
  final String id;
  final String title;
  final String horoscopeid;
  final String img;
  final String description;

  _Horoscope_DetailsData({
    this.id,
    this.title,
    this.horoscopeid,
    this.img,
    this.description,
  });

  factory _Horoscope_DetailsData.fromJson(Map<String, dynamic> json) {
    return _Horoscope_DetailsData(
      id: json['id'],
      horoscopeid: json['horoscopeid'],
      img: json['img'],
      title: json['title'],
      description: json['description'],
    );
  }
}

class _Horoscope_DetailsState extends State<Horoscope_Details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      FutureBuilder<List<_Horoscope_DetailsData>>(
        future: _fetchDetailsData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<_Horoscope_DetailsData> data = snapshot.data;
            return Details(context, data);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator( valueColor:AlwaysStoppedAnimation<Color>(Colors.red),));
        },
      ),
    );
  }

  Future<List<_Horoscope_DetailsData>> _fetchDetailsData() async {
    final url = 'https://bhagyodaycalendar.com/admin/api/horoscope_details.php';
    var data = {'horoscopeid': widget.todo.id};
    var response = await http.post(Uri.parse(url), body: json.encode(data));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((job) => new _Horoscope_DetailsData.fromJson(job))
          .toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }
}

Details(context, data) {
  return ListView.builder(
    scrollDirection: Axis.vertical,
    itemCount: data.length,
    itemBuilder: (context, index) {
      print(data[index]);
      return InkWell(
          child: Padding(
        padding: EdgeInsets.all(2.0),
        child: Card(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  height: 100.0,
                  width: 100.0,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 5.0)
                      ],
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0)),
                      image: DecorationImage(
                          image: NetworkImage(
                              '' +
                                  data[index].img),
                          fit: BoxFit.fill)),
                ),
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only( left: 15.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                data[index].title,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,color: Colors.red,
                                    fontSize: 16.0),
                                overflow: TextOverflow.ellipsis,
                              ),
                             Container(child: Text(
                                data[index].description,
                                style: TextStyle(
                                   // fontWeight: FontWeight.w600,
                                    fontSize: 13.0),
                                overflow: TextOverflow.ellipsis,maxLines: 50,
                              ),)
                            ])))
              ])),
        ),
      ));
    },
  );
}
