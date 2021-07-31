import 'dart:convert';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:intl/intl.dart';
import 'package:bhagyoday/screen/articles.dart';
import 'package:bhagyoday/screen/blogs_screen.dart';
import 'package:bhagyoday/screen/calendar_screen.dart';
import 'package:bhagyoday/screen/home_screen.dart';
import 'package:bhagyoday/themes/light_color.dart';
import 'package:bhagyoday/widgets/AppDrawer.dart';
import 'package:date_format/date_format.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

List reminddata=List();
class Todo_list_ extends StatefulWidget {
 @override
  _Todo_list_State createState() => _Todo_list_State();
}

class ToDoData {
  final String id;
  final String title;
  final String description;
  final String remind_on_date;
  final String remind_on_time;

  ToDoData(
      {this.id,
        this.title,
        this.description,
        this.remind_on_date,
        this.remind_on_time,
      });

  factory ToDoData.fromJson(Map<String, dynamic> json) {
    return ToDoData(
      id: json['id'],
      title: json['title'],
     description: json['description'],
      remind_on_date: json['remind_on_date'],
      remind_on_time: json['remind_on_time'],

    );
  }
}

class _Todo_list_State extends State<Todo_list_> {
  String _setTime, _setDate;
  getStringValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String

    String user_id = prefs.getString('id');
    return user_id;
  }

  String _hour, _minute, _time;

  String dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  TextEditingController _todoController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light().copyWith(
                primary: Colors.red,
              ),
            ),
            child: child,
          );}

    );
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light().copyWith(
                primary: Colors.red,
              ),
            ),
            child: child,
          );}
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }
  Future getreminddata() async {
    var url = 'https://bhagyodaycalendar.com/admin/api/dropdown_remind.php';

    var response = await http.post(Uri.parse(url), );
    // print(selectedvalue);

    var jsondata = json.decode(response.body);

    setState(() {
      reminddata = jsondata;
    });
    // }
  }
  @override
  void initState() {
    _dateController.text = DateFormat.yMd().format(DateTime.now());

    _timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
    super.initState();getStringValues();getreminddata();
  }

  void _pushAddTodoScreen() {
    // Push this page onto the stack
    String remind;


    Navigator.of(context).push(
      // MaterialPageRoute will automatically animate the screen entry, as well
      // as adding a back button to close it
        new MaterialPageRoute(
            builder: (context) {
              final width = MediaQuery.of(context).size.width;
              final height=MediaQuery.of(context).size.height;
              dateTime = DateFormat.yMd().format(DateTime.now());
              var _value;
              return new Scaffold(
                  appBar: new AppBar(
                      title: new Text('Add a new task'),

                  ),

                  body:Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SingleChildScrollView(child:
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                        Container(
                        width: width / 3,
                        height: height / 19,
                        child:Text("Select Date",style:TextStyle(fontWeight: FontWeight.bold, fontSize: 15,color: Colors.red) ,),
                        ),
                      Container(
                          width: width / 3,
                          height: height / 19,
                          child: Text("Select Time",style:TextStyle(fontWeight: FontWeight.bold, fontSize: 15,color: Colors.red) ,),
                      ) ]),
                        Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                _selectDate(context);
                              },
                              child: Container(
                                width: width / 3,
                                height: height / 19,
                                alignment: Alignment.center,
                               // decoration: BoxDecoration(color: Colors.grey[100]),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: TextFormField(
                                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,),
                                    textAlign: TextAlign.center,
                                    enabled: false,
                                    keyboardType: TextInputType.text,
                                    controller: _dateController,
                                    onSaved: (String val) {
                                      setState(() {
                                        _setDate = val;
                                      });

                                    },
                                    decoration: InputDecoration(
                                        disabledBorder:
                                        UnderlineInputBorder(borderSide: BorderSide.none),
                                        // labelText: 'Time',
                                        contentPadding: EdgeInsets.only(top: 0.0)),
                                  ),
                                ),
                              ),
                            ),

                            InkWell(
                              onTap: () {
                                _selectTime(context);
                              },
                              child: Container(

                                width: width / 3,
                                height: height / 19,
                                alignment: Alignment.center,
                               // decoration: BoxDecoration(color: Colors.grey[100]),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,),
                                    textAlign: TextAlign.center,
                                    onSaved: (String val) {

                                      _setTime = val;


                                    },
                                    enabled: false,
                                    keyboardType: TextInputType.text,
                                    controller: _timeController,
                                    decoration: InputDecoration(
                                        disabledBorder:
                                        UnderlineInputBorder(borderSide: BorderSide.none),
                                        // labelText: 'Time',
                                        contentPadding: EdgeInsets.all(5)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30,),
                        Text(
                          "Enter Notes",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,color: Colors.red),
                        ),
                        TextField(
                            maxLines: 4,
                            keyboardType: TextInputType.multiline,
                            controller: _todoController,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                fillColor: Color(0xfff3f3f4),
                                filled: true)
                        ),
                        SizedBox(height: 10,),
                        DropdownButton(
                          value: remind,
                          hint: Text("Remind me on"),
                          items: reminddata.map(
                                (list) {
                              return DropdownMenuItem(
                                  child: SizedBox(
                                    width: width/1.2,
                                    child: Text(list['remind_data']),
                                  ),
                                  value: list['id']);
                            },
                          ).toList(),
                          onChanged: (value) {
                            setState(() {
                              remind = value;
print(remind);
                            });
                          },
                        ),

