import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/app_bar.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_wanandroid/base/base_widget.dart';

class WeChatPage extends BaseWidget{
  @override
  BaseWidgetState<BaseWidget> attachState() {
    return WeChatPageState();
  }
}

class WeChatPageState extends BaseWidgetState<WeChatPage> with TickerProviderStateMixin{

  TabController _tabController;
  @override
  void initState() {
    super.initState();
    setAppBarVisible(false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    showLoading().then((value){
      getWXChaptersList();
    });
  }
  @override
  AppBar attachAppBar() {
    return AppBar(title: Text(''),);
  }

  @override
  Widget attachContentWidget(BuildContext context) {
    return null;
  }

  @override
  void onClickErrorWidget() {
  }

  Future getWXChaptersList()async {

  }

}


