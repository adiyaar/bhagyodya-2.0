import 'dart:convert';
import 'package:bhagyoday/themes/light_color.dart';
import 'package:bhagyoday/widgets/AppDrawer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Contact_Us extends StatefulWidget {
  @override
  _Contact_Us_State createState() => _Contact_Us_State();
}

class _Contact_Us_State extends State<Contact_Us> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final msgController = TextEditingController();
  Future usermsg() async {
    String firstname = fnameController.text;
    String lastname = lnameController.text;
    String mobileno = mobileController.text;
    String email = emailController.text;
    String msg = msgController.text;
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (mobileno.length != 8) {
      showInSnackBar("Invalid Mobile No");
      //showToast('Invalid Mobile No', gravity: Toast.BOTTOM, duration: 3);
    } else if (firstname.length == 0 ||
        lastname.length == 0 ||
        msg.length == 0) {
      showInSnackBar("Field Should not be empty");
    } else if (!regex.hasMatch(email)) {
      showInSnackBar("Enter Valid Email");
    } else {
      // SERVER API URL
      var url = 'https://bhagyodaycalendar.com/admin/api/contactform.php';

      // Store all data with Param Name.
      var data = {
        'firstname': firstname,
        'lastname': lastname,
        'mobileno': mobileno,
        'email': email,
        'msg': msg,
      };

      // Starting Web API Call.
      var response = await http.post(Uri.parse(url), body: json.encode(data));

      // Getting Server response into variable.
      var message = jsonDecode(response.body);

      // If Web call Success than Hide the CircularProgressIndicator.

      showInSnackBar(message);
      fnameController.clear();
      lnameController.clear();
      mobileController.clear();
      emailController.clear();
      msgController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // backgroundColor: LightColor.yellowColor,
      appBar: AppBar(
        title: Text("Contact Us"),

        // backgroundColor: LightColor.midnightBlue,
      ),
      drawer: AppDrawer(),
      body: new SingleChildScrollView(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Text(
                "We're always eager to hear from you!",
                style: TextStyle(
                    fontSize: 24,
                    color: LightColor.midnightBlue,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Text(
                "Our customers always come first. We will take time to listen to you and respond to your needs. We will be happy to get any feedback that can improve/motivate us to better our services to you.",
                style: TextStyle(fontSize: 14, color: LightColor.midnightBlue),
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
              ),
            ),
            SizedBox(height: 20),
            Container(
                padding: EdgeInsets.only(
                  left: 15,
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: <
                        Widget>[
                  Text(
                    "First Name",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(
                    width: 120,
                  ),
                  Text(
                    "Last Name",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ])),
            Padding(
                padding: EdgeInsets.only(
                  left: 15,
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 180.0,
                        child: TextField(
                          controller: fnameController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              fillColor: Color(0xfff3f3f4),
                              filled: true),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 180.0,
                        child: TextField(
                          controller: lnameController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              fillColor: Color(0xfff3f3f4),
                              filled: true),
                        ),
                      )
                    ])),
            SizedBox(
              height: 10,
            ),
            Container(
                padding: EdgeInsets.only(
                  left: 15,
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: <
                        Widget>[
                  Text(
                    "Your Email ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(
                    width: 120,
                  ),
                  Text(
                    "Your Phone",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ])),
            Padding(
                padding: EdgeInsets.only(
                  left: 15,
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 180.0,
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              fillColor: Color(0xfff3f3f4),
                              filled: true),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 180.0,
                        child: TextField(
                          controller: mobileController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              fillColor: Color(0xfff3f3f4),
                              filled: true),
                        ),
                      )
                    ])),
            SizedBox(height: 10),
            Container(
                padding: EdgeInsets.only(
                  left: 15,
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Message ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ])),
            Padding(
                padding: EdgeInsets.only(
                  left: 15,
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 360.0,
                        child: TextField(
                          maxLines: 8,
                          maxLength: 1000,
                          controller: msgController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              fillColor: Color(0xfff3f3f4),
                              filled: true),
                        ),
                      ),
                    ])),
            SizedBox(height: 10),
            Center(
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: LightColor.midnightBlue)),
                onPressed: () {
                  usermsg();
                },
                color: LightColor.midnightBlue,
                textColor: Colors.white,
                child: Text("Send Message", style: TextStyle(fontSize: 18)),
              ),
            ),
            SizedBox(height: 20),

          ],
        ),
      ),
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: LightColor.midnightBlue,
    ));
  }
}
