import 'dart:io';

import 'package:flutter_screenutil/flutter_screenutil.dart';

/**
 * 屏幕工具
 */
class ScreenAdapter {
  static init(context) {
    ScreenUtil.init(context, width: 750, height: 1334);
  }

  static height(double value) {
    return ScreenUtil().setHeight(value);
  }

  static width(double value) {
    return ScreenUtil().setWidth(value);
  }

  static size(double value) {
    if (Platform.isAndroid) {
      return value;
    }
    return ScreenUtil().setWidth(2 * value);
  }

  static getScreenHeight() {
    return ScreenUtil.screenHeightDp;
  }

  static getScreenWidth() {
    return ScreenUtil.screenWidthDp;
  }

  static fontSize(double fontSize) {
    if (Platform.isAndroid) {
      return fontSize;
    }
    return ScreenUtil().setSp(2 * fontSize);
  }
}
