import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xigua_read/app/sq_color.dart';
import 'package:xigua_read/bookshelf/bookshelf_cloud_widget.dart';
import 'package:xigua_read/bookshelf/bookshelf_header.dart';
import 'package:xigua_read/db/db_helper.dart';
import 'package:xigua_read/model/novel_info.dart';
import 'package:xigua_read/novel/view/novel_book_reader.dart';
import 'package:xigua_read/public.dart';
import 'package:xigua_read/router/manager_router.dart';

import 'package:xigua_read/search/search_novel.dart';
import 'package:xigua_read/utility/screen.dart';
import 'package:xigua_read/utility/styles.dart';
import 'package:xigua_read/utility/utils.dart';
import 'package:xigua_read/widget/novel_cover_image.dart';

class BookshelfScene extends StatefulWidget {
	@override
	State<StatefulWidget> createState() => BookshelfSceneState();
}

class BookshelfSceneState extends State<BookshelfScene>
	with SingleTickerProviderStateMixin {
	double navAlpha = 0;
	ScrollController scrollController = ScrollController();
	var _dbHelper = DbHelper();
	List<BookshelfBean> _listBean = [];
	StreamSubscription booksSubscription;
	final String _emptyTitle = "添加书籍";

	AnimationController controller;
	Animation<double> animation;

	@override
	void initState() {
		super.initState();
		booksSubscription = eventBus.on<BooksEvent>().listen((event) {
			print("bookshelf_scene initState 生命周期");

			getDbData();
			for (int i = 0; i < _listBean.length; i++) {
				print(_listBean[0].title);
				break;
			}
		});

		getDbData();

		scrollController.addListener(() {
			var offset = scrollController.offset;
			if (offset < 0) {
				if (navAlpha != 0) {
					setState(() {
						navAlpha = 0;
					});
				}
			} else if (offset < 50) {
				setState(() {
					navAlpha = 1 - (50 - offset) / 50;
				});
			} else if (navAlpha != 1) {
				setState(() {
					navAlpha = 1;
				});
			}
		});

		// 头部
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

	Future<void> getDbData() async {
		try {
			print("使用了bookshelf page getDbData 的 getTotalList了吗");
			await _dbHelper.getTotalList().then((list) {
				_listBean.clear();
				list.reversed.forEach((item) {
					BookshelfBean todoItem = BookshelfBean.fromMap(item);
					print(todoItem.title);
					setState(() {
						_listBean.add(todoItem);
					});
				});

				// 添加图书选项卡
				BookshelfBean addItem =
				BookshelfBean(
					_emptyTitle,
					null,
					"",
					"",
					"",
					0,
					0,
					0);
				setState(() {
					_listBean.add(addItem);
				});
			});
		} catch (e) {

		}
	}

//  Widget BookshelfHeader(BookshelfBean bookshelfBean) {
//    AnimationController controller;
//    Animation<double> animation;
//
//  }

		@override
		Widget build(BuildContext context) {
			// TODO 绘制书架页面 -2/14 21:30
			// 书架页面完成, 还有一些bug -2/15 08:47
//			print("------------------构建画面------------------");
//			for (int i = 0; i < _listBean.length; i++) {
//				print(_listBean[i].title);
//			}
//			print("------------------构建画面结束------------------");
			return Scaffold(
				backgroundColor: SQColor.white,
				body: AnnotatedRegion(
					value: navAlpha > 0.5
						? SystemUiOverlayStyle.dark
						: SystemUiOverlayStyle.light,
					child: Stack(children: [
						RefreshIndicator(
							onRefresh: getDbData,
							child: ListView(
								physics: const AlwaysScrollableScrollPhysics(),
								padding: EdgeInsets.only(top: 0),
								controller: scrollController,
								children: <Widget>[
									_listBean.length > 0
										? BookshelfHeader(_listBean[0])
										: Container(),
									buildFavoriteView(),
								],
							),
						),

						buildNavigationBar(),
					]),
				),
			);
		}

		@override
		void dispose() {
			super.dispose();
			_dbHelper.close();
			booksSubscription.cancel();

			controller.dispose();
		}

		Widget buildActions(Color iconColor) {
			return Row(children: <Widget>[
				Container(
					height: kToolbarHeight,
					width: 44,
					child: Image.asset('img/actionbar_checkin.png', color: iconColor),
				),
				GestureDetector(
					onTap: () {
//          APPRouter.instance.route(APPRouterRequestOption(
//              APPRouter.ROUTER_NAME_NOVEL_SEARCH, context));
						Navigator.push(
							context, MaterialPageRoute(builder: (context) => SearchNovel()));
					},
					child: Container(
						height: kToolbarHeight,
						width: 44,
						child: Image.asset('img/actionbar_search.png', color: iconColor),
					),
				),
				SizedBox(width: 15)
			]);
		}

		Widget buildNavigationBar() {
			return Stack(
				children: <Widget>[
					Positioned(
						right: 0,
						child: Container(
							margin: EdgeInsets.fromLTRB(5, Screen.topSafeHeight, 0, 0),
							child: buildActions(SQColor.white),
						),
					),
					Opacity(
						opacity: navAlpha,
						child: Container(
							padding: EdgeInsets.fromLTRB(5, Screen.topSafeHeight, 0, 0),
							height: Screen.navigationBarHeight,
							color: SQColor.white,
							child: Row(
								children: <Widget>[
									SizedBox(width: 103),
									Expanded(
										child: Text(
											'书架',
											style: TextStyle(
												fontSize: 17, fontWeight: FontWeight.bold),
											textAlign: TextAlign.center,
										),
									),
									buildActions(SQColor.darkGray),
								],
							),
						),
					)
				],
			);
		}

		Widget buildFavoriteView() {
			if (_listBean.length <= 1) {
				return Container();
			}

			List<Widget> children = [];
			var novels = _listBean.sublist(1);
			for (int i = 0; i < novels.length; i++) {
				children.add(BookshelfItemView(novels[i], i));
			}
			var width = (Screen.width - 15 * 2 - 24 * 2) / 3;
			return Container(
				padding: EdgeInsets.fromLTRB(15, 20, 15, 15),
				child: Wrap(
					spacing: 23,
					children: children,
				),
			);
		}

		Widget BookshelfItemView(BookshelfBean novel, int index) {
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
						onTap: () {
							NovelBookInfo currentBookInfo = NovelBookInfo()
								..bookId = _listBean[index + 1].bookId
								..cover = _listBean[index + 1].image
								..title = _listBean[index + 1].title;
							APPRouter.instance.route(NovelBookReaderView.buildIntent(
								context, currentBookInfo));
						},
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
															_listBean.removeAt(index + 1);
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

		Widget BookshelfHeader(BookshelfBean bookshelfBean) {
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
						buildContent(context, bookshelfBean),
					],
				),
			);
		}

		Widget buildContent(BuildContext context, BookshelfBean bookshelfBean) {
			BookshelfBean novel = bookshelfBean;
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
							NovelBookInfo currentBookInfo = NovelBookInfo()
								..bookId = _listBean[0].bookId
								..cover = _listBean[0].image
								..title = _listBean[0].title;
							APPRouter.instance.route(NovelBookReaderView.buildIntent(
								context, currentBookInfo));
						},
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
															_listBean.removeAt(0);
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
						child: Row(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: <Widget>[
								DecoratedBox(
									child: NovelCoverImage(
										Utils.convertImageUrl(novel.image), width: 120,
										height: 160),
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
