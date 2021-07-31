import 'dart:convert';

import 'package:bhagyoday/TodoList/todoform.dart';
import 'package:bhagyoday/screen/articles.dart';
import 'package:bhagyoday/screen/articles_detail.dart';
import 'package:bhagyoday/screen/blog_detail.dart';
import 'package:bhagyoday/screen/calendar_screen.dart';
import 'package:bhagyoday/screen/home_screen.dart';

import 'package:bhagyoday/themes/light_color.dart';
import 'package:bhagyoday/widgets/AppDrawer.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';

class Blogs extends StatefulWidget {
  @override
  _BlogsState createState() => _BlogsState();
}

class BlogsData {
  final String id;
  final String title;
  final String shortdescription;
  final String longdescription;
  final String datee;
  final String img;
  final String postedby;

  BlogsData(
      {this.id,
      this.title,
      this.shortdescription,
      this.longdescription,
      this.datee,
      this.img,
      this.postedby});

  factory BlogsData.fromJson(Map<String, dynamic> json) {
    return BlogsData(
        id: json['id'],
        title: json['title'],
        shortdescription: json['shortdescription'],
        longdescription: json['longdescription'],
        datee: json['datee'],
        img: json['img'],
        postedby: json['postedby']);
  }
}

class _BlogsState extends State<Blogs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Blogs"),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder<List<BlogsData>>(
          future: _fetchBlogsData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<BlogsData> data = snapshot.data;
              return Grid(context, data);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ));
          },
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
          initialActiveIndex: 3,//optional, default as 0

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

  Future<List<BlogsData>> _fetchBlogsData() async {
    SharedPreferences pf = await SharedPreferences.getInstance();
    String lang;
    if (pf.containsKey("language")) {
      lang = pf.getString("language");
      print(lang);
    } else {
      lang = "EN";
      print(lang);
    }
    final url = 'https://bhagyodaycalendar.com/admin/api/blogs.php';
    var data ={'language': lang };
    var response = await http.post(Uri.parse(url), body: json.encode(data));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => new BlogsData.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }
}

Grid(context, data) {
  return ListView.builder(
    scrollDirection: Axis.vertical,
    itemCount: data.length,
    itemBuilder: (context, index) {
      print(data[index]);
      return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BlogsDetails(todo: data[index])));
          },
          // var finalprice = data[index].price;
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white12,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[300], width: 1.5),
                    top: BorderSide(color: Colors.grey[300], width: 1.5),
                  )),
              height: 100.0,
              child: Row(
                children: <Widget>[
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
                                'https://bhagyodaycalendar.com/admin/admin/media/blogs/' +
                                    data[index].img),
                            fit: BoxFit.fill)),
                  ),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(top: 10.0, left: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(children: <Widget>[
                          Expanded(
                            child: Text(
                              data[index].title,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ]),
                        SizedBox(height: 5),
                        Container(
                          child: Text(
                            data[index].shortdescription,
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ))
                ],
              ),
            ),
          ));
    },
  );
}
