import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/user.dart';
import 'package:flutter_wanandroid/data/api/apis_service.dart';
import 'package:flutter_wanandroid/data/model/article_model.dart';
import 'package:flutter_wanandroid/data/model/base_model.dart';
import 'package:flutter_wanandroid/utils/index.dart';
import 'package:flutter_wanandroid/widgets/custom_cached_image.dart';
import 'package:flutter_wanandroid/widgets/like_button_widget.dart';

class ItemArticleList extends StatefulWidget {
  ArticleBean item;

  ItemArticleList({this.item});

  @override
  _ItemArticleListState createState() => _ItemArticleListState();
}

class _ItemArticleListState extends State<ItemArticleList> {
  @override
  Widget build(BuildContext context) {
    var item = widget.item;
    return InkWell(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Row(
              children: <Widget>[
                Offstage(
                  offstage: item.top == 0,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFF44336), width: 0.5),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.elliptical(2.0, 2.0),
                        bottom: Radius.elliptical(2.0, 2.0),
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                    margin: EdgeInsets.fromLTRB(0, 0, 4, 0),
                    child: Text(
                      '置顶',
                      style: TextStyle(
                        fontSize: 10.0,
                        color: const Color(0xFFF44336),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Offstage(
                  offstage: !item.fresh,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFF44336), width: 0.5),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.elliptical(2, 2),
                        bottom: Radius.elliptical(2, 2),
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                    margin: EdgeInsets.fromLTRB(0, 0, 4, 0),
                    child: Text(
                      '新',
                      style: TextStyle(
                        fontSize: 10.0,
                        color: const Color(0xFFF44336),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Offstage(
                  offstage: item.tags.length == 0,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.cyan, width: 0.5),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.elliptical(2, 2),
                        bottom: Radius.elliptical(2, 2),
                      ),
                    ),
                    padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                    margin: EdgeInsets.fromLTRB(0, 0, 4, 0),
                    child: Text(
                      item.tags.length > 0 ? item.tags[0].name : '',
                      style: TextStyle(
                        fontSize: 10.0,
                        color: Colors.cyan,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Text(
                  item.author.isNotEmpty ? item.author : item.shareUser,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.left,
                ),
                Expanded(
                  child: Text(
                    item.niceDate,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
                Offstage(
                  offstage: item.envelopePic == '',
                  child: Container(
                    width: 100.0,
                    height: 80.0,
                    padding: EdgeInsets.fromLTRB(16, 8, 0, 8),
                    child: CustomCachedImage(
                      imageUrl: item.envelopePic,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        child: Text(
                          item.title,
                          maxLines: 2,
                          style: TextStyle(fontSize: 16.0),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                '${item.superChapterName}/${item.chapterName}',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            LikeButtonWidget(
                              isLike: item.collect,
                              onClick: () {
                                addOrCancelCollect(item);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1.0,
          ),
        ],
      ),
      onTap: () {
        RouteUtil.toWebView(context, item.title, item.link);
      },
    );
  }

  //添加收藏或取消收藏
  void addOrCancelCollect(ArticleBean item) {
    List<String> cookies = User.singleton.cookie;
    if (cookies == null || cookies.length == 0) {
      T.show(msg: '请先登录~');
    } else {
      if (item.collect) {
        apiService.cancleCollection((BaseModel model) {
          if (Utils.isResultOK(model.errorCode)) {
            T.show(msg: '已取消收藏~');
            setState(() {
              item.collect = false;
            });
          } else {
            Utils.showErrorToast('');
          }
        }, (DioError error) {
          Utils.showErrorToast(error.message);
        }, item.id);
      } else {
        apiService.addCollcetion((BaseModel mode) {
          if (Utils.isResultOK(mode.errorCode)) {
            T.show(msg: '收藏成功~');
            setState(() {
              item.collect = true;
            });
          } else {
            Utils.showErrorToast('收藏失败~');
          }
        }, (DioError error) {
          Utils.showErrorToast(error.message);
        }, item.id);
      }
    }
  }
}
