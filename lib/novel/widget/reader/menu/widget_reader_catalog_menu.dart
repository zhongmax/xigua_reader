import 'package:flutter/material.dart';
import 'package:xigua_read/model/novel_book_chapter.dart';
import 'package:xigua_read/novel/widget/reader/menu/manager_menu_widget.dart';
import 'package:xigua_read/widget/scrollable_positioned_list/scrollable_positioned_list.dart';


class NovelCatalogMenu extends StatefulWidget {
  final NovelBookChapter bookChapter;
  final OnMenuItemClicked _menuItemClickedCallback;
  final int currentChapterIndex;

  NovelCatalogMenu(this.bookChapter, this.currentChapterIndex,
      this._menuItemClickedCallback, Key key)
      : super(key: key);

  @override
  _NovelCatalogMenuState createState() => _NovelCatalogMenuState();
}

class _NovelCatalogMenuState extends State<NovelCatalogMenu> {
  ItemScrollController primaryISC;

  @override
  void initState() {
    super.initState();
    primaryISC = ItemScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
          child:  ScrollablePositionedList.builder(
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                widget._menuItemClickedCallback(
                    MenuOperateEnum.OPERATE_SELECT_CHAPTER, index);
              },
              child: Container(
                padding: EdgeInsets.all(15),
                child: Text(
                  widget?.bookChapter?.chapters[index].title,
                  style: TextStyle(fontSize: 20, height: 1.5,color: Colors.white),
                ),
              ),
            );
          },
          itemCount: widget?.bookChapter?.chapters?.length,
          itemScrollController: primaryISC,
          initialScrollIndex: widget.currentChapterIndex,
        ),
      ),
    );
  }
}
