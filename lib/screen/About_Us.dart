import 'package:bhagyoday/screen/home_joinus_view.dart';
import 'package:bhagyoday/screen/home_slider.dart';
import 'package:bhagyoday/widgets/AppDrawer.dart';
import 'package:bhagyoday/widgets/custom_divider_view.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';

import 'home_vision_mission_banner_view.dart';

class About_Us_Screen extends StatefulWidget {
  @override
  _About_UsScreen createState() => _About_UsScreen();
}

class _About_UsScreen extends State<About_Us_Screen> {
  static const routeName = "/";

// Receiving Email using Constructor.

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("About Us"),
      ),
      drawer: AppDrawer(),
      body: Refund(),
    );
  }
}

class StaticPage {
  final String content;

  StaticPage({this.content});

  factory StaticPage.fromJson(Map<String, dynamic> json) {
    return StaticPage(
      content: json['content'],
    );
  }
}

class Refund extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<StaticPage>>(
      future: _fetchStaticPage(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<StaticPage> data = snapshot.data;
          return imageSlider(context, data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Center(
            child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
        ));
      },
    );
  }

  Future<List<StaticPage>> _fetchStaticPage() async {
    final jobsListAPIUrl = 'https://bhagyodaycalendar.com/admin/api/e_static.php?action=e_staticpages_aboutus';
    final response = await http.get(Uri.parse(jobsListAPIUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => new StaticPage.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }
}

imageSlider(context, data) {
  return Container(
    child: ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: data.length,
      itemBuilder: (context, index) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset("assets/aboutus.jpeg"),
              Html(
                data: data[index].content,
              ),


              visionmissionBannerView(),
              CustomDividerView(),

              Container(
                constraints: BoxConstraints.expand(height: 200),
                child: SliderDemo(),
              ),
              SizedBox(
                height: 10,
              ),
              joinusview(),
              CustomDividerView(),
              footer(),
            ]);
      },
    ),
  );
}
