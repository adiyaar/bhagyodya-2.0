import 'package:bhagyoday/themes/light_color.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';

class Advertise_Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar( title:Text("Advertise"),),
      body:
      AdvertiseDemo(),

    );
  }
}

class Job {
  final String url;
  final String title;

  Job({this.url,this.title});

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      url: json['image'],
      //title:json['title'],
    );
  }
}
class AdvertiseDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Job>>(
      future: _fetchJobs(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Job> data = snapshot.data;
          return imageSlider(context, data);

        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Center(child: CircularProgressIndicator( valueColor:AlwaysStoppedAnimation<Color>(LightColor.midnightBlue),));
      },
    );
  }

  Future<List<Job>> _fetchJobs() async {
    final jobsListAPIUrl = 'https://bhagyodaycalendar.com/admin/api/e_static.php?action=ecommerceadveritse';
    final response = await http.get(Uri.parse(jobsListAPIUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => new Job.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }
}
imageSlider(context,data) {
  final width = MediaQuery
      .of(context)
      .size
      .width;
  final height = MediaQuery
      .of(context)
      .size
      .height;
  final containerh = height / 2;
  return GridView.builder(
      itemCount: data.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: MediaQuery
              .of(context)
              .size
              .width /
              (MediaQuery
                  .of(context)
                  .size
                  .height / 3),
          crossAxisCount: 1),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {

          },
         /* child: Container(
            height: height / 3,
            width: width / 2,
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFFFECEFF1),
              ),
              borderRadius: BorderRadius.circular(13),
            ),*/
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    'https://bhagyodaycalendar.com/admin/admin/media/advertise/'+data[index].url,
                    fit: BoxFit.fill ,),


                ],
              ),
            ),
       //   ),
        );
      }
  );
}




