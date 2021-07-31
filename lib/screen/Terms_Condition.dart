import 'dart:convert';
import 'package:bhagyoday/screen/home_slider.dart';
import 'package:bhagyoday/widgets/AppDrawer.dart';
import 'package:bhagyoday/widgets/custom_divider_view.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class StaticPage {

  final String content;

  StaticPage({this.content});

  factory StaticPage.fromJson(Map<String, dynamic> json) {
    return StaticPage(

      content:json['content'],
    );
  }
}
class TermsScreen extends StatefulWidget {


  @override
  _TermsStateScreen createState() => _TermsStateScreen();
}

class _TermsStateScreen extends State<TermsScreen> {


  static const routeName = "/";


// Receiving Email using Constructor.

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Terms And Condition"),

      ),
      drawer: AppDrawer(),
body:TermsDemo(),
    );

  }
}
class TermsDemo extends StatelessWidget {
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
        return CircularProgressIndicator();
      },
    );
  }

  Future<List<StaticPage>> _fetchStaticPage() async {
    final jobsListAPIUrl = 'https://bhagyodaycalendar.com/admin/api/e_static.php?action=e_staticpages_terms';
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
        Html(
        data: data[index].content,
        ),

              CustomDividerView(),
              footer(),

      ]  );
        // var finalprice = data[index].price;
       /* return Padding(
          padding: EdgeInsets.all(5.0),
          child: Container(

            child: Row(
              children: <Widget>[

                Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10.0, left: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  data[index].content,
                                  style: TextStyle(fontWeight: FontWeight
                                      .w600, fontSize: 15.0)),
                              ),
                              Container(
                                alignment: Alignment.bottomRight,




                              )

                            ],
                          ),

                          SizedBox(height: 5.0,),


                        ],
                      ),
                    )
                )
              ],
            ),
          ),
        );*/
      },

    ),


  );

}


