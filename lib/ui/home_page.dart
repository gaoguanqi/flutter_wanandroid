import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/app_bar.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_wanandroid/base/base_widget.dart';
import 'package:flutter_wanandroid/data/api/apis_service.dart';
import 'package:flutter_wanandroid/data/model/article_model.dart';
import 'package:flutter_wanandroid/data/model/banner_model.dart';
import 'package:flutter_wanandroid/utils/index.dart';
import 'package:flutter_wanandroid/widgets/custom_cached_image.dart';
import 'package:flutter_wanandroid/widgets/item_article_list.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends BaseWidget {
  @override
  BaseWidgetState<BaseWidget> attachState() {
    return HomePageState();
  }
}

class HomePageState extends BaseWidgetState<HomePage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  ScrollController _scrollController = ScrollController();

  //首页轮播图数据
  List<BannerBean> _bannerList = List();

  //首页文章列表数据
  List<ArticleBean> _articles = List();

  //是否显示悬浮按钮
  bool _isShowFAB = false;

  //页码，从0 开始
  int _page = 0;

  @override
  void initState() {
    super.initState();
    setAppBarVisible(false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bannerList.add(null);

    showLoading().then((value) {
      getBannerList();
      getTopArticleList();
    });

    _scrollController.addListener(() {
      //滑动到底部，加载更多
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
//        getMoreArticleList();
      }

      if (_scrollController.offset < 200 && _isShowFAB) {
        setState(() {
          _isShowFAB = false;
        });
      } else if (_scrollController.offset >= 200 && !_isShowFAB) {
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
        onRefresh: getTopArticleList,
        onLoading: getMoreArticleList,
        child: ListView.builder(
          itemBuilder: itemView,
          physics: AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          itemCount: _articles.length + 1,
        ),
      ),
      floatingActionButton: !_isShowFAB
          ? null
          : FloatingActionButton(
              heroTag: 'home',
              child: Icon(Icons.arrow_upward),
              onPressed: () {
                //回到顶部时需要执行的动画
                _scrollController.animateTo(0,
                    duration: Duration(milliseconds: 2000), curve: Curves.ease);
              },
            ),
    );
  }

  Widget itemView(BuildContext context, int index) {
    if (index == 0) {
      return Container(
        height: 200.0,
        color: Colors.transparent,
        child: _buildBannerWidget(),
      );
    }
    ArticleBean item = _articles[index - 1];
    return ItemArticleList(
      item: item,
    );
  }

  Widget _buildBannerWidget() {
    return Offstage(
      offstage: _bannerList.length == 0,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          if (index >= _bannerList.length ||
              _bannerList[index] == null ||
              _bannerList[index].imagePath == null) {
            return Container(
              height: 0,
            );
          } else {
            return InkWell(
              child: Container(
                child: CustomCachedImage(
                  imageUrl: _bannerList[index].imagePath,
                ),
              ),
              onTap: () {
                RouteUtil.toWebView(
                    context, _bannerList[index].title, _bannerList[index].url);
              },
            );
          }
        },
        itemCount: _bannerList.length,
        autoplay: true,
        pagination: SwiperPagination(),
      ),
    );
  }

  //获取轮播图数据
  Future getBannerList() async {
    apiService.getBannerList((BannerModel bannerModel) {
      if (bannerModel.data.length > 0) {
        setState(() {
          _bannerList = bannerModel.data;
        });
      }
    });
  }

  // 获取置顶文章数据
  Future getTopArticleList() async {
    apiService.getTopArticleList((TopArticleModel topArticleModel) {
      if (Utils.isResultOK(topArticleModel.errorCode)) {
        topArticleModel.data.forEach((v) {
          v.top = 1;
        });
        _articles.clear();
        _articles.addAll(topArticleModel.data);
      }
      getArticleList();
    }, (DioError error) {
      showError();
    });
  }

  //获取文章列表数据
  Future getArticleList() async {
    _page = 0;
    apiService.getArticleList((ArticleModel model) {
      if (Utils.isResultOK(model.errorCode)) {
        if (model.data.datas.length > 0) {
          showContent().then((value) {
            _refreshController.refreshCompleted(resetFooterState: true);
            setState(() {
              _articles.addAll(model.data.datas);
            });
          });
        } else {
          showEmpty();
          Utils.showErrorToast('');
        }
      }
    }, (DioError error) {
      showError();
      Utils.showErrorToast(error.message);
    }, _page);
  }

  // 获取更多文章列表数据
  Future getMoreArticleList() async {
    _page++;
    apiService.getArticleList((ArticleModel model) {
      if (Utils.isResultOK(model.errorCode)) {
        if (model.data.datas.length > 0) {
          _refreshController.loadComplete();
          setState(() {
            _articles.addAll(model.data.datas);
          });
        } else {
          _refreshController.loadNoData();
        }
      } else {
        _refreshController.loadFailed();
        T.show(msg: model.errorMsg);
      }
    }, (DioError error) {
      _refreshController.loadFailed();
    }, _page);
  }

  @override
  void onClickErrorWidget() {
    showLoading().then((value) {
      getBannerList();
      getTopArticleList();
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
