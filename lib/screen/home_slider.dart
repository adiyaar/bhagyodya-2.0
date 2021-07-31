import 'dart:convert';
import 'package:bhagyoday/TodoList/todoform.dart';
import 'package:bhagyoday/screen/About_Us.dart';
import 'package:bhagyoday/screen/all_events.dart';
import 'package:bhagyoday/screen/articles.dart';
import 'package:bhagyoday/screen/blogs_screen.dart';
import 'package:bhagyoday/screen/calendar_screen.dart';
import 'package:bhagyoday/screen/horoscope.dart';
import 'package:bhagyoday/screen/indian_festival.dart';
import 'package:bhagyoday/screen/indian_holidays.dart';
import 'package:bhagyoday/screen/panchang.dart';
import 'package:bhagyoday/screen/vivha.dart';
import 'package:bhagyoday/themes/light_color.dart';
import 'package:bhagyoday/utils/ui_helper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SliderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: tp());
  }
}

String lang;
void func1() async {
  SharedPreferences pf = await SharedPreferences.getInstance();

  print("11111111111111111111111");
  if (pf.containsKey("language")) {
    lang = pf.getString("language");
    print(lang);
  } else {
    lang = "EN";
    print(lang);
  }
}

class tp extends StatelessWidget {
  const tp({
    Key key,
  }) : super(key: key);

  @override
  void initState() {
    func1();
  }

  @override
  Widget build(BuildContext context) {
    func1();
    Map<String, String> languagepanchang = {
      "EN": "Panchang",
      "HI": "  पंचांग  ",
      "MA": "  पंचांग  ",
      "KA": " ಪಂಚಂಗ್"
    };

    Map<String, String> languagehoroscope = {
      "EN": "Horoscope",
      "HI": "  राशिफल ",
      "MA": "  कुंडली  ",
      "KA": "  ಜಾತಕ  "
    };

    Map<String, String> languagemahurat = {
      "EN": "Mahurat",
      "HI": "  मुहूर्तो  ",
      "MA": "  माहुरात ",
      "KA": "ಮಹುರತ್"
    };

    Map<String, String> languagetodo = {
      "EN": "  To-Do  ",
      "HI": "करने के लिए",
      "MA": "करण्यासाठी",
      "KA": " ಮಾಡಬ "
    };

    Map<String, String> languageBlogs = {
      "EN": "Blogs ",
      "HI": " ब्लॉग  ",
      "MA": " ब्लॉग  ",
      "KA": "ಬ್ಲಾಗ್‌ಗಳು"
    };

    Map<String, String> languageEvents = {
      "EN": "Events",
      "HI": "आयोजन",
      "MA": "कार्यक्रम",
      "KA": "ಕಾರ್ಯಕ"
    };

    Map<String, String> languageHolidays = {
      "EN": "Holidays",
      "HI": "छुट्टियां",
      "MA": "सुट्ट्या",
      "KA": "ರಜಾದಿನಗ"
    };

    Map<String, String> languageFestivals = {
      "EN": "Festivals",
      "HI": "समारोह",
      "MA": "सण",
      "KA": "ಹಬ್ಬಗಳು"
    };

    Widget bigCircle = new Container(
      height: 450.0,
      width: 360.0,
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new AssetImage('assets/bg1.png'),
          fit: BoxFit.cover,
        ),
      ),
    );

    return new Material(
      child: Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage('assets/bg1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: new Center(
          child: new Stack(
            children: <Widget>[
              bigCircle,

              new Positioned(
                left: 140.0,
                top: 160.0,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 75.0,
                      color: Colors.white,
                    ),
                    text: getCurrentDate(),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Calender()));
                      },
                  ),
                ),
              ),
              new Positioned(
                left: 140.0,
                top: 245.0,
                child: Row(
                  children: [
                    new Text(getcurrentmonth(),
                        style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          color: Colors.white,
                        )),
                    SizedBox(
                      width: 5.0,
                    ),
                    new Text(getcurrentyear(),
                        style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),

              new Positioned(
                top: 80.0,
                left: 100.0,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Panchang()));
                  },
                  child: Image.asset(
                    "assets/Panchang.png",
                    scale: 10.0,
                  ),
                ),
              ), //panchang
              new Positioned(
                top: 50.0,
                left: 90.0,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                    text: languagepanchang[lang],
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Panchang()));
                      },
                  ),
                ),
              ),

              new Positioned(
                top: 130.0,
                left: 20.0,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Ind_Festivals()));
                  },
                  child: Image.asset(
                    "assets/Festivals.png",
                    scale: 9.0,
                  ),
                ),
              ), //holidays
              new Positioned(
                top: 190.0,
                left: 20.0,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                    text: languageFestivals[lang],
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Ind_Festivals()));
                      },
                  ),
                ),
              ),

              new Positioned(
                top: 240.0,
                left: 20.0,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Ind_Holidays()));
                  },
                  child: Image.asset(
                    "assets/Holidays.png",
                    scale: 9.0,
                  ),
                ),
              ), //festivals
              new Positioned(
                top: 300.0,
                left: 15.0,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                    text: languageHolidays[lang],
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Ind_Holidays()));
                      },
                  ),
                ),
              ),

              new Positioned(
                top: 75.0,
                right: 97.0,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Horoscope()));
                  },
                  child: Image.asset(
                    "assets/Horoscope.png",
                    scale: 8.0,
                  ),
                ),
              ), //horoscope
              new Positioned(
                top: 50.0,
                right: 80.0,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                    text: languagehoroscope[lang],
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Horoscope()));
                      },
                  ),
                ),
              ),

              new Positioned(
                bottom: 70.0,
                left: 100.0,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => All_Events()));
                  },
                  child: Image.asset(
                    "assets/Events.png",
                    scale: 9.0,
                  ),
                ),
              ), //events
              new Positioned(
                bottom: 40.0,
                left: 103.0,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                    text: languageEvents[lang],
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => All_Events()));
                      },
                  ),
                ),
              ),

              new Positioned(
                bottom: 70.0,
                right: 95.0,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Blogs()));
                  },
                  child: Image.asset(
                    "assets/blogs-2.png",
                    scale: 7.8,
                  ),
                ),
              ), //blogs
              new Positioned(
                right: 105.0,
                bottom: 40.0,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                    text: languageBlogs[lang],
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Blogs()));
                      },
                  ),
                ),
              ),

              new Positioned(
                top: 130.0,
                right: 30.0,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Vivha()));
                  },
                  child: Image.asset(
                    "assets/Vivah-2.png",
                    scale: 9.0,
                  ),
                ),
              ), //vivah
              new Positioned(
                top: 190.0,
                right: 23.0,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                    text: languagemahurat[lang],
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Vivha()));
                      },
                  ),
                ),
              ),

              new Positioned(
                top: 240.0,
                right: 30.0,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Todo_list_()));
                  },
                  child: Image.asset(
                    "assets/To-Do.png",
                    scale: 9.0,
                  ),
                ),
              ), //todolist
              new Positioned(
                top: 300.0,
                right: 30.0,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                    text: languagetodo[lang],
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Todo_list_()));
                      },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Job {
  final String img;

  Job({
    this.img,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      img: json['img'],
    );
  }
}