SizedBox(height: 100,),
                        ButtonTheme(
                            minWidth: 400.0,
                            height: 40.0,
                            child: RaisedButton(
                              onPressed: () {
                                _addTodoItem(_todoController.text,_dateController.text,_timeController.text);
                                _todoController.clear();
                                Navigator.pop(context);
                              },
                              color: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text("Save Notes",
                                  style: TextStyle(
                                      color:Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                            )),


                    ]),
                  )
              ));

            }

        )

    );
  }
  Future _addTodoItem( task,setdate,settime) async{
    // Only add the task if the user actually entered something
    dynamic user_id = await getStringValues();
    var data = {
     'task':task,
      'Date':setdate,
      'Time':settime,
      'user_id':user_id
    };
    var url = 'https://bhagyodaycalendar.com/admin/api/add_todo.php';

    var response = await http.post(Uri.parse(url), body: json.encode(data));
    var message = jsonDecode(response.body);
    setState(() {
      _fetchToDoData();
    });

  }
  Future removetodo(id) async {
    print(id);


    var url = 'https://bhagyodaycalendar.com/admin/api/remove_todo.php';
    var data = { 'id': id};
    var response = await http.post(Uri.parse(url), body: json.encode(data));
    var message = jsonDecode(response.body);
    setState(() {
      _fetchToDoData();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("TODO"),),
        drawer: AppDrawer(),

        body: FutureBuilder<List<ToDoData>>(
          future: _fetchToDoData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<ToDoData> data = snapshot.data;
              return Grid(context, data);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(child: CircularProgressIndicator( valueColor:AlwaysStoppedAnimation<Color>(Colors.red),));
          },
        ),
        floatingActionButton: new FloatingActionButton(
            onPressed:_pushAddTodoScreen,
            backgroundColor: LightColor.red,
            tooltip: 'Add task',
            child: new Icon(Icons.add,color: Colors.white,)
        ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor:LightColor.red,
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.art_track, title: 'Articles'),
          TabItem(icon: Icons.event, title: 'Calender'),
          TabItem(icon: Icons.library_books, title: 'Blogs'),
          TabItem(icon: Icons.list, title: 'To-Do'),
        ],
        initialActiveIndex: 4,//optional, default as 0

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
      ),
    );

  }

  Future<List<ToDoData>> _fetchToDoData() async {
    final url = 'https://bhagyodaycalendar.com/admin/api/todo.php';
    dynamic user_id = await getStringValues();
    var data={
      'user_id':user_id
    };
    var response = await http.post(Uri.parse(url), body: json.encode(data));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => new ToDoData.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }
  Grid(context, data) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: data.length,
      itemBuilder: (context, index) {
        print(data[index]);
        return Card(

          child:Column(
            children:<Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:<Widget> [
Container(height: 50,width: 150,
            child:    Padding(
              padding: const EdgeInsets.only(top: 15,left: 15),
              child: Text(data[index].title,style: TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.bold),),
            ),),
         SizedBox(width: 50,),
                Container(height: 50,alignment: Alignment.topRight,
                    child:Row( children:<Widget> [
                IconButton(
                  icon: Icon(Icons.edit,color:Colors.green),
                  onPressed: () => {
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => EditToDo(todo: data[index])))
                  },
                ),

                IconButton(
                  icon: Icon(Icons.delete,color: Colors.red,),
                  onPressed: () => {
                  removetodo(data[index].id),
                },
                )]))
              ]),
            Row(mainAxisAlignment: MainAxisAlignment.end,
                children:<Widget> [
Text('${data[index].remind_on_date} / ${data[index].remind_on_time}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w900,color: Colors.black),),
                ]),
              SizedBox(height: 10,)
        ]));
      },
    );
  }
}


class EditToDo extends StatefulWidget {
  final todo;

  EditToDo({Key key, @required this.todo}) : super(key: key);

  @override
  _EditToDoState createState() => _EditToDoState();
}

class _EditToDoState extends State<EditToDo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future edittodo(id) async {
    print(title);


