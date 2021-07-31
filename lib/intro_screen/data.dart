import 'package:flutter/material.dart';


class SliderModel{

  String imageAssetPath;
  String title;
  String desc;

  SliderModel({this.imageAssetPath,this.title,this.desc});

  void setImageAssetPath(String getImageAssetPath){
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle){
    title = getTitle;
  }

  void setDesc(String getDesc){
    desc = getDesc;
  }

  String getImageAssetPath(){
    return imageAssetPath;
  }

  String getTitle(){
    return title;
  }

  String getDesc(){
    return desc;
  }

}


List<SliderModel> getSlides(){

  List<SliderModel> slides = new List<SliderModel>();
  SliderModel sliderModel = new SliderModel();

  //1
  sliderModel.setDesc("Welcome To Bhagyoday Calendars");
  sliderModel.setTitle("Welcome To Bhagyoday Calendars");
  sliderModel.setImageAssetPath("assets/intro/onboard1.jpg");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //2
  sliderModel.setDesc("Bhagyoday Calendars is ought to provide best service to help you pick right day and right time.");
  sliderModel.setTitle("Bhagyoday Calendars");
  sliderModel.setImageAssetPath("assets/intro/onboard2.jpg");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //3
  sliderModel.setDesc("We will get you Reminders");
  sliderModel.setTitle("To do list");
  sliderModel.setImageAssetPath("assets/intro/onboard3.jpg");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  return slides;
}