String getCurrentDate() {
  var date = DateTime.now().toString();

  var dateParse = DateTime.parse(date);

  var formattedDate = "${dateParse.day}";
  return formattedDate.toString();
}

String getcurrentyear() {
  var date = DateTime.now().toString();

  var dateParse = DateTime.parse(date);

  var formattedDate = "${dateParse.year}";
  return formattedDate.toString();
}

String getcurrentmonth() {
  var date = DateTime.now().toString();

  var dateParse = DateTime.parse(date);

  var formattedDate = "${dateParse.month}";
  if (formattedDate == '1') {
    return "January";
  }
  if (formattedDate == '2') {
    return "February";
  }
  if (formattedDate == '3') {
    return "March";
  }
  if (formattedDate == '4') {
    return "April";
  }
  if (formattedDate == '5') {
    return "May";
  }
  if (formattedDate == '6') {
    return "June";
  }
  if (formattedDate == '7') {
    return "July";
  }
  if (formattedDate == '8') {
    return "August";
  }
  if (formattedDate == '9') {
    return "September";
  }
  if (formattedDate == '10') {
    return "October";
  }
  if (formattedDate == '11') {
    return "November";
  }
  if (formattedDate == '12') {
    return "December";
  }
}

class SliderDemo extends StatelessWidget {
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
        return Center(
            child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
        ));
      },
    );
  }

  Future<List<Job>> _fetchJobs() async {
    final jobsListAPIUrl =
        'https://bhagyodaycalendar.com/admin/api/e_static.php?action=slider';
    final response = await http.get(Uri.parse(jobsListAPIUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => new Job.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }
}

Swiper imageSlider(context, data) {
  return new Swiper(
    autoplay: true,
    itemCount: data.length,
    itemBuilder: (BuildContext context, int index) {
      return new Image.network(
        'https://bhagyodaycalendar.com/admin/admin/media/slider/' +
            data[index].img,
        fit: BoxFit.fitWidth,
        width: 300,
      );
    },
    //viewportFraction: 0.2,
    scale: 1.0,
  );
}

class footer extends StatelessWidget {
  const footer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      padding: const EdgeInsets.all(15.0),
      height: 400.0,
      color: Colors.grey[200],
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Bhagyoday',
                style: GoogleFonts.montserrat(
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[400],
                  letterSpacing: 0.2,
                  height: 1.0,
                ),
              ),
              UIHelper.verticalSpaceLarge(),
              Text(
                'Bhagyoday',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Colors.grey),
              ),
              Text(
                '',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Colors.grey),
              ),
              UIHelper.verticalSpaceExtraLarge(),
              Row(
                children: <Widget>[
                  Container(
                    height: 1.0,
                    width: MediaQuery.of(context).size.width / 4,
                    color: Colors.grey,
                  ),
                ],
              )
            ],
          ),
          Positioned(
            left: 220.0,
            top: -50.0,
            child: Image.asset(
              'assets/hath.png',
              height: 250.0,
              width: 250.0,
            ),
          )
        ],
      ),
    );
  }
}
