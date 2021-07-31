import 'package:bhagyoday/screen/calendar_screen.dart';
import 'package:bhagyoday/screen/dateModel.dart';
import 'package:bhagyoday/screen/home_slider.dart';
import 'package:bhagyoday/widgets/custom_divider_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class FullScreenDialog extends StatefulWidget {
  DateModel dateModel;
  String day, month, year;
  List events;
  FullScreenDialog(dateModel, day, month, year, List events) {
    this.dateModel = dateModel;
    this.day = day;
    this.month = month;
    this.year = year;
    events != null ? this.events = events : this.events = [];
  }

  @override
  FullScreenDialogState createState() => new FullScreenDialogState();
}

class FullScreenDialogState extends State<FullScreenDialog> {
  String sunset = "-";
  String sunrise = "-";
  String moonrise = "-";
  String tithi = "-";
  String nakshatra = "-";
  String yog = "-";
  String karan = "-";
  String rashtriya = "-";
  String weekDay = "-";
  @override
  void initState() {
    if (this.widget.dateModel != null) {
      setState(() {
        sunset = this.widget.dateModel.sunset;
        sunrise = this.widget.dateModel.sunrise;
        moonrise = this.widget.dateModel.moonrise;
        tithi = this.widget.dateModel.tithi;
        nakshatra = this.widget.dateModel.nakshtra;
        yog = this.widget.dateModel.yog;
        karan = this.widget.dateModel.karan;
        rashtriya = this.widget.dateModel.rashtriya;
        weekDay = this.widget.dateModel.weekDay;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: showDialog,
        backgroundColor: Colors.black,
      ),
      appBar: new AppBar(
        title: const Text('Date'),
        // actions: [
        //   new FlatButton(
        //       onPressed: () {
        //         //TODO: Handle save
        //       },
        //       child: new Text('SAVE',
        //           style: Theme
        //               .of(context)
        //               .textTheme
        //               .subhead
        //               .copyWith(color: Colors.white))),
        // ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:

                  Container(
                    width: MediaQuery.of(context).size.width * 1.0,

                    decoration: BoxDecoration(
                      color: Colors.red,
                      border: Border.all(width: 1, color: Colors.grey),
                      //borderRadius: const BorderRadius.all(const Radius.circular(8)),
                    ),

                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Center(
                          child: Text(
                            "Today's Panchang",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),


              ),
              Container(
                  child: Center(
                      child: Text(
                this.widget.day +
                    '-' +
                    this.widget.month +
                    '-' +
                    this.widget.year,
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ))),
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: Container(
                  width: 205.0,
                  height: 50.0,
                  //color: HexColor("#FFC7FF"),
                  child: Center(
                    child: Text(
                      weekDay,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Image.asset(
                      "assets/sun.png",
                      scale: 10.0,
                    ),
                  ),
                  Container(
                    child: Image.asset(
                      "assets/sunset.png",
                      scale: 5.0,
                    ),
                  ),
                  Container(
                    child: Image.asset(
                      "assets/moon.png",
                      scale: 6.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              CustomDividerView(),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    sunrise,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    sunset,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    moonrise,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                ],
              ),
              SizedBox(height: 50.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.40,
                    height: 150.0,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      //borderRadius: const BorderRadius.all(const Radius.circular(8)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          SizedBox(height: 20.0),
                          Text(
                            "Tithi",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20.0),
                          Text(
                            tithi,
                            style: TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.40,
                    height: 150.0,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      //borderRadius: const BorderRadius.all(const Radius.circular(8)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          SizedBox(height: 20.0),
                          Text(
                            "Yog",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20.0),
                          Text(
                            yog,
                            style: TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25.0),
              Row(

                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.40,
                    height: 170.0,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      //borderRadius: const BorderRadius.all(const Radius.circular(8)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          SizedBox(height: 20.0),
                          Text(
                            "Nakshatra",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 15.0),
                          Text(

                            nakshatra,
                            style: TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.40,
                    height: 170.0,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      //borderRadius: const BorderRadius.all(const Radius.circular(8)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(height: 20.0),
                          Text(
                            "Karan",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20.0),
                          Text(
                            karan,
                            style: TextStyle(fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              CustomDividerView(),
              /*Container(
                  margin: EdgeInsets.only(top: 20, bottom: 10),
                  child: Text(
                    "Events",
                    style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
                  )),
              ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                      margin: EdgeInsets.all(5),
                      child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 1.0,

                            decoration: BoxDecoration(
                              color: Colors.red,
                              border: Border.all(width: 1, color: Colors.grey),
                              //borderRadius: const BorderRadius.all(const Radius.circular(8)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                        this.widget.events[index],
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),
                      ),
                            ),
                          )));
                },
                itemCount: this.widget.events.length,
              ),*/
              //footer(),

            ],
          ),
        ),
      ),
    );
  }

  void showDialog() {
    homePageKey.currentState.showAddDialog();
  }
}
