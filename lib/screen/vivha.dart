import 'dart:convert';
import 'package:bhagyoday/TodoList/todoform.dart';
import 'package:bhagyoday/screen/articles.dart';
import 'package:bhagyoday/screen/blogs_screen.dart';
import 'package:bhagyoday/screen/calendar_screen.dart';
import 'package:bhagyoday/screen/home_screen.dart';
import 'package:bhagyoday/themes/light_color.dart';
import 'package:bhagyoday/widgets/AppDrawer.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

class Vivha extends StatefulWidget {
  @override
  _VivhaState createState() => _VivhaState();
}

class VivhaData {
  final String id;
  final String title;
  final String month;
  final String year;

  VivhaData({
    this.id,
    this.title,
    this.month,
    this.year,
  });

  factory VivhaData.fromJson(Map<String, dynamic> json) {
    return VivhaData(
      id: json['id'],
      title: json['title'],
      month: json['month'],
      year: json['year'],
    );
  }
}

class _VivhaState extends State<Vivha> {
  var active = 'false', id;
  @override
  void initState() {
    super.initState();
    active = 'false';
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text("Mahurat"),
        ),
        drawer: AppDrawer(),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          Container(
              height: height / 13,
              child: FutureBuilder<List<VivhaData>>(
                future: _fetchVivhaData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<VivhaData> data = snapshot.data;
                    return Grid(context, data);
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  return Center(
                      child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ));
                },
              )),
          active == 'false'
              ? Container(
                  height: 250,
                )
              : Container(height: height / 1.4, child: Vivha_Details(todo: id)),
        ])),
        bottomNavigationBar: ConvexAppBar(
          backgroundColor: LightColor.red,
          items: [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.art_track, title: 'Articles'),
            TabItem(icon: Icons.event, title: 'Calender'),
            TabItem(icon: Icons.library_books, title: 'Blogs'),
            TabItem(icon: Icons.list, title: 'To-Do'),
          ],
          initialActiveIndex: 2, //optional, default as 0

          onTap: (index) {
            if (index == 0) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            } else if (index == 1) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Articles()));
            } else if (index == 2) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Calender()));
            } else if (index == 3) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Blogs()));
            } else if (index == 4) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Todo_list_()));
            }
          },
        ));
  }

  Future<List<VivhaData>> _fetchVivhaData() async {
    SharedPreferences pf = await SharedPreferences.getInstance();
    String lang;
    if (pf.containsKey("language")) {
      lang = pf.getString("language");
      print(lang);
    } else {
      lang = "EN";
      print(lang);
    }

    final url = 'https://bhagyodaycalendar.com/admin/api/vivha.php';
    var data = {'language': lang};
    var response = await http.post(Uri.parse(url), body: json.encode(data));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => new VivhaData.fromJson(job)).toList();
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
      child: CustomTabView(
        initPosition: initPosition,
        itemCount: data.length,
        tabBuilder: (context, index) => Tab(
          text: data[index].month,
        ),
        pageBuilder: (context, index) => Center(child: Text('')),
        onPositionChange: (index) {
          print('current position: $index');
          
          initPosition = index;
          setState(() {
            active = 'true';
            id = data[index];
          });
        },
        onScroll: (position) => Vivha_Details(todo: id),
      ),
    );
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

class _CustomTabsState extends State<CustomTabView>
    with TickerProviderStateMixin {
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
        _currentPosition = _currentPosition < 0 ? 0 : _currentPosition;
        if (widget.onPositionChange is ValueChanged<int>) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
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
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            indicator: BubbleTabIndicator(
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

class Vivha_Details extends StatefulWidget {
  final todo;

  Vivha_Details({
    Key key,
    @required this.todo,
  }) : super(key: key);
  @override
  _Vivha_DetailsState createState() => _Vivha_DetailsState();
}

class _Vivha_DetailsData {
  final String id;
  final String title;
  final String description;
  final String vivhaid;

  _Vivha_DetailsData({
    this.id,
    this.title,
    this.description,
    this.vivhaid,
  });

  factory _Vivha_DetailsData.fromJson(Map<String, dynamic> json) {
    return _Vivha_DetailsData(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      vivhaid: json['vivhaid'],
    );
  }
}

class _Vivha_DetailsState extends State<Vivha_Details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<_Vivha_DetailsData>>(
        future: _fetchDetailsData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<_Vivha_DetailsData> data = snapshot.data;
            return Details(context, data);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
          ));
        },
      ),
    );
  }

  Future<List<_Vivha_DetailsData>> _fetchDetailsData() async {
    final url = 'https://bhagyodaycalendar.com/admin/api/vivha_details.php';
    var data = {'vivhaid': widget.todo.id};
    var response = await http.post(Uri.parse(url), body: json.encode(data));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((job) => new _Vivha_DetailsData.fromJson(job))
          .toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }
}

Details(context, data) {
  return GridView.builder(
    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 3 / 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10),
    scrollDirection: Axis.vertical,
    itemCount: data.length,
    itemBuilder: (context, index) {
      print(data[index]);

      return InkWell(
          child: Padding(
        padding: EdgeInsets.all(2.0),
        child: Container(
          height: 60.0,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  children: [
                    if (data[index].title == 'Vivah')
                      Container(
                        height: 60,
                        width: 60,
                        child: Image(
                          image: AssetImage('assets/Drawer/vivah.png'),
                        ),
                      ),
                    if (data[index].title == 'Bhoomi Pujan')
                      Container(
                        height: 60,
                        width: 60,
                        child: Image(
                          image: AssetImage('assets/Drawer/mahrat.png'),
                        ),
                      ),
                    if (data[index].title == 'Ring Ceremony')
                      Container(
                        height: 60,
                        width: 60,
                        child: Image(
                          image: AssetImage('assets/ringceremony.png'),
                        ),
                      ),
                    if (data[index].title == 'Vastu')
                      Container(
                        height: 60,
                        width: 60,
                        child: Image(
                          image: AssetImage('assets/vastu.png'),
                        ),
                      ),
                    if (data[index].title == 'Upanayan')
                      Container(
                        height: 60,
                        width: 60,
                        child: Image(
                          image: AssetImage('assets/upanayan.png'),
                        ),
                      ),
                    if (data[index].title == 'Javal')
                      Container(
                        height: 60,
                        width: 60,
                        child: Image(
                          image: AssetImage('assets/javal.png'),
                        ),
                      ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      data[index].title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Html(
                      data: data[index].description,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ));
    },
  );
}
