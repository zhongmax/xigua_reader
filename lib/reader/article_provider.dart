import 'package:xigua_read/app/request.dart';
import 'package:xigua_read/model/article.dart';
import 'package:xigua_read/public.dart';

class ArticleProvider {
  static Future<Article> fetchArticle(int articleId) async {
    var response = await Request.get(action: 'article_$articleId');
    var article = Article.fromJson(response);

    return article;
  }
}