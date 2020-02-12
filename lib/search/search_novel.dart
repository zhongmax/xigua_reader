import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:xigua_read/base/structure/base_view.dart';
import 'package:xigua_read/base/structure/base_view_model.dart';
import 'package:xigua_read/model/novel/book_net.dart';
import 'package:xigua_read/novel/view_model/view_model_novel_search.dart';
import 'package:xigua_read/router/manager_router.dart';

class SearchNovel extends BaseStatefulView<NovelBookSearchViewModel> {
  static SearchNovel getPageView() {
    return SearchNovel();
  }

  @override
  BaseStatefulViewState<BaseStatefulView<BaseViewModel>,
      NovelBookSearchViewModel> buildState() {
    return _SearchNovelState();
  }
}

class _SearchNovelState
    extends BaseStatefulViewState<SearchNovel, NovelBookSearchViewModel> {
  FocusNode _focusNode;
  StreamController inputStreamController = StreamController();
  Observable switchObservable;

  @override
  Widget buildView(BuildContext context, NovelBookSearchViewModel viewModel) {
    SearchContentEntity contentEntity = viewModel.contentEntity;
    print("SearchContentEntity的数据有");
    for (int i = 0; i < contentEntity.searchHotWord.length; i++) {
      print(contentEntity.searchHotWord[i]);
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Material(
        color: Colors.white,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            titleSpacing: 0.0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Icon(Icons.arrow_back),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(right: 40),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Color(0xFFF5F5F5)),
                      alignment: Alignment.center,
                      child: TextField(
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.search,
                        textAlignVertical: TextAlignVertical.center,
                        focusNode: _focusNode,
                        onChanged: (data) {
                          inputStreamController.sink.add(data);
                        },
                        onSubmitted: (data) {
                          HashMap<String, String> params = HashMap();
                          params["search_key"] = data;
                          APPRouter.instance.route(APPRouterRequestOption(
                              APPRouter.ROUTER_NAME_NOVEL_SEARCH_RESULT, context,
                              params: params));
                        },
                        style: TextStyle(
                            textBaseline: TextBaseline.alphabetic,
                            fontSize: 15),
                        decoration: InputDecoration(
                            hintText: "输入你要查询的书籍名",
                            prefixIcon: Icon(Icons.search),
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          // 输入框抵住键盘
          resizeToAvoidBottomPadding: false,
          body: Builder(builder: (context) {
            List<Widget> stackChildren = [];
            stackChildren
                .add(_SearchStackBottomWidget(contentEntity.searchHotWord));
            if (contentEntity?.autoCompleteSearchWord?.length != null &&
                contentEntity.autoCompleteSearchWord.length > 0) {
              stackChildren.add(_SearchStackAutoCompleteWidget(
                  contentEntity.autoCompleteSearchWord, () {
                setState(() {
                  contentEntity?.autoCompleteSearchWord?.clear();
                });
              }));
            }
            return Container(
              child: Stack(
                children: stackChildren,
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  NovelBookSearchViewModel buildViewModel(BuildContext context) {
    return NovelBookSearchViewModel(Provider.of(context));
  }

  @override
  void initData() {
    switchObservable = Observable(inputStreamController.stream)
        .debounceTime(const Duration(milliseconds: 300));

    _focusNode = FocusNode();
    _focusNode.addListener(_onTextFocusChanged);
  }

  @override
  void loadData(BuildContext context, NovelBookSearchViewModel viewModel) {
    // 监听文本域数据改变
    switchObservable.listen((word) {
      viewModel.getSearchWord(word);
    });

    viewModel.getHotSearchWord();
  }

  @override
  void dispose() {
    super.dispose();
    inputStreamController?.close();
    inputStreamController = null;
  }

  void _onTextFocusChanged() {
    if (_focusNode.hasFocus) {}
  }
}

class _SearchStackBottomWidget extends StatelessWidget {
  final List<String> hotWords;

  _SearchStackBottomWidget(this.hotWords);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Text(
                "热搜",
                style: TextStyle(fontSize: 24),
              ),
            ),
            SliverToBoxAdapter(
              child: Wrap(
                spacing: 5,
                children: hotWords
                    .map((word) => RaisedButton(
                          color: Colors.grey[300],
                          elevation: 2.0,
                          highlightElevation: 4.0,
                          disabledElevation: 0.0,
                          highlightColor: Colors.grey[400],
                          splashColor: Colors.grey,
                          child: Text(word),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          onPressed: () {
                            HashMap<String, String> params = HashMap();
                            params["search_key"] = word;
                            APPRouter.instance.route(APPRouterRequestOption(
                                APPRouter.ROUTER_NAME_NOVEL_SEARCH_RESULT,
                                context,
                                params: params));
                          },
                        ))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _SearchStackAutoCompleteWidget extends StatelessWidget {
  final List<String> autoCompleteWords;

  final VoidCallback onCancelAreaClick;

  _SearchStackAutoCompleteWidget(
      this.autoCompleteWords, this.onCancelAreaClick);

  @override
  Widget build(BuildContext context) {
    print("auto是: " + autoCompleteWords.toString());
    return Container(
      child: Column(
        children: <Widget>[
          ListView.builder(
            itemBuilder: (context, index) {
              return Container(
                color: Colors.white,
                child: InkWell(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      autoCompleteWords[index],
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  onTap: () {
                    HashMap<String, String> params = HashMap();
                    params["search_key"] = autoCompleteWords[index];
                    APPRouter.instance.route(APPRouterRequestOption(
                        APPRouter.ROUTER_NAME_NOVEL_SEARCH_RESULT, context,
                        params: params));
                  },
                ),
              );
            },
            itemCount: autoCompleteWords.length,
            shrinkWrap: true,
          ),
          Expanded(
            flex: 1,
            child: Opacity(
              opacity: 0.7,
              child: GestureDetector(
                child: Container(
                  color: Colors.black,
                ),
                onTap: () {
                  onCancelAreaClick();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
