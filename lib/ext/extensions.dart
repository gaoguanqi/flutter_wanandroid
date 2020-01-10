import 'package:flutter_wanandroid/common/common.dart';

extension IntResultOK on int {
  bool get isResultOK {
    return this == Constants.STATUS_SUCCESS;
  }
}
