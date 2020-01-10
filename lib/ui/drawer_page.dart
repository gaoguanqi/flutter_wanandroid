import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/application.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/common/user.dart';
import 'package:flutter_wanandroid/data/api/apis_service.dart';
import 'package:flutter_wanandroid/data/model/base_model.dart';
import 'package:flutter_wanandroid/data/model/user_info_model.dart';
import 'package:flutter_wanandroid/event/login_event.dart';
import 'package:flutter_wanandroid/event/theme_change_event.dart';
import 'package:flutter_wanandroid/res/styles.dart';
import 'package:flutter_wanandroid/utils/index.dart';
import 'package:flutter_wanandroid/utils/toast_util.dart';
import 'package:flutter_wanandroid/utils/utils.dart';

/**
 * 侧滑页面
 */
class DrawerPage extends StatefulWidget {
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage>
    with AutomaticKeepAliveClientMixin {
  bool isLogin = false;
  String username = '去登录';
  String level = '--';
  String rank = '--';
  String myScore = '0'; //我的积分

  String modeText = '夜间模式';
  Icon modeIcon;


  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    this.registerLoginEvent();


    if(User.singleton.userName != null &&  User.singleton.userName.isNotEmpty){
      isLogin = true;
      username = User.singleton.userName;
      getUserInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    this.modeIcon = Icon(Icons.brightness_2,size: 22.0,color: Theme.of(context).primaryColor,);
    return WillPopScope(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(16, 40, 16, 10),
              color: Theme.of(context).primaryColor,
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      // InkWell 水波纹
                      child: Image.asset(
                        Utils.getImgPath('ic_rank'),
                        color: Colors.white,
                        width: 20.0,
                        height: 20.0,
                      ),
                      onTap: () {
                        T.show(msg: '积分');
                      },
                    ),
                  ),
                 GestureDetector(
                   child:  CircleAvatar(
                     backgroundImage:
                     AssetImage(Utils.getImgPath('ic_default_avatar')),
                     radius: 40.0,
                   ),
                   onTap: (){
                     if (!isLogin) {
                       //如果没有登录就去登录页面
                       T.show(msg: '去登录');
                     }
                   },
                 ),
                  Gaps.vGap10,
                  InkWell(
                    child: Text(
                      username,
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                    onTap: () {
                      if (!isLogin) {
                        //如果没有登录就去登录页面
                        T.show(msg: '去登录');
                      }
                    },
                  ),
                  Gaps.vGap5,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '等级:',
                        style:
                            TextStyle(fontSize: 10.0, color: Colors.grey[100]),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        level,
                        style:
                            TextStyle(fontSize: 10.0, color: Colors.grey[100]),
                        textAlign: TextAlign.center,
                      ),
                      Gaps.hGap5,
                      Text(
                        '排名:',
                        style:
                            TextStyle(fontSize: 10.0, color: Colors.grey[100]),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        rank,
                        style:
                            TextStyle(fontSize: 10.0, color: Colors.grey[100]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text(
                '我的积分',
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.left,
              ),
              leading: Image.asset(
                Utils.getImgPath('ic_score'),
                width: 22.0,
                height: 22.0,
                color: Theme.of(context).primaryColor,
              ),
              trailing: Text(myScore,style: TextStyle(color: Colors.grey[500]),),
              onTap: (){
                if(isLogin){
                  //去积分页
                }else{
                  T.show(msg: '请先登录~');
                  //去登录页
                }
              },
            ),

            ListTile(
              title: Text(
                '我的收藏',
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.left,
              ),
              leading: Icon(Icons.favorite_border,size: 22.0,color: Theme.of(context).primaryColor,),
              onTap: (){
                if(isLogin){
                  //去收藏页
                }else{
                  T.show(msg: '请先登录~');
                  //去登录页
                }
              },
            ),
            ListTile(
              title: Text(
                '我的分享',
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.left,
              ),
              leading: Image.asset(
                Utils.getImgPath('ic_share'),
                width: 22.0,
                height: 22.0,
                color: Theme.of(context).primaryColor,
              ),
              onTap: (){
                if(isLogin){
                  //去分享页
                }else{
                  T.show(msg: '请先登录~');
                  //去登录页
                }
              },
            ),
            ListTile(
              title: Text(
                'TODO',
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.left,
              ),
              leading: Image.asset(
                Utils.getImgPath('ic_todo'),
                width: 22.0,
                height: 22.0,
                color: Theme.of(context).primaryColor,
              ),
              onTap: (){
                if(isLogin){
                  //去todo页
                }else{
                  T.show(msg: '请先登录~');
                  //去登录页
                }
              },
            ),
            ListTile(
              title: Text(
                modeText,
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.left,
              ),
              leading: modeIcon,
              onTap: (){
                setState(() {
                  changeTheme();
                });
              },
            ),
            ListTile(
              title: Text(
                '系统设置',
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.left,
              ),
              leading: Icon(Icons.settings,size: 22.0,color: Theme.of(context).primaryColor,),
              onTap: (){
                T.show(msg: '设置页面~');
              },
            ),
            Offstage(
              //控制child是否显示
              //当offstage为true，控件隐藏； 当offstage为false，显示；
            //当Offstage不可见的时候，如果child有动画等，需要手动停掉，Offstage并不会停掉动画等操作。
                offstage:  !isLogin,
                child: ListTile(
                  title: Text('退出登录',style: TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.left,),
                  leading: Icon(Icons.power_settings_new,size: 22.0,color: Theme.of(context).primaryColor,),
                  onTap: (){
                    _logout(context);
                  },
                ),
            ),
          ],
        ),
      ),
      onWillPop: _onWillPop,
    );
  }

  void _logout(BuildContext context){
      showDialog(context: context,builder: (context) => AlertDialog(
        content: Text('确定退出登录吗？'),
        actions: <Widget>[
          FlatButton(
            child: Text('取消',style: TextStyle(color: Colors.cyan),),
            onPressed: (){
              Navigator.of(context).pop(false);
            },
          ),
          FlatButton(
            child: Text('确定',style: TextStyle(color: Colors.cyan),),
            onPressed: (){
              apiService.logout((BaseModel model){
                Navigator.of(context).pop(true);
                if(Utils.isResultOK(model.errorCode)){
                  User.singleton.clearUserInfo();
                  setState(() {
                    isLogin = false;
                    username = '去登录';
                    level = '--';
                    rank = '--';
                    myScore = '0';
                  });
                  T.show(msg: '已退出登录');
                }else{
                  Utils.showErrorToast(model.errorMsg);
                }
              }, (DioError error){
                Utils.showErrorToast('');
              });
            },
          ),
        ],
      ));
  }

  void changeTheme() async{
    ThemeUtil.dark = !ThemeUtil.dark;
    SPUtil.putBool(Constants.DARK_KEY, ThemeUtil.dark);
    Application.eventBus.fire(ThemeChangeEvent());
  }

  Future<bool> _onWillPop() async{
    Navigator.of(context).pop(true);
    return true;
  }

  void registerLoginEvent() {
    Application.eventBus.on<LoginEvent>().listen((event) {
      setState(() {
        isLogin = true;
        username = User.singleton.userName;
        getUserInfo();
      });
    });
  }

  Future getUserInfo() async {
    apiService.getUserInfo((UserInfoModel model) {
      if (Utils.isResultOK(model.errorCode)) {
        setState(() {
          level = (model.data.coinCount ~/ 100 + 1).toString();
          rank = model.data.rank.toString();
          myScore = model.data.coinCount.toString();
        });
      } else {
        Utils.showErrorToast('');
      }
    }, (DioError error) {
      Utils.showErrorToast(error.message);
    });
  }
}
