import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/ui/main_page.dart';
import 'package:flutter_wanandroid/utils/screen_adapter.dart';
import 'package:flutter_wanandroid/utils/utils.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2), () {
      /**
       * pushAndRemoveUntil 返回到跟路由
       * builder(WidgetBuilder) 是一个WidgetBuilder 类型的回调函数，它的作用是构建页面的具体内容，返回值是一个widget ，我们通常需要实现回调，范湖新路由的实例。
       * settings(RouteSettings)包含路由的配置信息，如路由的名称，是否吃刷路由（首页）
       * maintainStae 默认情况下 当入栈一个新路由时原来的路由仍然会被保存在内存中 如果想在路由没用的时候释放其所占用的所有资源，可以设置maintainState 为 false
       * fullscreenDialog 表示新的路由页面是否是一个全屏的模态对话框，在IOS中，如果fullscreenDialog为true，新页面将会从屏幕底部划入（而不是水平方向）
       */
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MainPage()),
          (route) => route == null);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdapter.init(context);
    return Stack(
      children: <Widget>[
        Container(
          //欢迎页面
          color: Theme.of(context).primaryColor,
          // ThemeUtils.dark ? Color(0xFF212A2F) : Colors.grey[200],
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Card(
                elevation: 0.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(48.0)),
                ),
                child: Card(
                  elevation: 0.0,
                  color: Theme.of(context).primaryColor,
                  margin: EdgeInsets.all(2.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(46.0)),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage:
                        AssetImage(Utils.getImgPath('ic_launcher_news')),
                    radius: 46.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