    var url = 'https://bhagyodaycalendar.com/admin/api/edit_todo.php';
    var data = { 'id': id,'title':title,'date':_dateController.text,'time':_timeController.text};
    var response = await http.post(Uri.parse(url), body: json.encode(data));
    var message = jsonDecode(response.body);

  }
  @override
  void initState() {
    _dateController.text = widget.todo.remind_on_date;

    _timeController.text = widget.todo.remind_on_time;
    super.initState();
  }
  String _hour, _minute, _time,setTime,setDate;

  String dateTime,title;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  TextEditingController _todoController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light().copyWith(
                primary: Colors.red,
              ),
            ),
            child: child,
          );}

    );
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light().copyWith(
                primary: Colors.red,
              ),
            ),
            child: child,
          );}
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }
  @override
  Widget build(BuildContext context) {
    //List<int> sizeList = [7, 8, 9, 10];
    Color cyan = Color(0xff37d6ba);
    //List<Color> colorsList = [Colors.black, Colors.blue, Colors.red];
    final width = MediaQuery.of(context).size.width;
    final height=MediaQuery.of(context).size.height;
    int itemCount = 0;
    var _value;title=widget.todo.title;setTime=widget.todo.remind_on_time;setDate=widget.todo.remind_on_date;
    return Scaffold(
        key: _scaffoldKey,
        // backgroundColor: LightColor.yellowColor,
        appBar: AppBar(
          title: Text('Edit Todo'),

          // backgroundColor: LightColor.whiteColor,
        ),
        body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(child:
            Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                                      Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              width: width / 3,
                                              height: height / 19,
                                              child:Text("Select Date",style:TextStyle(fontWeight: FontWeight.bold, fontSize: 15,color: Colors.red) ,),
                                            ),
                                            Container(
                                              width: width / 3,
                                              height: height / 19,
                                              child: Text("Select Time",style:TextStyle(fontWeight: FontWeight.bold, fontSize: 15,color: Colors.red) ,),
                                            ) ]),
                                      Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          InkWell(
                                            onTap: () {
                                              _selectDate(context);
                                            },
                                            child: Container(
                                              width: width / 3,
                                              height: height / 19,
                                              alignment: Alignment.center,
                                              // decoration: BoxDecoration(color: Colors.grey[100]),
                                              child: Padding(
                                                padding: const EdgeInsets.only(bottom: 10),
                                                child: TextFormField(
                                                  style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,),
                                                  textAlign: TextAlign.center,
                                                  enabled: false,
                                                 // initialValue: setDate,
                                                  keyboardType: TextInputType.text,
                                               controller: _dateController,
                                                  onSaved: (String val) {
                                                    setState(() {
                                                      setDate = _dateController.text;
                                                    });
                                                  },
                                                  decoration: InputDecoration(
                                                      disabledBorder:
                                                      UnderlineInputBorder(borderSide: BorderSide.none),
                                                      // labelText: 'Time',
                                                      contentPadding: EdgeInsets.only(top: 0.0)),
                                                ),
                                              ),
                                            ),
                                          ),

                                          InkWell(
                                            onTap: () {
                                              _selectTime(context);
                                            },
                                            child: Container(

                                              width: width / 3,
                                              height: height / 19,
                                              alignment: Alignment.center,
                                              // decoration: BoxDecoration(color: Colors.grey[100]),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: TextFormField(
                                                  style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,),
                                                  textAlign: TextAlign.center,
                                                  onSaved: (String val) {

                                                    setState(() {
                                                      setTime = val;
                                                    });


                                                  },
                                                 // initialValue:setTime,
                                                  enabled: false,
                                                  keyboardType: TextInputType.text,
                                                  controller: _timeController,
                                                  decoration: InputDecoration(
                                                      disabledBorder:
                                                      UnderlineInputBorder(borderSide: BorderSide.none),
                                                      // labelText: 'Time',
                                                      contentPadding: EdgeInsets.all(5)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 30,),
                                      Text(
                                        "Enter Notes",
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,color: Colors.red),
                                      ),
                                      TextFormField(
                                          maxLines: 4,
                                          keyboardType: TextInputType.multiline,
                                          initialValue:title ,
                                         // controller: _todoController,
                                          onChanged: (text) {
                                            title=text;



                                          },
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              fillColor: Color(0xfff3f3f4),
                                              filled: true)
                                      ),
                                      SizedBox(height: 10,),
                                     /* DropdownButton(
                                        value: remind,
                                        hint: Text("Remind me on"),
                                        items: reminddata.map(
                                              (list) {
                                            return DropdownMenuItem(
                                                child: SizedBox(
                                                  width: width/1.2,
                                                  child: Text(list['remind_data']),
                                                ),
                                                value: list['id']);
                                          },
                                        ).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            remind = value;
                                            print(remind);
                                          });
                                        },
                                      ),*/

                                      SizedBox(height: 100,),
                                      ButtonTheme(
                                          minWidth: 400.0,
                                          height: 40.0,
                                          child: RaisedButton(
                                            onPressed: () {

                                              edittodo(widget.todo.id);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => Todo_list_()));
                                            },
                                            color: Colors.red,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10)),
                                            child: Text("Save Notes",
                                                style: TextStyle(
                                                    color:Colors.white,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold)),
                                          )),

                                    ]))));


  }
}




