import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:url_launcher/url_launcher.dart';

import 'toast_util.dart';

class Utils {
  static String getImgPath(String name, {String format: 'png'}) {
    return 'assets/images/$name.$format';
  }

  static void launchTelURL(String phone) async {
    String url = 'tel:' + phone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(msg: '拨号失败');
    }
  }

  static KeyboardActionsConfig getKeyboardActionsConfig(List<FocusNode> list) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: List.generate(
          list.length,
          (i) => KeyboardAction(
                focusNode: list[i],
                closeWidget: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text('关闭'),
                ),
              )),
    );
  }

  static bool isResultOK(int code) => code == Constants.STATUS_SUCCESS;

  static void showErrorToast(String msg){
    T.show(msg: (msg.isEmpty || msg == null)? '网络异常':msg);
  }
}