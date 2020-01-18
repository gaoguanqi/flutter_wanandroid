import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/base/base_widget.dart';
import 'package:flutter_wanandroid/common/application.dart';
import 'package:flutter_wanandroid/data/api/apis_service.dart';
import 'package:flutter_wanandroid/data/model/article_model.dart';
import 'package:flutter_wanandroid/event/refresh_share_event.dart';
import 'package:flutter_wanandroid/utils/index.dart';
import 'package:flutter_wanandroid/widgets/item_article_list.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SquarePage extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> attachState() {
    return SquarePageState();
  }
}

class SquarePageState extends BaseWidgetState<SquarePage> {
  //首页文章列表数据
  List<ArticleBean> _articles = List();
  //是否显示悬浮按钮
  bool _isShowFAB = false;
  //listView 控制器
  ScrollController _scrollController = ScrollController();
  //页码 从0 开始
  int _page = 0;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    setAppBarVisible(false);
    this.registerRefreshEvent();
  }

  //注册刷新列表事件
  void registerRefreshEvent() {
    Application.eventBus.on<RefreshShareEvent>().listen((context) {
      showLoading().then((value) {
        getSquareList();
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    showLoading().then((value){
      getSquareList();
    });

    _scrollController.addListener((){
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
//        getMoreSquareList();
      }

      if(_scrollController.offset < 200 && _isShowFAB){
        setState(() {
          _isShowFAB = false;
        });
      }else if(_scrollController.offset >= 200 && !_isShowFAB){
        setState(() {
          _isShowFAB = true;
        });
      }
    });
  }

  @override
  AppBar attachAppBar() {
    return AppBar(
      title: Text(''),
    );
  }

  @override
  Widget attachContentWidget(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: MaterialClassicHeader(),
        footer: ClassicFooter(),
        controller: _refreshController,
        onRefresh:  getSquareList,
        onLoading: getMoreSquareList,
        child: ListView.builder(itemBuilder: itenView,
        physics: AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          itemCount: _articles.length,
        ),
      ),
      floatingActionButton:  !_isShowFAB?null:FloatingActionButton(
        heroTag: 'square',
        child: Icon(Icons.arrow_upward),
        onPressed: (){
          //回到顶部时要执行的动画
          _scrollController.animateTo(0, duration: Duration(milliseconds: 2000), curve: Curves.ease);
        },
      ),
    );
  }

  @override
  void onClickErrorWidget() {
    showLoading().then((value){
      getSquareList();
    });
  }
//获取文章列表数据
  Future getSquareList() async {
    _page = 0;
    apiService.getSquareList((ArticleModel model){
      if(Utils.isResultOK(model.errorCode)){
        if(model.data.datas.length > 0){
          showContent().then((value){
            _refreshController.refreshCompleted(resetFooterState: true);
            setState(() {
              _articles.addAll(model.data.datas);
            });
          });
        }else{
          showEmpty();
        }
      }else{
        showError();
        Utils.showErrorToast(model.errorMsg);
      }
    }, (DioError error){
      showError();
    }, _page);
  }

  //获取更多文章列表数据
  Future getMoreSquareList() async{
    _page ++;
    apiService.getSquareList((ArticleModel model){
      if(Utils.isResultOK(model.errorCode)){
          if(model.data.datas.length > 0){
            setState(() {
              _articles.addAll(model.data.datas);
            });
          }else{
            _refreshController.loadNoData();
          }
      }else{
        _refreshController.loadNoData();
        Utils.showErrorToast(model.errorMsg);
      }
    }, (DioError error){
      _refreshController.loadFailed();
    }, _page);
  }

  Widget itenView(BuildContext context, int index) {
    if(index > _articles.length) return null;
    ArticleBean item = _articles[index];
    return ItemArticleList(item:item);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
