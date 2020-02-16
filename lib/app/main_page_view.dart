import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:xigua_read/base/structure/base_view.dart';
import 'package:xigua_read/base/structure/base_view_model.dart';
import 'package:xigua_read/bookshelf/bookshelf_scene.dart';
import 'package:xigua_read/bookshelf/novel_book_shelf.dart';
import 'package:xigua_read/home/home_scene.dart';
import 'package:xigua_read/me/me_scene.dart';
import 'package:xigua_read/router/manager_router.dart';
import 'package:xigua_read/ui/home/home_page.dart';

class MainPageView extends BaseStatefulView {
  @override
  BaseStatefulViewState<BaseStatefulView<BaseViewModel>, BaseViewModel>
      buildState() {
    return MainPageViewState();
  }
}

class MainPageViewState
    extends BaseStatefulViewState<MainPageView, BaseViewModel>
    with SingleTickerProviderStateMixin {
  DateTime _lastClickTime;

  TabController primaryTC;

  @override
  void initData() {
    primaryTC = TabController(length: 3, vsync: this);

  }

  @override
  Widget buildView(BuildContext context, BaseViewModel viewModel) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Novel"),
        bottom: TabBar(
          tabs: <Widget>[
            Tab(
              text: "书库",
            ),
            Tab(
              text: "发现",
            ),
            Tab(
              text: "关于",
            )
          ],
          controller: primaryTC,
        ),
        actions: <Widget>[
          Padding(
            child: IconButton(icon:Icon(Icons.search),onPressed: (){
              APPRouter.instance.route(APPRouterRequestOption(
                  APPRouter.ROUTER_NAME_NOVEL_SEARCH, context));
            },),
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          ),
          Padding(
            child: Icon(Icons.menu),
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          )
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: WillPopScope(
          child: Container(
            child: TabBarView(
              children: [
                NovelBookShelfView(),
//                HomeScene(),
                TabHomePage(),
                MeScene(),
              ],
              controller: primaryTC,
            ),
          ),
          onWillPop: () async {
            if (_lastClickTime == null ||
                DateTime.now().difference(_lastClickTime) >
                    Duration(seconds: 1)) {
              //两次点击间隔超过1秒则重新计时
              _lastClickTime = DateTime.now();
//              ToastUtils.showToast("再次点击退出应用");
              return false;
            }
            return true;
          }),
    );
  }

  @override
  void loadData(BuildContext context, BaseViewModel viewModel) {}

  @override
  BaseViewModel buildViewModel(BuildContext context) {
    return null;
  }
}
