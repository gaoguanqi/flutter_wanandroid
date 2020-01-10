import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/res/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

/**
 * Toast 工具
 */
class T{
  static show({@required String msg,
  Toast toastLength = Toast.LENGTH_SHORT,
    int timeInSecForlos = 1,
    double fontSize = 16.0,
    ToastGravity gravity,
    Color backgroundColor = Colours.transparent_ba,
    Color textColor = Colours.text_white,
  }){
    Fluttertoast.showToast(
      msg: msg,
      toastLength: toastLength,
      gravity: ToastGravity.CENTER,
      timeInSecForIos: timeInSecForlos,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
  }
}