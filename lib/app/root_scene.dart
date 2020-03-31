import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xigua_read/app/sq_color.dart';
import 'package:xigua_read/base/util/utils_toast.dart';
import 'package:xigua_read/bookshelf/bookshelf_scene.dart';
import 'package:xigua_read/me/me_scene.dart';
import 'package:xigua_read/home/home_page.dart';

import '../global.dart';

class RootScene extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RootSceneState();
}

class RootSceneState extends State<RootScene>
    with SingleTickerProviderStateMixin {
  int _tabIndex = 0;
  bool isFinishSetup = false;
  List<Image> _tabImages = [
    Image.asset('img/tab_bookshelf_n.png'),
    Image.asset('img/tab_bookstore_n.png'),
    Image.asset('img/tab_me_n.png'),
  ];

  List<Image> _tabSelectedImages = [
    Image.asset('img/tab_bookshelf_p.png'),
    Image.asset('img/tab_bookstore_p.png'),
    Image.asset('img/tab_me_p.png'),
  ];
  DateTime _lastClickTime;
  TabController primaryTC;

  @override
  void initState() {
    super.initState();
    primaryTC = TabController(length: 3, vsync: this);

    // 开始
    setupApp();
  }

  @override
  void dispose() {
//    eventBus.off(EventUserLogin);
  }

  setupApp() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      isFinishSetup = true;
    });
  }

  Image getTabIcon(int index) {
    if (index == _tabIndex) {
      return _tabSelectedImages[index];
    } else {
      return _tabImages[index];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        child: IndexedStack(
          children: [
            BookshelfScene(),
            TabHomePage(),
            MeScene(),
          ],
          index: _tabIndex,
        ),
        onWillPop: () async {
          if (_lastClickTime == null ||
              DateTime.now().difference(_lastClickTime) >
                  Duration(seconds: 1)) {
            // 两次点击间隔超过1秒则重新计时
            _lastClickTime = DateTime.now();
            ToastUtils.showToast("再次点击退出");
            return false;
          }
          return true;
        },
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.white,
        activeColor: SQColor.primary,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: getTabIcon(0), title: Text('书架')),
          BottomNavigationBarItem(icon: getTabIcon(1), title: Text('书城')),
          BottomNavigationBarItem(icon: getTabIcon(2), title: Text('我的')),
        ],
        currentIndex: _tabIndex,
        onTap: (index) {
          setState(() {
            _tabIndex = index;
          });
        },
      ),
    );
  }
}
