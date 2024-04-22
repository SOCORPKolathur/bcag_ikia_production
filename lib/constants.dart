import 'package:flutter/material.dart';

class Constants{
 // Color primaryAppColor = const Color(0xff377DFF);
  Color primaryAppColor = const Color(0xff37d1d3);

  //Color primaryAppColor = const Color(0xff573902);
  static String apiKeyForNotification = 'AAAAii4b5Ts:APA91bEvfFnHM14KwgEWmOEr3JB6BqdoTDuAnFvJLD0HccAoc6H7Ej4kL-VSTv1ce3frKTdFGl9N2tlQNMGV7LXJqNAEDMqM38TDAMfEQDFR6BTJThYUieJ8ebTW5gwuJE4HZCnHkmRe';

  double getFontSize(BuildContext context, String textType){
    double fontSize = 13.0;
    Size size = MediaQuery.of(context).size;
    switch(textType){
      case "XL":
        fontSize = size.height * 0.04;
        break;
      case "ML":
        fontSize = size.height * 0.033;
        break;
      case "L":
        fontSize = size.height * 0.03;
        break;
      case "M":
        fontSize = size.height * 0.024;
        break;
      case "SM":
        fontSize = size.height * 0.022;
        break;
      case "S":
        fontSize = size.height * 0.017;
        break;
      case "K":
        fontSize = size.height * 0.0156;
        break;
    }
    return fontSize;
  }

}