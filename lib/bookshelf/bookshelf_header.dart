import 'dart:async';

import 'package:flutter/material.dart';
import 'package:xigua_read/app/sq_color.dart';
import 'package:xigua_read/db/db_helper.dart';
import 'package:xigua_read/model/novel.dart';

import 'package:xigua_read/public.dart';
import 'package:xigua_read/search/search_novel.dart';
import 'package:xigua_read/utility/screen.dart';
import 'package:xigua_read/utility/styles.dart';
import 'package:xigua_read/utility/utils.dart';
import 'package:xigua_read/widget/novel_cover_image.dart';

import 'bookshelf_cloud_widget.dart';

class BookshelfHeader extends StatefulWidget {
  final BookshelfBean bookshelfBean;

  BookshelfHeader(this.bookshelfBean);

  @override
  _BookshelfHeaderState createState() => _BookshelfHeaderState();
}

class _BookshelfHeaderState extends State<BookshelfHeader>
  with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;


  @override
  initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller);

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    controller.forward();
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = Screen.width;
    var bgHeight = width / 0.9;
    var height = Screen.topSafeHeight + 250;
    return Container(
      width: width,
      height: height,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: height - bgHeight,
            child: Image.asset(
              'img/bookshelf_bg.png',
              fit: BoxFit.cover,
              width: width,
              height: bgHeight,
            ),
          ),
          // 云朵效果
          Positioned(
            bottom: 0,
            child: BookshelfCloudWidget(
              animation: animation,
              width: width,
            ),
          ),
          buildContent(context),
        ],
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    BookshelfBean novel = this.widget.bookshelfBean;
    String readProgress = novel.readProgress;
//    print("图片链接: " + novel.image);

    if (readProgress == "0") {
      readProgress = "未读";
    } else {
      readProgress = "已读$readProgress%";
    }

    var width = Screen.width;

    if (novel.title == "添加书籍") {
      return Container(
        width: width,
        padding: EdgeInsets.fromLTRB(15, 54 + Screen.topSafeHeight, 10, 0),
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SearchNovel()));
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DecoratedBox(
                child: Container(
                  width: 120,
                  height: 160,
                  color: SQColor.paper,
                  child: Image.asset('img/bookshelf_add.png'),
                ),
                decoration: BoxDecoration(boxShadow: Styles.borderShadow),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 40),
                    Text(novel.title,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
//                    SizedBox(height: 20),
//                    Row(
//                      children: <Widget>[
//                        Text('还没有喜欢的书籍 去添加看看？',
//                            style:
//                                TextStyle(fontSize: 14, color: SQColor.paper)),
//                        Image.asset('img/bookshelf_continue_read.png'),
//                      ],
//                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return Container(
        width: width,
        padding: EdgeInsets.fromLTRB(15, 54 + Screen.topSafeHeight, 10, 0),
        color: Colors.transparent,
        child: GestureDetector(
          onTap: () {
//          AppNavigator.pushNovelDetail(context, novel);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DecoratedBox(
                child: NovelCoverImage(Utils.convertImageUrl(novel.image), width: 120, height: 160),
                decoration: BoxDecoration(boxShadow: Styles.borderShadow),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 40),
                    Text(novel.title,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        Text('$readProgress     继续阅读 ',
                            style:
                                TextStyle(fontSize: 14, color: SQColor.paper)),
                        Image.asset('img/bookshelf_continue_read.png'),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
