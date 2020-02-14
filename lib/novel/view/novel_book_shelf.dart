import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:xigua_read/app/sq_color.dart';
import 'package:xigua_read/base/structure/base_view.dart';
import 'package:xigua_read/base/structure/base_view_model.dart';
import 'package:xigua_read/model/novel/book_db.dart';
import 'package:xigua_read/model/novel_info.dart';
import 'package:xigua_read/novel/view/novel_book_reader.dart';
import 'package:xigua_read/novel/view_model/view_model_novel_shelf.dart';
import 'package:xigua_read/router/manager_router.dart';
import 'package:xigua_read/utility/screen.dart';
import 'package:xigua_read/widget/novel_cover_image.dart';

class NovelBookShelfView extends BaseStatefulView<NovelBookShelfViewModel> {
  @override
  BaseStatefulViewState<BaseStatefulView<BaseViewModel>,
      NovelBookShelfViewModel> buildState() {
    return _NovelBookShelfViewState();
  }
}

class _NovelBookShelfViewState
    extends BaseStatefulViewState<NovelBookShelfView, NovelBookShelfViewModel> {
  double navAlpha = 0;
  ScrollController scrollController = ScrollController();
  NovelBookDBModel _dbBookModel;

  @override
  Widget buildView(BuildContext context, NovelBookShelfViewModel viewModel) {
    var currentBookShelfInfo = viewModel.bookshelfInfo;

    for (NovelBookInfo novelBookInfo in currentBookShelfInfo.currentBookShelf) {
      print(novelBookInfo.title);
    }

    if (currentBookShelfInfo?.currentBookShelf == null ||
        currentBookShelfInfo.currentBookShelf.length == 0) {
      return Container(
        alignment: Alignment.center,
        child: InkWell(
          child: Text("没有内容，点击搜索添加"),
          onTap: () {
            APPRouter.instance.route(APPRouterRequestOption(
                APPRouter.ROUTER_NAME_NOVEL_SEARCH, context));
          },
        ),
      );
    } else {
//      return GridView.builder(
//        itemCount: currentBookShelfInfo.currentBookShelf.length + 1,
//        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//          crossAxisCount: 3,
//          crossAxisSpacing: 5,
//          mainAxisSpacing: 5,
//          childAspectRatio: 3 / 4),
//        itemBuilder: (context, index) {
//          if (index <= currentBookShelfInfo.currentBookShelf.length - 1) {
//            return Container(
//              color: Colors.white,
//              child: InkWell(
//                child: NovelItemWidget(
//                  currentBookShelfInfo.currentBookShelf[index]),
//                onTap: () {
//                  var currentBookShelf =
//                  currentBookShelfInfo.currentBookShelf[index];
//                  APPRouter.instance.route(NovelBookReaderView.buildIntent(
//                    context, currentBookShelf));
//                },
//              ),
//            );
//          } else {
//            return Container(
//              color: Colors.white,
//              child: IconButton(
//                icon: Icon(Icons.add),
//                onPressed: () {
//                  // 跳转到搜索页面
//                  APPRouter.instance.route(APPRouterRequestOption(
//                    APPRouter.ROUTER_NAME_NOVEL_SEARCH, context));
//                }),
//            );
//          }
//        });
//      List<Widget> children = [];
//      var novles = currentBookShelfInfo.currentBookShelf.sublist(0);
//      novles.forEach((novel) {
//        children.add()
//      });
//      return Container(
//
//      );
      // TODO 绘制书架页面 -2/14 21:30
      return Scaffold(
        backgroundColor: SQColor.white,
        body: AnnotatedRegion(
          value: navAlpha > 0.5 ? SystemUiOverlayStyle.dark
	          : SystemUiOverlayStyle.light,
          child: Stack(children: <Widget>[

              ListView(
                padding: EdgeInsets.only(top: 0),
                controller: scrollController,
                children: <Widget>[
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                  Text("233"),
                ],

            ),
            buildNavigationBar(),
          ]),
        ),
      );
    }
  }

  @override
  NovelBookShelfViewModel buildViewModel(BuildContext context) {
    return NovelBookShelfViewModel(
      Provider.of(context),
      Provider.of(context),
    );
  }

  @override
  void initData() {
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

  @override
  void loadData(BuildContext context, NovelBookShelfViewModel viewModel) {
    viewModel?.getSavedBook();
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


}

class NovelItemWidget extends StatefulWidget {
  final NovelBookInfo bookInfo;

  NovelItemWidget(this.bookInfo);

  @override
  _NovelItemWidgetState createState() => _NovelItemWidgetState();
}

class _NovelItemWidgetState extends State<NovelItemWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    var width = (Screen.width - 15*2 - 24*2) / 3;
    return Container(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DecoratedBox(
            child: NovelCoverImage(
              widget.bookInfo.cover,
              width: width,
              height: width / 0.75,
            ),
            decoration: BoxDecoration(boxShadow: [BoxShadow(color: Color(0x22000000), blurRadius: 5)]),
          ),
          SizedBox(height: 10,),
          Text(widget.bookInfo.title, style: TextStyle(fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis,),
          SizedBox(height: 25,),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
