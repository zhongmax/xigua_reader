import 'package:flutter/material.dart';
import 'package:xigua_read/app/app_navigator.dart';
import 'package:xigua_read/model/novel.dart';

import 'package:xigua_read/public.dart';
import 'package:xigua_read/utility/screen.dart';
import 'package:xigua_read/widget/novel_cover_image.dart';

class BookshelfItemView extends StatelessWidget {
  final Novel novel;
  BookshelfItemView(this.novel);
  @override
  Widget build(BuildContext context) {
//    print("小说ID为 " + novel.id);
    var width = (Screen.width - 15 * 2 - 24 * 2) / 3;
    return GestureDetector(
      // 点击事件
      onTap: () {
        AppNavigator.pushNovelDetail(context, novel);
      },
      child: Container(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DecoratedBox(
              child: NovelCoverImage(
                novel.imgUrl,
                width: width,
                height: width / 0.75,
              ),
              decoration: BoxDecoration(boxShadow: [BoxShadow(color: Color(0x22000000), blurRadius: 5)]),
            ),
            SizedBox(height: 10),
            Text(novel.name, style: TextStyle(fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
