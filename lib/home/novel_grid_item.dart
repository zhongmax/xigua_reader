import 'package:flutter/material.dart';
import 'package:xigua_read/app/app_navigator.dart';
import 'package:xigua_read/app/sq_color.dart';
import 'package:xigua_read/model/novel.dart';

import 'package:xigua_read/public.dart';
import 'package:xigua_read/utility/screen.dart';
import 'package:xigua_read/widget/novel_cover_image.dart';

class NovelGridItem extends StatelessWidget {
  final Novel novel;

  NovelGridItem(this.novel);

  @override
  Widget build(BuildContext context) {
    var width = (Screen.width - 15 * 2 - 15) / 2;
    return GestureDetector(
      onTap: () {
        // TODO 修复点击后的ID
        AppNavigator.pushNovelDetail(context, this.novel);
      },
      child: Container(
        width: width,
        child: Row(
          children: <Widget>[
            NovelCoverImage(novel.imgUrl, width: 50, height: 66),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    novel.name,
                    maxLines: 2,
                    style: TextStyle(fontSize: 16, height: 1.2, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    novel.recommendCountStr(),
                    style: TextStyle(fontSize: 12, color: SQColor.gray),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
