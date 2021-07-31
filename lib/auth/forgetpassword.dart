import 'dart:convert';
import 'package:bhagyoday/themes/light_color.dart';
import 'package:bhagyoday/widgets/bezierContainer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


class forgetpwd extends StatefulWidget{
  @override
  _forgetpwdState createState() => _forgetpwdState();
}

class _forgetpwdState extends State<forgetpwd> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String verifyLink;
  bool verifybutton =false;
  TextEditingController user= TextEditingController();

  Future checkemail() async{
    String email = user.text;
    var data = { 'email': email};
    var url = 'https://bhagyodaycalendar.com/admin/api/forgotpassword.php';
    var response= await http.post(Uri.parse(url), body: json.encode(data));
    var msg= json.decode(response.body);
    if (email.length == 0 ){
      showInSnackBar("Field Should not be empty");

    }
    // showToast(msg,gravity: Toast.BOTTOM,duration: 3);
    if(msg=="Invalid Email Id"){
      showInSnackBar("Invalid Email Id");

    }
    else{
      setState(() {
        verifyLink=msg;
        //verifybutton=true;
      });
      showInSnackBar("Check Your Email");

    }
    print(msg);
  }

  Widget _emailPasswordWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[


        SizedBox(
          height: 10,
        ),
        Text(
          "Email Id",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        TextField(
          controller: user,
          decoration: InputDecoration(

              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true
          ),),

      ],
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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Forget Password"),
      ),
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
                        onClick: checkemail,

                        btnText: "Verify",
                      ),

                    ),
                    // SizedBox(height: height * .14),
                    //_loginAccountLabel(),
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


}


class Button extends StatelessWidget {
  var btnText ="";
  var onClick;


  Button({this.btnText, this.onClick});
  Color yellowColors = Colors.red[700];
  static const Color midnightBlue = const Color.fromRGBO(1, 4, 99,1);
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onClick,

        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,

          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50),),
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
                  colors: [LightColor.red,Color(0xffF72804)])),
          child: InkWell(
            child: Text(
              'Verify',
              style: TextStyle(fontSize: 20, color:Colors.white,fontWeight: FontWeight.bold),
            ),


          ),
        )
    );
  }
}
