import 'package:flutter/material.dart';

class ThemeUtil{
  //默认主题色
  static const Color defalutColor = Colors.redAccent;
  //当前主题色
  static Color currentThemeColor = defalutColor;
  //是否是夜间模式
  static bool dark = false;

  //改变主题模式
  static ThemeData getThemeData(){
    if(dark){
      return ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF34564E),
        primaryColorDark: Color(0xFF212A2F),
        accentColor: Color(0xFF35464E),
        dividerColor: Color(0x1FFFFFF),
      );
    }else{
      return ThemeData(
        brightness: Brightness.light,
        primaryColor: currentThemeColor,
        primaryColorDark: currentThemeColor,
        accentColor: currentThemeColor,
        dividerColor: Color(0x1F000000),
      );
    }
  }
}