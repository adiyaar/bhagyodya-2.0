import 'package:bhagyoday/TodoList/todoform.dart';
import 'package:bhagyoday/screen/About_Us.dart';
import 'package:bhagyoday/screen/Contact_Us.dart';
import 'package:bhagyoday/screen/Privacy_Policy.dart';
import 'package:bhagyoday/screen/Terms_Condition.dart';
import 'package:bhagyoday/screen/advertise_screen.dart';
import 'package:bhagyoday/screen/all_events.dart';
import 'package:bhagyoday/screen/articles.dart';
import 'package:bhagyoday/screen/blogs_screen.dart';
import 'package:bhagyoday/screen/calendar_screen.dart';
import 'package:bhagyoday/screen/faq_screen.dart';
import 'package:bhagyoday/screen/home_screen.dart';
import 'package:bhagyoday/screen/horoscope.dart';
import 'package:bhagyoday/screen/indian_festival.dart';
import 'package:bhagyoday/screen/indian_holidays.dart';
import 'package:bhagyoday/screen/logout.dart';
import 'package:bhagyoday/screen/next_yr_events.dart';
import 'package:bhagyoday/screen/panchang.dart';
import 'package:bhagyoday/screen/vivha.dart';
import 'package:bhagyoday/themes/light_color.dart';
import 'package:bhagyoday/widgets/custom_divider_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  //final String email;
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  var username;
  //var userid;
  var id;
  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String useridValue = prefs.getString('userid');
    print(useridValue);
    //return useridValue;
    setState(() {
      username = prefs.getString("email");
      id = prefs.getString('userid');
    });
  }

  getStringValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String useridValue = prefs.getString('id');
    print(useridValue);
    //return useridValue;
    setState(() {
      // username = prefs.getString("email");
      id = prefs.getString('id');
    });
  }

  @override
  void initState() {
    super.initState();
    getStringValuesSF();
    getStringValues();
  }

  Widget build(BuildContext context) {
    // TODO: implement build

    return Drawer(
        child: ListView(
      children: <Widget>[
        Container(
          color:Color(0xffDA251C),

          child: Column(
            children: [
              Image(
                image: AssetImage('assets/drawerlogo.jpeg'),
                height: 150.0,
                width: 250.0,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "info@bhagyoday.com",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10.0,),
            ],
          ),
        ),
        Divider(),
        //  DrawerHeader(

        //   child: Container(
        //     child: Text('${email}', style: TextStyle(color: Colors.white.withOpacity(1.0)),),
        //     alignment: Alignment.bottomLeft, // <-- ALIGNMENT
        //    height: 10,
        //    ),
        //  decoration: BoxDecoration(
        //       color: midnightBlue
        //   ),
        //   ),
        Divider(),


        ListTile(
          leading: new Image.asset("assets/Drawer/allcategories.png",
              width: 20.0, color: LightColor.red),
          title: Text('Home',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),


        ListTile(
          leading: new Image.asset("assets/Drawer/mahrat.png",
              width: 25.0),

          title: Text('Mahurat',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Vivha()));
          },
        ),
        ListTile(
          leading: new Image.asset("assets/Drawer/horoscope.png",
              width: 25.0),

          title: Text('Horoscope',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Horoscope()));
          },
        ),
        ListTile(
          leading: new Image.asset("assets/Drawer/panchang.png",
              width: 23.0),
          title: Text('Panchang',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Panchang()));
          },
        ),
        CustomDividerView(),

        ListTile(
          leading: new  Icon(Icons.event,
              size: 25.0, color: LightColor.red),
          title: Text('Calender',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Calender()));
          },
        ),
        ListTile(
          leading: new  Icon(Icons.art_track,
              size: 25.0, color: LightColor.red),
          title: Text('Articles',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Articles()));
          },
        ),
        ListTile(
          leading: new Image.asset("assets/Drawer/blogs.png",
              width: 25.0),
          title: Text('Blogs',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Blogs()));
          },
        ),
        ListTile(
          leading: new Image.asset("assets/Drawer/todo.png",
              width: 25.0),
          title: Text('Todo List',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Todo_list_()));
          },
        ),

        ListTile(
          leading: new Image.asset("assets/Drawer/events.png",
              width: 25.0),
          title: Text('All Events',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => All_Events()));
          },
        ),

        ListTile(
          leading: new Image.asset("assets/Drawer/holidays.png",
              width: 25.0),
          title: Text('Indian Holidays',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Ind_Holidays()));
          },
        ),
        ListTile(
          leading: new Image.asset("assets/Drawer/festivals.png",
              width: 25.0),
          title: Text('Indian Festivals',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Ind_Festivals()));
          },
        ),

        ListTile(
          leading: new  Icon(Icons.next_week,
              size: 25.0, color: LightColor.red),
          title: Text('Next Year Events',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Next_yr_events()));
          },
        ),
        CustomDividerView(),

        ListTile(
          leading: new Image.asset("assets/Drawer/aboutus.png",
              width: 20.0, color: LightColor.red),
          title: Text('About Us',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => About_Us_Screen()));
          },
        ),

        ListTile(
          leading: new Image.asset("assets/Drawer/contactus.png",
              width: 20.0, color: LightColor.red),
          title: Text('Contact Us',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Contact_Us()));
          },
        ),

        CustomDividerView(),
        ListTile(
          leading: new Image.asset("assets/Drawer/advertise.png",
              width: 20.0, color: LightColor.red),
          title: Text('Advertise',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Advertise_Screen()));
          },
        ),
        ListTile(
          leading: new  Icon(Icons.rate_review,
              size: 25.0, color: LightColor.red),
          title: Text('Rate App',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          onTap: () {


          },
        ),
        ListTile(
          leading: new  Icon(Icons.share,
              size: 25.0, color: LightColor.red),
          title: Text('Share App',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          onTap: () {

          },
        ),
        ListTile(
          leading: new  Icon(Icons.line_style,
              size: 25.0, color: LightColor.red),
          title: Text('FAQ',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => faq()));
          },
        ),
        ListTile(
          leading: new Image.asset("assets/Drawer/terms.png",
              width: 20.0, color: LightColor.red),
          title: Text('Terms & Condition',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => TermsScreen()));
          },
        ),

        ListTile(
          leading: new Image.asset("assets/Drawer/privacy.png",
              width: 20.0, color: LightColor.red),
          title: Text('Privacy Policy',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => PolicyScreen()));
          },
        ),


      ],
    ));
  }
}
