import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/data/model/wx_article_model.dart';
class WXArticlePage extends StatefulWidget {
  @override
  _WXArticlePageState createState() => _WXArticlePageState();
}

class _WXArticlePageState extends State<WXArticlePage> with AutomaticKeepAliveClientMixin{

  List<WXArticleBean> _wxArticleList = List();
  //listView 控制器
  ScrollController _scrollController = ScrollController();
  //是否显示悬浮按钮
  bool _isShowFAB = false;
  int _page = 1;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Container();
  }

}
