import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xigua_read/me/login_scene.dart';
import 'package:xigua_read/me/web_scene.dart';
import 'package:xigua_read/model/novel.dart';
import 'package:xigua_read/novel_detail/novel_detail_scene.dart';
import 'package:xigua_read/reader/reader_scene.dart';
import 'package:xigua_read/search/search_novel.dart';

class AppNavigator {
  static push(BuildContext context, Widget scene) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => scene,
      ),
    );
  }

  static pushSearch(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return SearchNovel();
    }));
  }

  static pushNovelDetail(BuildContext context, Novel novel) {
    AppNavigator.push(context, NovelDetailScene(novel.id));
  }

  static pushLogin(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LoginScene();
    }));
  }

  static pushWeb(BuildContext context, String url, String title) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return WebScene(url: url, title: title);
    }));
  }

  static pushReader(BuildContext context, int articleId) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ReaderScene(articleId: articleId);
    }));
  }
}