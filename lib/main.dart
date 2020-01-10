import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/application.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/net/dio_manager.dart';
import 'package:flutter_wanandroid/res/colors.dart';
import 'package:flutter_wanandroid/utils/index.dart';

import 'common/router_config.dart';
import 'common/user.dart';
import 'event/theme_change_event.dart';
import 'ui/splash_page.dart';


/// 在拿不到context的地方通过navigatorKey进行路由跳转：
/// https://stackoverflow.com/questions/52962112/how-to-navigate-without-context-in-flutter-app
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await SPUtil.getInstance();
  await getTheme();
  runApp(MyApp());
}

//获取主题
Future<Null> getTheme() async{
  //是否是夜间模式
  bool dark = SPUtil.getBool(Constants.DARK_KEY,defValue: false);
  ThemeUtil.dark = dark;
  //如果不是夜间模式，设置的其他主题颜色才起作用
  if(!dark){
    String themeColorKey = SPUtil.getString(Constants.THEME_COLOR_KEY,defValue: 'redAccent');
    if(themeColorMap.containsKey(themeColorKey)){
        ThemeUtil.currentThemeColor = themeColorMap[themeColorKey];
    }
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  ThemeData themeData;

  @override
  void initState() {
    super.initState();
    _initAsync();
    Application.eventBus = EventBus();
    themeData = ThemeUtil.getThemeData();
    this.registerThemeEvent();
  }

  void _initAsync() async{
    await User().getUserInfo();
    await DioManager.init();
  }

  //注册主题改变事件
  void registerThemeEvent(){
    Application.eventBus
        .on<ThemeChangeEvent>()
        .listen((ThemeChangeEvent onData) =>this.changeTheme(onData));
  }

  void changeTheme(ThemeChangeEvent onData)async{
      setState(() {
        themeData = ThemeUtil.getThemeData();
      });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: themeData,
      routes: Router.generateRoute(),//存放路由的配置
      navigatorKey: navigatorKey,
      home: SplashPage(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    Application.eventBus.destroy();
  }
}


