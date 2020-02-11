import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:xigua_read/app/app_navigator.dart';
import 'package:xigua_read/app/constant.dart';
import 'package:xigua_read/app/request.dart';
import 'package:xigua_read/app/sq_color.dart';
import 'package:xigua_read/base/structure/base_view.dart';
import 'package:xigua_read/model/novel.dart';
import 'package:xigua_read/model/novel_info.dart';
import 'package:xigua_read/novel/view_model/view_model_novel_shelf.dart';

import 'package:xigua_read/public.dart';
import 'package:xigua_read/router/manager_router.dart';
import 'package:xigua_read/utility/screen.dart';
import 'package:xigua_read/utility/toast.dart';

import 'bookshelf_item_view.dart';
import 'bookshelf_header.dart';

class BookshelfScene extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BookshelfState();
}

class BookshelfState extends State<BookshelfScene> with RouteAware {
  List<Novel> favoriteNovels = [];
  ScrollController scrollController = ScrollController();
  double navAlpha = 0;

  @override
  void initState() {
    super.initState();
    fetchData();

    scrollController.addListener(() {
      var offset = scrollController.offset;
      if (offset < 0) {
        if (navAlpha != 0) {
          setState(() {
            navAlpha = 0;
          });
        }
      } else if (offset < 50) {
        setState(() {
          navAlpha = 1 - (50 - offset) / 50;
        });
      } else if (navAlpha != 1) {
        setState(() {
          navAlpha = 1;
        });
      }
    });
  }

  Future<void> fetchData() async {
    try {
      List<Novel> favoriteNovels = [];
      List<dynamic> favoriteResponse = await Request.get(action: 'bookshelf');
      favoriteResponse.forEach((data) {
        favoriteNovels.add(Novel.fromJson(data));
      });

      setState(() {
        this.favoriteNovels = favoriteNovels;
      });
    } catch (e) {
      Toast.show(e.toString());
    }
  }

  Widget buildActions(Color iconColor) {
    return Row(children: <Widget>[
      Container(
        height: kToolbarHeight,
        width: 44,
        child: Image.asset('img/actionbar_checkin.png', color: iconColor),
      ),
      GestureDetector(
        onTap: () {
          APPRouter.instance.route(APPRouterRequestOption(
              APPRouter.ROUTER_NAME_NOVEL_SEARCH, context));
        },
        child: Container(
          height: kToolbarHeight,
          width: 44,
          child: Image.asset('img/actionbar_search.png', color: iconColor),
        ),
      ),
      SizedBox(width: 15)
    ]);
  }

  Widget buildNavigationBar() {
    return Stack(
      children: <Widget>[
        Positioned(
          right: 0,
          child: Container(
            margin: EdgeInsets.fromLTRB(5, Screen.topSafeHeight, 0, 0),
            child: buildActions(SQColor.white),
          ),
        ),
        Opacity(
          opacity: navAlpha,
          child: Container(
            padding: EdgeInsets.fromLTRB(5, Screen.topSafeHeight, 0, 0),
            height: Screen.navigationBarHeight,
            color: SQColor.white,
            child: Row(
              children: <Widget>[
                SizedBox(width: 103),
                Expanded(
                  child: Text(
                    '书架',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                buildActions(SQColor.darkGray),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget buildFavoriteView() {
    if (favoriteNovels.length <= 1) {
      return Container();
    }

    List<Widget> children = [];
    var novels = favoriteNovels.sublist(1);
    novels.forEach((novel) {
      children.add(BookshelfItemView(novel));
    });
    var width = (Screen.width - 15 * 2 - 24 * 2) / 3;
    children.add(GestureDetector(
      onTap: () {
        eventBus.emit(EventToggleTabBarIndex, 1);
      },
      child: Container(
        color: SQColor.paper,
        width: width,
        height: width / 0.75,
        child: Image.asset('img/bookshelf_add.png'),
      ),
    ));
    return Container(
      padding: EdgeInsets.fromLTRB(15, 20, 15, 15),
      child: Wrap(
        spacing: 23,
        children: children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SQColor.white,
      body: AnnotatedRegion(
        value: navAlpha > 0.5
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
        child: Stack(children: [
          RefreshIndicator(
            onRefresh: fetchData,
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              controller: scrollController,
              children: <Widget>[
                favoriteNovels.length > 0
                    ? BookshelfHeader(favoriteNovels[0])
                    : Container(),
                buildFavoriteView(),
              ],
            ),
          ),
          buildNavigationBar(),
        ]),
      ),
    );
  }
}
