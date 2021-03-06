import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:xigua_read/base/structure/base_view.dart';
import 'package:xigua_read/model/novel_book_key_word_search.dart';
import 'package:xigua_read/novel/view/novel_book_intro.dart';
import 'package:xigua_read/novel/view_model/view_model_novel_search.dart';


class NovelSearchResultView
    extends BaseStatelessView<NovelBookSearchViewModel> {
  NovelSearchResultView(this.searchKeyWord);

  final String searchKeyWord;

  static NovelSearchResultView getPageView(String searchKeyWord) {
    return NovelSearchResultView(searchKeyWord);
  }

  @override
  Widget buildView(BuildContext context, NovelBookSearchViewModel viewModel) {
    NovelKeyWordSearch keyWordSearchResult =
        viewModel?.contentEntity.keyWordSearchResult;

    return Scaffold(
      appBar: AppBar(
        title: Text("关于$searchKeyWord的书籍"),
      ),
      body: Builder(builder: (context) {
        if (keyWordSearchResult == null) {
          return Container(
            alignment: Alignment.center,
            child: Text("正在查询"),
          );
        } else {
          return ListView.separated(
            itemBuilder: (context, index) {
              return Container(
                child: InkWell(
                  onTap: () {
                  print("图书ID为: " + keyWordSearchResult.books[index].id);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                NovelBookIntroView.getPageView(
                                    keyWordSearchResult?.books[index]?.id)));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: CachedNetworkImage(
                          imageUrl: Uri.decodeComponent(keyWordSearchResult
                              .books[index].cover
                              .split("/agent/")
                              .last),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              keyWordSearchResult.books[index].title,
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            Divider(
                              height: 5,
                              color: Colors.transparent,
                            ),
                            Text(
                              keyWordSearchResult.books[index].shortIntro,
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[600]),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Divider(
                              height: 5,
                              color: Colors.transparent,
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.account_circle),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  keyWordSearchResult.books[index].author,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                height: 5,
                color: Colors.grey,
              );
            },
            itemCount: keyWordSearchResult.books.length,
          );
        }
      }),
    );
  }

  @override
  NovelBookSearchViewModel buildViewModel(BuildContext context) {
    return NovelBookSearchViewModel(Provider.of(context));
  }

  @override
  void loadData(BuildContext context, NovelBookSearchViewModel viewModel) {
    viewModel.searchTargetKeyWord(searchKeyWord);
  }
}
