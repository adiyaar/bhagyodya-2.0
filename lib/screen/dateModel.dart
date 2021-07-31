class DateModel {
  
  String _date;
  String _year;
  String _month;
  String _day;
  String _eventName;
  String _k;
  String _weekDay;
  String _data;
  String _sunrise;
  String _sunset;
  String _moonrise;
  String _tithi;
  String _nakshtra;
  String _yog;
  String _karan;
  String _rashtriya;

  

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  String get year => _year;

  String get rashtriya => _rashtriya;

  set rashtriya(String value) {
    _rashtriya = value;
  }

  String get karan => _karan;

  set karan(String value) {
    _karan = value;
  }

  String get yog => _yog;

  set yog(String value) {
    _yog = value;
  }

  String get nakshtra => _nakshtra;

  set nakshtra(String value) {
    _nakshtra = value;
  }

  String get tithi => _tithi;

  set tithi(String value) {
    _tithi = value;
  }

  String get moonrise => _moonrise;

  set moonrise(String value) {
    _moonrise = value;
  }

  String get sunset => _sunset;

  set sunset(String value) {
    _sunset = value;
  }

  String get sunrise => _sunrise;

  set sunrise(String value) {
    _sunrise = value;
  }

  String get data => _data;

  set data(String value) {
    _data = value;
  }

  String get weekDay => _weekDay;

  set weekDay(String value) {
    _weekDay = value;
  }

  String get k => _k;

  set k(String value) {
    _k = value;
  }

  String get eventName => _eventName;

  set eventName(String value) {
    _eventName = value;
  }

  String get day => _day;

  set day(String value) {
    _day = value;
  }

  String get month => _month;

  set month(String value) {
    _month = value;
  }

  set year(String value) {
    _year = value;
  }

  DateModel.fromJson(Map<String, dynamic> json)
      : _date = json['datee'],
        _year = json['year'],
        _month = json['month'],
        _day = json['day'],
        _eventName = json['eventname'],
        _k = json['k'],
        _weekDay = json['weekday'],
        _data = json['data'],
        _sunrise = json['sunrise'],
        _sunset = json['sunset'],
        _moonrise = json['moonrise'],
        _tithi = json['tithi'],
        _nakshtra = json['nakshtra'],
        _yog = json['yog'],
        _karan = json['karan'],
        _rashtriya = json['rashtriya'];
}
