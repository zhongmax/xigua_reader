import 'package:flutter/material.dart';
import 'package:xigua_read/app/sq_color.dart';
import 'package:xigua_read/search/search_novel.dart';
import 'package:xigua_read/ui/home/home_tab_list_view.dart';

class TabHomePage extends StatefulWidget {
	@override
	State<StatefulWidget> createState() => _TabHomePageState();
}

class _TabHomePageState extends State<TabHomePage> {
	@override
	Widget build(BuildContext context) {
		return DefaultTabController(
			length: 4,
			child: Scaffold(
				body: SafeArea(
					child: Column(
						children: <Widget>[
							SizedBox(height: 10,),
							Flex(
								direction: Axis.horizontal,
								children: <Widget>[
									Expanded(
										flex: 1,
										child: GestureDetector(
											onTap: () {
												Navigator.push(
													context,
													MaterialPageRoute(
														builder: (context) => SearchNovel()));
											},
											child: Container(
												margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
												decoration: BoxDecoration(
													borderRadius: BorderRadius.all(Radius.circular(5)),
													color: SQColor.homeGrey,
												),
												padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
												child: Row(
													mainAxisSize: MainAxisSize.max,
													children: <Widget>[
														Image.asset(
															"img/home_search.png",
															width: 15,
															height: 15,
														),
														Text(
															"   搜索本地及网络书籍",
															style: TextStyle(
																color: SQColor.homeGreyText,
																fontSize: 15,
															),
														),
													],
												),
											),
										),
									),
									GestureDetector(
										onTap: () {
											print("333333333333333");
										},
										child: Container(
											margin: EdgeInsets.fromLTRB(0, 3, 0, 0),
											padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
											child: Column(
												children: <Widget>[
													Image.asset(
														"img/icon_classification.png",
														width: 22,
														height: 22,
													),
													Text(
														"分类",
														style: TextStyle(
															color: SQColor.textBlack6,
															fontSize: 11,
														),
													),
												],
											),
										),
									),
								],
							),
							TabBar(
								labelColor: SQColor.homeTabText,
								unselectedLabelColor: SQColor.homeTabGreyText,
								labelStyle: TextStyle(fontSize: 16),
								labelPadding: EdgeInsets.fromLTRB(0, 10, 0, 10),
								indicatorColor: SQColor.homeTabText,
								indicatorSize: TabBarIndicatorSize.label,
								indicatorWeight: 2,
								indicatorPadding: EdgeInsets.fromLTRB(0, 0, 0, 6),
								tabs: <Widget>[
									Text("精选"),
									Text("男生"),
									Text("女生"),
									Text("出版"),
								],
							),
							Divider(height: 1, color: SQColor.dividerDarkColor),
							Expanded(
								child: TabBarView(children: [
									HomeTabListView('male', '仙侠'),
									HomeTabListView('male', '玄幻'),
									HomeTabListView('female', '现代言情'),
									HomeTabListView('press', '出版小说'),
								]),
							)
						],
					),
				),
			));
	}
}