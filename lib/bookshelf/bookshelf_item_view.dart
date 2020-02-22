import 'package:flutter/material.dart';
import 'package:xigua_read/app/app_navigator.dart';
import 'package:xigua_read/app/sq_color.dart';
import 'package:xigua_read/db/db_helper.dart';
import 'package:xigua_read/model/novel.dart';

import 'package:xigua_read/public.dart';
import 'package:xigua_read/search/search_novel.dart';
import 'package:xigua_read/utility/screen.dart';
import 'package:xigua_read/utility/utils.dart';
import 'package:xigua_read/widget/novel_cover_image.dart';

class BookshelfItemView extends StatefulWidget {
  final BookshelfBean novel;
  final int index;
  final List<BookshelfBean> listBean;

  BookshelfItemView(this.novel, this.index, this.listBean);

  @override
  State<StatefulWidget> createState() => BookshelfItemViewState();
}

class BookshelfItemViewState extends State<BookshelfItemView> {

  var _dbHelper = DbHelper();
  BookshelfBean novel;


  @override
  Widget build(BuildContext context) {
//    print("小说ID为 " + novel.id);
    var width = (Screen.width - 15 * 2 - 24 * 2) / 3;
    if (novel.title == "添加书籍") {
      return Container(
          width: width,
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchNovel()));
            },

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DecoratedBox(
                  child: Container(
                    child: Image.asset('img/bookshelf_add.png'),
                    width: width,
                    height: width / 0.75,
                    color: SQColor.paper,
                  ),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(color: Color(0x22000000), blurRadius: 5)
                  ]),
                ),
                SizedBox(height: 10),
                Text(novel.title,
                    style: TextStyle(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                SizedBox(height: 25),
              ],
            ),
          ));
    } else {
      return Container(
          width: width,
          child: GestureDetector(
            onTap: () {},
            onLongPress: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return AlertDialog(
                    title: Text("删除书籍"),
                    content: Text("删除此书后, 书籍源文件及阅读进度也将被删除"),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _dbHelper.deleteBooks(novel.bookId).then((i) {
                            setState(() {
                              widget.listBean.removeAt(widget.index);
                            });
                          });
                        },
                        child: Text("确定"),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("取消"),
                      ),
                    ],
                  );
                });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DecoratedBox(
                  child: NovelCoverImage(
                    Utils.convertImageUrl(novel.image),
                    width: width,
                    height: width / 0.75,
                  ),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(color: Color(0x22000000), blurRadius: 5)
                  ]),
                ),
                SizedBox(height: 10),
                Text(novel.title,
                    style: TextStyle(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                SizedBox(height: 25),
              ],
            ),
          ));
    }
  }

  @override
  void initState() {
    novel = widget.novel;
  }
}
