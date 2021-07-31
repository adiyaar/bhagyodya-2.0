import 'dart:convert' show json;
import 'dart:convert';
import 'package:bhagyoday/TodoList/todoform.dart';
import 'package:bhagyoday/screen/dateModel.dart';
import 'package:bhagyoday/themes/light_color.dart';
import 'package:bhagyoday/widgets/AppDrawer.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';

import 'Dialog.dart';
import 'articles.dart';
import 'blogs_screen.dart';
import 'home_screen.dart';

class Calender extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calendar',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(
        key: homePageKey,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

Map<String, String> specialdays = {};
GlobalKey<_HomePageState> homePageKey = new GlobalKey<_HomePageState>();
Map<String, List<dynamic>> data = {};
List<String> months = [
  // 'January',
  // 'February',
  // 'March',
  // 'April',
  // 'May',
  // 'June',
  // 'July',
  // 'August',
  // 'September',
  // 'October',
  // 'November',
  // 'December'
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '10',
  '11',
  '12'
];

// List<String> marathi = ['१'];
class _HomePageState extends State<HomePage> {
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  TextEditingController _eventController;
  SharedPreferences prefs;

  String year = DateTime.now().year.toString();

  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _eventController = TextEditingController();
    _events = {};
    _selectedEvents = [];
    // fetchdata();
    fetchimg();
    getspecial(2021);
    initPrefs();
    getData(2021);
  }

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _events = Map<DateTime, List<dynamic>>.from(
          decodeMap(json.decode(prefs.getString("events") ?? "{}")));
    });
  }

  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }

  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });
    return newMap;
  }

  Map<String, Color> specialDays = {
    "null": Colors.white,
    "amavasya": Colors.blue,
    "purnima": Colors.yellow,
    "ekadashi": Colors.orange,
    "chaturthi": Colors.pinkAccent[100]
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                fetchimg();
                _showDialog();
              },
              icon: Icon(Icons.calendar_today))
        ],
      ),
      drawer: AppDrawer(),

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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Todo_list_()));
          }
        },
      ),

      /*bottomNavigationBar: TitledBottomNavigationBar(
          currentIndex: 2, // Use this to update the Bar giving a position
          activeColor: Colors.red,
          onTap: (index){
            if(index==0){
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomeScreen()));
            }
            else if(index==1){
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Articles()));
            }
            else if(index==2){
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Calender()));
            }
            else if(index==3){
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Blogs()));
            }
            else if(index==4){

              Navigator.pushReplacement(
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
      ),*/

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: TableCalendar(
                events: _events,
                initialCalendarFormat: CalendarFormat.month,
                calendarStyle: CalendarStyle(
                    canEventMarkersOverflow: true,
                    todayColor: Colors.orange,
                    selectedColor: Theme.of(context).primaryColor,
                    todayStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.white)),
                headerStyle: HeaderStyle(
                  centerHeaderTitle: true,
                  formatButtonDecoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  formatButtonTextStyle: TextStyle(color: Colors.white),
                  formatButtonShowsNext: false,
                ),
                startingDayOfWeek: StartingDayOfWeek.monday,
                daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    weekendStyle: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                onDaySelected: (date, events, _) {
                  if (year != date.year.toString()) {
                    getData(date.year);
                    setState(() {
                      year = date.year.toString();
                    });
                  }
                  DateModel dateModel;

                  data[date.month.toString()].forEach((element) {
                    if (element["month"] == date.month.toString() &&
                        element["year"] == date.year.toString()) {
                      dateModel = DateModel.fromJson(element);
                    }
                  });
                  // var eve=jsonDecode(prefs.getString("events"));

                  setState(() {
                    _selectedEvents = events;
                    _openDialog(
                        dateModel,
                        date.day.toString(),
                        months[date.month - 1],
                        date.year.toString(),
                        _selectedEvents);
                  });
                },
                builders: CalendarBuilders(
                  dayBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: specialDays[specialdays[
                                "${date.year}-${date.month}-${date.day}"]
                            .toString()
                            .toLowerCase()
                            .trim()],
                        shape: BoxShape.circle),
                    child: Text(
                      // marathi[date.day -1],
                      date.day.toString(),
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  selectedDayBuilder: (context, date, events) => Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          //color: Colors.black,
                          shape: BoxShape.circle),
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(color: Colors.black),
                      )),
                  todayDayBuilder: (context, date, events) => Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.black, shape: BoxShape.circle),
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                calendarController: _controller,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                            color: Colors.blue, shape: BoxShape.circle),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        "Amavsya",
                        style: TextStyle(fontSize: 15.0),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                            color: Colors.yellow, shape: BoxShape.circle),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        "Purnima",
                        style: TextStyle(fontSize: 15.0),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                            color: Colors.orange, shape: BoxShape.circle),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        "Ekadashi",
                        style: TextStyle(fontSize: 15.0),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                            color: Colors.pinkAccent, shape: BoxShape.circle),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        "Chaturthi",
                        style: TextStyle(fontSize: 15.0),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'Daily Tasks',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                )),
            // ..._selectedEvents.where((element) => element["specialdays"] != null).toList().map((event) => Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 20),
            //     child: Container(color: Colors.blue,height: 100,width: 100,))),
            ..._selectedEvents.map((event) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        child: Text(
                      '13.00',
                      style: TextStyle(fontSize: 16),
                    )),
                    GestureDetector(
                      onLongPress: () {},
                      onTap: () {
                        //_awaitReturnValueFromAddEventForUpdate(event);
                      },
                      child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          width: 200,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(0, 2),
                                    blurRadius: 2.0)
                              ]),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                event,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ],
                          )),
                    )
                  ],
                ))),
            SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: showAddDialog,
      //   backgroundColor: Colors.black,
      // ),
    );
  }

  showAddDialog() async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: _eventController,
              ),
              actions: <Widget>[
                // ignore: deprecated_member_use
                FlatButton(
                  child: Text("Save"),
                  onPressed: () {
                    if (_eventController.text.isEmpty) return;
                    if (_events[_controller.selectedDay] != null) {
                      _events[_controller.selectedDay]
                          .add(_eventController.text);
                    } else {
                      _events[_controller.selectedDay] = [
                        _eventController.text
                      ];
                    }
                    prefs.setString("events", json.encode(encodeMap(_events)));
                    _eventController.clear();
                    Navigator.pop(context);
                  },
                )
              ],
            ));
    setState(() {
      _selectedEvents = _events[_controller.selectedDay];
      print("selected events " + _selectedEvents.toString());
    });
  }

  void getData(int year) async {
    for (int i = 1; i <= 12; i++) {
      print("index");
      addData(i, year);
    }

    print(data["4"]);
  }

  void getspecial(int year) async {
    for (int i = 1; i <= 12; i++) {
      print("index");
      fetchdata(i, year);
    }
  }

  void addData(month, year) async {
    SharedPreferences pf = await SharedPreferences.getInstance();
    String lang;
    if (pf.containsKey("language")) {
      lang = pf.getString("language");
      print(lang);
    } else {
      lang = "EN";
      print(lang);
    }
    var response = await http.get((Uri.parse(
        "https://bhagyodaycalendar.com/admin/api/calender.php?month=" +
            month.toString() +
            "&language=" +
            lang +
            "&year=" +
            year.toString())));
    print("I M RES");
    print(response.body.toString());
    if (response.statusCode == 200) {
      List resp = jsonDecode(response.body);

      data[month.toString()] = resp;

      resp.forEach((element) {
        if (_events[DateTime.parse(element['datee'] + "T12:00:00.000Z")] !=
            null) {
          _events[DateTime.parse(element['datee'] + "T12:00:00.000Z")]
              .add(element['eventname']);
        } else {
          _events[DateTime.parse(element['datee'] + "T12:00:00.000Z")] = [
            element['eventname']
          ];
        }
      });
      setState(() {});
    }
  }

  void fetchdata(month, year) async {
    var response = await http.get(Uri.parse(
        "https://bhagyodaycalendar.com/admin/api/specialcalender.php?month=" +
            month.toString() +
            "&year=" +
            year.toString()));

    List resp = jsonDecode(response.body);

    resp.forEach((element) {
      List d = element["datee"]
          .toString()
          .split("-")
          .map((e) => int.parse(e))
          .toList();

      return specialdays[("${d[0]}-${d[1]}-${d[2]}")] = element['specialdays'];
    });

    setState(() {});
  }

  var re;
  String calendarimage;
  fetchimg() async {
    SharedPreferences pf = await SharedPreferences.getInstance();
    String lang = pf.getString("language");
    
    
    re = await http.post(Uri.parse(
        "https://bhagyodaycalendar.com/admin/api/calenderimages.php?year=" +
            DateTime.now().year.toString() +
            "month=" +
            DateTime.now().month.toString() +
            "language=" +
            lang));
            

    print("WOWOWOWOWOWOW");

    print(re.body);
    print(jsonDecode(re.body)[0]["img"]);
    calendarimage = jsonDecode(re.body)[0]["img"];
    setState(() {});
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeInImage.assetNetwork(
                placeholder: 'assets/noimage.jpg',
                image:
                    'https://bhagyodaycalendar.com/admin/admin/media/calenderimages/' +
                        calendarimage,
                fit: BoxFit.fitWidth,
              ),
            ],
          ),
        );
      },
    );
  }

/*  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: Colors.black,
    ));
  }*/

  void _openDialog(dateModel, day, month, year, List events) {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) {
          return new FullScreenDialog(dateModel, day, month, year, events);
        },
        fullscreenDialog: true));
  }
}
