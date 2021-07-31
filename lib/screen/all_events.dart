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
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';


class All_Events extends StatefulWidget {

  @override
  _All_EventsState createState() => _All_EventsState();
}

class EventsData {
  final String id;
  final String title;
  final String month;
  final String year;


  EventsData(
      {this.id,
        this.title,
        this.month,
        this.year,
      });

  factory EventsData.fromJson(Map<String, dynamic> json) {
    return EventsData(
      id: json['id'],
      title: json['title'],
      month: json['month'],
      year: json['year'],


    );
  }
}

class _All_EventsState extends State<All_Events> {
  var active='false',id;
  @override
  void initState() {
    super.initState();
    active='false';
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("All Events"),),
      drawer: AppDrawer(),
      body:SingleChildScrollView(child: Column(
          children: <Widget>[
            Container(height: height/13,
                child:
                FutureBuilder<List<EventsData>>(
                  future: _fetchEventsData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<EventsData> data = snapshot.data;
                      return Grid(context, data);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return Center(child: CircularProgressIndicator( valueColor:AlwaysStoppedAnimation<Color>(Colors.red),));
                  },
                )),
            active=='false'?
            Container(height: 250,
            ): Container(height: height/1.4,
                child:
                Events_Details(todo: id)),

          ])),
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

  Future<List<EventsData>> _fetchEventsData() async {
    SharedPreferences pf = await SharedPreferences.getInstance();
    String lang;
    if (pf.containsKey("language")) {
      lang = pf.getString("language");
      print(lang);
    } else {
      lang = "EN";
      print(lang);
    }
    final url = 'https://bhagyodaycalendar.com/admin/api/events.php';

    var data ={'language': lang };
    var response = await http.post(Uri.parse(url), body: json.encode(data));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => new EventsData.fromJson(job)).toList();
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
        onScroll: (position) =>  Events_Details(todo: id),
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


class Events_Details extends StatefulWidget {
  final todo;

  Events_Details({Key key, @required this.todo,}) : super(key: key);
  @override
  _Events_DetailsState createState() => _Events_DetailsState();
}

class Events_DetailsData {
  final String id;
  final String title;
  final String alleventsid;
final String 	eventon;

  Events_DetailsData(
      {this.id,
        this.title,
        this.alleventsid,
this.	eventon
      });

  factory Events_DetailsData.fromJson(Map<String, dynamic> json) {
    return Events_DetailsData(
      id: json['id'],
      title: json['title'],
      alleventsid: json['alleventsid'],
        eventon:json['eventon']

    );
  }
}

class _Events_DetailsState extends State<Events_Details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: FutureBuilder<List<Events_DetailsData>>(
        future: _fetchDetailsData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Events_DetailsData> data = snapshot.data;
            return Details(context, data);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator( valueColor:AlwaysStoppedAnimation<Color>(Colors.red),));
        },
      ),

    );

  }

  Future<List<Events_DetailsData>> _fetchDetailsData() async {
    final url = 'https://bhagyodaycalendar.com/admin/api/events_details.php';
    var data={
      'alleventsid':widget.todo.id
    };
    var response = await http.post(Uri.parse(url), body: json.encode(data));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => new Events_DetailsData.fromJson(job)).toList();
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

              height: 50.0,
              child:
              Card(child:  Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  data[index].title,
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 16.0),
                  overflow: TextOverflow.ellipsis,

                ),
              ),),




            ),
          ));
    },
  );
}




