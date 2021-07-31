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

class Panchang extends StatefulWidget {
  @override
  _PanchangState createState() => _PanchangState();
}

class PanchangData {
  final String id;
  final String title;
  final String month;
  final String year;

  PanchangData({
    this.id,
    this.title,
    this.month,
    this.year,
  });

  factory PanchangData.fromJson(Map<String, dynamic> json) {
    return PanchangData(
      id: json['id'],
      title: json['title'],
      month: json['month'],
      year: json['year'],
    );
  }
}

class _PanchangState extends State<Panchang> {
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
          title: Text("Panchang"),
        ),
        drawer: AppDrawer(),
        body:Column(children: <Widget>[
          Container(
              height: height/13,
              child: FutureBuilder<List<PanchangData>>(
                future: _fetchPanchangData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<PanchangData> data = snapshot.data;
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
              : Container(height: height/1.4, child: Panchang_Details(todo: id)),
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

  Future<List<PanchangData>> _fetchPanchangData() async {
    SharedPreferences pf = await SharedPreferences.getInstance();
    String lang;
    if (pf.containsKey("language")) {
      lang = pf.getString("language");
      print(lang);
    } else {
      lang = "EN";
      print(lang);
    }
    final url = 'https://bhagyodaycalendar.com/admin/api/panchang.php';
    var data ={'language': lang };

    var response = await http.post(Uri.parse(url), body: json.encode(data));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => new PanchangData.fromJson(job)).toList();
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
          onScroll: (position) =>  Panchang_Details(todo: id),
        ),

    /*ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: data.length,
          itemBuilder: (context, index) {
            print(data[index]);
            return InkWell(
                onTap: () {
                  setState(() {
                    active = 'true';
                    id = data[index];
                  });
                },
                // var finalprice = data[index].price;
                child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Container(
                      height: 20.0,
                      child: Text(
                        data[index].month,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )));
          },
        )*/
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
class Panchang_Details extends StatefulWidget {
  final todo;

  Panchang_Details({
    Key key,
    @required this.todo,
  }) : super(key: key);
  @override
  _Panchang_DetailsState createState() => _Panchang_DetailsState();
}

class _Panchang_DetailsData {
  final String id;
  final String panchangid;
  final String day;
  final String weekday;
  final String col1;
  final String col11;
  final String col2;
  final String col22;
  final String col3;
  final String col33;
  final String col4;
  final String col44;
  final String col5;

  _Panchang_DetailsData({
    this.id,
    this.panchangid,
    this.day,
    this.weekday,
    this.col1,
    this.col11,
    this.col2,
    this.col22,
    this.col3,
    this.col33,
    this.col4,
    this.col44,
    this.col5,
  });

  factory _Panchang_DetailsData.fromJson(Map<String, dynamic> json) {
    return _Panchang_DetailsData(
      id: json['id'],
      panchangid: json['panchangid'],
      day: json['day'],
      weekday: json['weekday'],
      col1: json['col1'],
      col11: json['col11'],
      col2: json['col2'],
      col22: json['col22'],
      col3: json['col3'],
      col33: json['col33'],
      col4: json['col4'],
      col44: json['col44'],
      col5: json['col5'],
    );
  }
}

class _Panchang_DetailsState extends State<Panchang_Details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<_Panchang_DetailsData>>(
        future: _fetchDetailsData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<_Panchang_DetailsData> data = snapshot.data;
           // return Details(context, data);
            return SingleChildScrollView(
              //scrollDirection: Axis.horizontal,
              child:DataTable(
                headingRowHeight: 0,
                  columnSpacing: 0,
                columns: [
                  DataColumn(label: Text('WE')),
                  DataColumn(label: Text('Col1')),
                  DataColumn(label: Text('Col11')),
                  DataColumn(label: Text('Col2')),
                  DataColumn(label: Text('Col22')),
                  DataColumn(label: Text('Col3')),
                  DataColumn(label: Text('Col33')),
                  DataColumn(label: Text('Col22')),
                  DataColumn(label: Text('Col3')),
                  DataColumn(label: Text('Col33')),
                ],

                rows:data.map((data) =>
                    DataRow(
                        cells: [
                          DataCell(Container(width:20,child:Text(data.weekday,style: TextStyle(fontSize: 11),))),
                          DataCell(Container(width:20,child:Text(data.col1,style: TextStyle(fontSize: 11),))),
                          DataCell(Container(width:40,child:Text(data.col11,style: TextStyle(fontSize: 11),))),
                          DataCell(Container(width:50,child:Text(data.col2,style: TextStyle(fontSize: 11),))),
                          DataCell(Container(width:40,child:Text(data.col22,style: TextStyle(fontSize: 11),))),
                          DataCell(Container(width:60,child:Text(data.col3,style: TextStyle(fontSize: 11),))),
                          DataCell(Container(width:30,child:Text(data.col33,style: TextStyle(fontSize: 11),))),
                          DataCell(Container(width:40,child:Text(data.col4,style: TextStyle(fontSize: 11),))),
                          DataCell(Container(width:40,child:Text(data.col44,style: TextStyle(fontSize: 11),))),
                          DataCell(Container(width:20,child:Text(data.col5,style: TextStyle(fontSize: 12),))),
                        ]
                    )
                ).toList(),

              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator( valueColor:AlwaysStoppedAnimation<Color>(Colors.red),));
        },
      ),
    );
  }

  Future<List<_Panchang_DetailsData>> _fetchDetailsData() async {

    final url = 'https://bhagyodaycalendar.com/admin/api/panchang_details.php';
    var data = {'panchangid': widget.todo.id};
    var response = await http.post(Uri.parse(url), body: json.encode(data));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((job) => new _Panchang_DetailsData.fromJson(job))
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
        child: Container(
          margin: EdgeInsets.all(20),
          child: Table(
            defaultColumnWidth: FixedColumnWidth(120.0),
            border: TableBorder.all(
                color: Colors.black12, style: BorderStyle.solid, width: 2),
            children: [

              TableRow(children: [
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Text(
                      data[index].weekday,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ]),
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Text(
                      data[index].col1,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]),
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Text(
                      data[index].col11,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]),
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Text(
                      data[index].col2,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]),
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Text(
                      data[index].col22,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]),
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Text(
                      data[index].col3,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]),
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Text(
                      data[index].col33,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]),
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Text(
                      data[index].col4,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]),
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Text(
                      data[index].col44,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]),
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Text(
                      data[index].col5,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]),
              ]),
            ],
          ),
        ),
      ));
    },
  );
}
