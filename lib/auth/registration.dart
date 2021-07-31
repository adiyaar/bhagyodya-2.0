import 'package:bhagyoday/auth/login.dart';
import 'package:bhagyoday/themes/light_color.dart';
import 'package:bhagyoday/widgets/bezierContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:toast/toast.dart';

class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<RegistrationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  // Boolean variable for CircularProgressIndicator.
  bool visible = false;
  static const Color midnightBlue = const Color.fromRGBO(1, 4, 99, 1);
  // Getting value from TextField widget.
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final buildingController = TextEditingController();
  final zoneController = TextEditingController();
  final streetController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flutterLocalNotificationsPlugin =FlutterLocalNotificationsPlugin();
    var android= AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios= IOSInitializationSettings();
    var initialise= InitializationSettings(android:android, iOS:ios );
    flutterLocalNotificationsPlugin.initialize(initialise,onSelectNotification: onSelectionNotification);
    //checkLogin();
  }
  Future onSelectionNotification(String payload) async{
    if(payload != null){
      debugPrint("Notification :" +payload);
    }
  }

  Future showNotification() async{
    var android = AndroidNotificationDetails('channelId', 'Online Family Pharmacy','channelDescription');
    var ios= IOSNotificationDetails();
    var platform= NotificationDetails(android: android, iOS: ios);
    flutterLocalNotificationsPlugin.show(0, 'Thank you for your Registration', 'Shop online on Qatars Most trusted pharmacy with a wide collection of items ranging from personal care, Baby care, Home care products, Medical equipment & supplements we are the healthcare with best priced deals we offer Home delivery across Qatar.',platform,payload:'some details');
  }


  Future userRegistration() async {
    // Showing CircularProgressIndicator.
    setState(() {
      visible = true;
    });

    // Getting value from Controller
    String firstname = fnameController.text;
    String lastname = lnameController.text;
    String mobileno = mobileController.text;
    String email = emailController.text;
    String buildingno = buildingController.text;
    String zone = zoneController.text;
    String street = streetController.text;
    String password = passwordController.text;
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (mobileno.length != 8) {
      showInSnackBar("Invalid Mobile No");
      //showToast('Invalid Mobile No', gravity: Toast.BOTTOM, duration: 3);
    } else if (firstname.length == 0 ||
        lastname.length == 0 ||
        buildingno.length == 0 ||
        zone.length == 0 ||
        street.length == 0 ||
        password.length == 0) {
      showInSnackBar("Field Should not be empty");

    } else if (!regex.hasMatch(email)) {
      showInSnackBar("Enter Valid Email");

    } else {
      // SERVER API URL
      var url = 'https://bhagyodaycalendar.com/admin/api/register.php';

      // Store all data with Param Name.
      var data = {
        'firstname': firstname,
        'lastname': lastname,
        'mobileno': mobileno,
        'email': email,
        'buildingno': buildingno,
        'zone': zone,
        'street': street,
        'password': password
      };

      // Starting Web API Call.
      var response = await http.post(Uri.parse(url), body: json.encode(data));

      // Getting Server response into variable.
      var message = jsonDecode(response.body);

      // If Web call Success than Hide the CircularProgressIndicator.
      if (response.statusCode == 200) {
        setState(() {
          visible = false;
        });
      }
      showNotification();
     fnameController.clear();
       lnameController.clear();
     mobileController.clear();
       emailController.clear();
      buildingController.clear();
       zoneController.clear();
      streetController.clear();
       passwordController.clear();
      showInSnackBar(message);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
      // Showing Alert Dialog with Response JSON Message.
      /* showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(message),
            actions: <Widget>[
              FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );*/
    }
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
              style: TextStyle(
                  color: LightColor.red,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return Center(
      child: Column(
        children: <Widget>[
          Image.asset('assets/Login/bhagyodaylogo.png',height: 100,
            width: 250,),
        ],
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
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
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
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
        ]),
        SizedBox(
          height: 10,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Text(
            "Mobile No",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Container(
            width: 80.0,
            child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: '+974',
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            width: 280.0,
            child: TextField(
              controller: mobileController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true),
            ),
          )
        ]),
        SizedBox(
          height: 10,
        ),
        Text(
          "Email Id",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        TextField(
          controller: emailController,
          decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true),
        ),
        SizedBox(
          height: 10,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
          /*SizedBox(
            width: 10,
          ),*/
          Text(
            "Building No",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            // width: 44,
          ),
          Text(
            "Zone/Area",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            //  width: 60,
          ),
          Text(
            "Street",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ]),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 100.0,
                child: TextField(
                  controller: buildingController,
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
                width: 100.0,
                child: TextField(
                  controller: zoneController,
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
                  width: 100.0,
                  child: TextField(
                    controller: streetController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Color(0xfff3f3f4),
                        filled: true),
                  ))
            ]),
        SizedBox(
          height: 10,
        ),
        Text(
          "Password",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        TextField(
            obscureText: true,
            controller: passwordController,
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    _title(),
                    SizedBox(
                      height: 50,
                    ),
                    _emailPasswordWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Button(
                        onClick: userRegistration,
                        btnText: "Registration",
                      ),
                    ),
                    // SizedBox(height: height * .14),
                    _loginAccountLabel(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(value),backgroundColor:LightColor.midnightBlue ,));
  }
  showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
}

class Button extends StatelessWidget {
  var btnText = "";
  var onClick;

  Button({this.btnText, this.onClick});
  Color yellowColors = Colors.yellow[700];
  static const Color midnightBlue = const Color.fromRGBO(1, 4, 99, 1);
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onClick,
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(50),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: Offset(2, 4),
                    blurRadius: 5,
                    spreadRadius: 2)
              ],
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.red[700],Color(0xffF72804)])),
          child: InkWell(
            child: Text(
              'Register Now',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }
}
