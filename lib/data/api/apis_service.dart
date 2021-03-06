import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_wanandroid/common/user.dart';
import 'package:flutter_wanandroid/data/model/article_model.dart';
import 'package:flutter_wanandroid/data/model/banner_model.dart';
import 'package:flutter_wanandroid/data/model/base_model.dart';
import 'package:flutter_wanandroid/data/model/user_info_model.dart';
import 'package:flutter_wanandroid/net/index.dart';

import 'apis.dart';

ApiService _apiService = ApiService();

ApiService get apiService => _apiService;

class ApiService {
  Options _getOptions() {
    Map<String, String> map = Map();
    map['Cookie'] = User().cookie.toString();
    return Options(headers: map);
  }

  ///获取用户信息
  void getUserInfo(Function callback,Function errorCallback) async{
    dio.get(Apis.USER_INFO).then((response){
      callback(UserInfoModel.fromJson(response.data));
    }).catchError((e){
      errorCallback(e);
    });
  }

  ///获取首页轮播图数据
  void getBannerList(Function callback) async{
    dio.get(Apis.HOME_BANNER).then((response){
      callback(BannerModel.fromJson(response.data));
    });
  }

  ///获取首页置顶文章数据
  void getTopArticleList(Function callback,Function errorCallback) async{
    dio.get(Apis.HOME_TOP_ARTICLE_LIST).then((response){
      callback(TopArticleModel.fromJson(response.data));
    }).catchError((e){
      errorCallback(e);
    });
  }

  //获取首页文章数据
  void getArticleList(Function callback,Function errorCallback,int _page) async{
    dio.get(Apis.HOME_ARTICLE_LIST + '/$_page/json').then((response){
      callback(ArticleModel.fromJson(response.data));
    }).catchError((e){
      errorCallback(e);
    });
  }

  //取消收藏
  void cancleCollection(Function callback,Function errorCallback,int _id) async{
      dio.post(Apis.CANCEL_COLLECTION + '/$_id/json').then((response){
        callback(BaseModel.fromJson(response.data));
      }).catchError((e){
        errorCallback(e);
      });
  }

  //新增收藏（收藏站内文章）
  void addCollcetion(Function callback,Function errorCallback,int _id) async{
    dio.post(Apis.ADD_COLLECTION + '/$_id/json').then((response){
      callback(BaseModel.fromJson(response.data));
    }).catchError((e){
      errorCallback(e);
    });
  }

  //获取广场列表数据
  void getSquareList(Function callback,Function errorCallback,int _page) async{
    dio.get(Apis.SQUARE_LIST + '/$_page/json').then((response){
      callback(ArticleModel.fromJson(response.data));
    }).catchError((e){
      errorCallback(e);
    });
  }
  /// 退出登录
  void logout(Function callback,Function errorCallback)async{
    dio.get(Apis.USER_LOGOUT).then((response){
      callback(BaseModel.fromJson(response.data));
    }).catchError((e){
      errorCallback(e);
    });
  }
}
