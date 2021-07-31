import 'package:bhagyoday/themes/light_color.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class faqItem {
  final String answer;
  final String question;
  final String id;

  faqItem({
    this.answer,
    this.question,
    this.id,
  });

  factory faqItem.fromJson(Map<String, dynamic> json) {
    return faqItem(
      id: json['id'],
      answer: json['answer'],
      question: json['question'],
    );
  }
}

class faq extends StatefulWidget {
  @override
  _faqState createState() => _faqState();
}

class _faqState extends State<faq> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("FAQ")),
      body: FutureBuilder<List<faqItem>>(
        future: _fetchCartItem(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<faqItem> data = snapshot.data;
            if (snapshot.data.length == 0) {
              return Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 80),
                  child: Image.asset("assets/cart.png"));
            }

            return imageSlider(context, data);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(LightColor.midnightBlue),
          ));
        },
      ),
    );
  }

  Future<List<faqItem>> _fetchCartItem() async {
    var url = 'https://bhagyodaycalendar.com/admin/api/faq.php';
    var response = await http.post(Uri.parse(url));

    List jsonResponse = json.decode(response.body);

    return jsonResponse.map((item) => new faqItem.fromJson(item)).toList();
  }

  imageSlider(context, data) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: data.length,
      itemBuilder: (context, index) {
        return ExpansionTile(
          // leading: Icon(FontAwesomeIcons.sign),
          title: Text(data[index].question),
          // subtitle: Text("  Sub Title's"),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(17.0),
              child: Text(
                data[index].answer,
                style: TextStyle(fontSize: 13),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        );
      },
    );
  }
}
