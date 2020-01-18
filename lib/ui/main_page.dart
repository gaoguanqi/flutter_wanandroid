import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/ui/drawer_page.dart';
import 'package:flutter_wanandroid/ui/home_page.dart';
import 'package:flutter_wanandroid/utils/utils.dart';

import 'square_page.dart';

/**
 * 首页
 */
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with AutomaticKeepAliveClientMixin {
  PageController _pageController = PageController();

  //当前选中的索引
  int _selsetedIndex = 0;

  //tabs的名字
  final bottomBarTitles = [
    '首页',
    '广场',
    '公众号',
    '体系',
    '项目',
  ];

  // tabs view
  var pages = <Widget>[
    HomePage(),
    SquarePage(),
    HomePage(),
    HomePage(),
    HomePage(),
  ];

  //flutter tab切换页面防止重置
  //不会被销毁,占内存中@overridebool get wantKeepAlive =>true;
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: _onWillPop, //onWillPop表示当前页面即将退出，
      child: Scaffold(
        drawer: DrawerPage(),
        appBar: AppBar(
          elevation: 0.0,
          title: Text(bottomBarTitles[_selsetedIndex]),
//          bottom: null,
          actions: <Widget>[
            IconButton(
              icon: _selsetedIndex == 1 ? Icon(Icons.add) : Icon(Icons.search),
              onPressed: () {
                if (_selsetedIndex == 1) {
                  //跳分享
//                  RouteUtil.push(context, page)
                } else {
                  //跳搜索

                }
              },
            ),
          ],
        ),
        body: PageView.builder(
          itemBuilder: (context, index) => pages[_selsetedIndex],
          itemCount: pages.length,
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              _selsetedIndex = index;
            });
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            //首页
            BottomNavigationBarItem(
              icon: _buildImage(0, 'ic_home'),
              title: Text(bottomBarTitles[0]),
            ),
            //广场
            BottomNavigationBarItem(
              icon: _buildImage(1, 'ic_square_line'),
              title: Text(bottomBarTitles[1]),
            ),
            //公众号
            BottomNavigationBarItem(
              icon: _buildImage(2, 'ic_wechat'),
              title: Text(bottomBarTitles[2]),
            ),
            //体系
            BottomNavigationBarItem(
              icon: _buildImage(3, 'ic_system'),
              title: Text(bottomBarTitles[3]),
            ),
            //项目
            BottomNavigationBarItem(
              icon: _buildImage(4, 'ic_project'),
              title: Text(bottomBarTitles[4]),
            ),
          ],
          type: BottomNavigationBarType.fixed, //设置显示模式
          currentIndex: _selsetedIndex, //当前选中的索引
          onTap: _onItemTapped, //tab item点击事件
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);
  }

  Widget _buildImage(index, iconPath) {
    return Image.asset(
      Utils.getImgPath(iconPath),
      width: 22.0,
      height: 22.0,
      color: _selsetedIndex == index
          ? Theme.of(context).primaryColor
          : Colors.grey[600],
    );
  }

  Future<bool> _onWillPop() {
    return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('提示'),
                  content: Text('确定退出应用吗？'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(
                        '再看一会',
                        style: TextStyle(color: Colors.cyan),
                      ),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                    FlatButton(
                      child: Text(
                        '退出',
                        style: TextStyle(color: Colors.cyan),
                      ),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ],
                )) ??
        false;
  }
}
