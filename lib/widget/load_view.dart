import 'package:flutter/material.dart';
import 'package:xigua_read/app/sq_color.dart';

class LoadingView extends StatefulWidget {
	@override
	State<StatefulWidget> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView>
	with SingleTickerProviderStateMixin {
	List<String> _imageList = [
		"img/icon_load_1.png",
		"img/icon_load_2.png",
		"img/icon_load_3.png",
		"img/icon_load_4.png",
		"img/icon_load_5.png",
		"img/icon_load_6.png",
		"img/icon_load_7.png",
		"img/icon_load_8.png",
		"img/icon_load_9.png",
		"img/icon_load_10.png",
		"img/icon_load_11.png",
	];
	Animation<int> _animation;
	AnimationController _controller;
	int _position = 0;

	@override
	void initState() {
		super.initState();
		_controller =
			AnimationController(vsync: this, duration: Duration(milliseconds: 800));
		_animation = IntTween(begin: 0, end: 10).animate(_controller)
			..addListener(() {
				if (_position != _animation.value) {
					setState(() {
						_position = _animation.value;
					});
				}
			});

		_animation.addStatusListener((status) {
			if (status == AnimationStatus.completed) {
				_controller.reverse();
			} else if (status == AnimationStatus.dismissed) {
				_controller.forward();
			}
		});
		_controller.forward();
	}

	@override
	Widget build(BuildContext context) {
		return Container(
			width: double.infinity,
			color: SQColor.homeGrey,
			child: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				crossAxisAlignment: CrossAxisAlignment.center,
				children: <Widget>[
					Image.asset(
						_imageList[_position],
						width: 43,
						height: 43,
						gaplessPlayback: true,
					),
				],
			)
		);
	}

	dispose() {
		_controller.dispose();
		super.dispose();
	}
}

class FailureView extends StatefulWidget {
	final OnLoadReloadListener _listener;

	FailureView(this._listener);

	@override
	State<StatefulWidget> createState() => _FailureViewState();
}

class _FailureViewState extends State<FailureView> {
	@override
	Widget build(BuildContext context) {
		return Container(
			color: SQColor.homeGrey,
			width: double.infinity,
			child: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				crossAxisAlignment: CrossAxisAlignment.center,
				children: <Widget>[
					Image.asset(
						"img/icon_network_error.png",
						width: 150,
						height: 150,
					),
					SizedBox(
						height: 14,
					),
					Text(
						"咦？没网络啦~检查下设置吧",
						style: TextStyle(fontSize: 12, color: SQColor.textBlack9),
					),
					SizedBox(
						height: 25,
					),
					MaterialButton(
						onPressed: () {
							this.widget._listener.onReload();
						},
						minWidth: 150,
						height: 43,
						color: SQColor.homeTabText,
						child: Text(
							"重新加载",
							style: TextStyle(
								color: SQColor.white,
								fontSize: 16,
							),
						),
					)
				],
			),
		);
	}
}

abstract class OnLoadReloadListener {
	void onReload();
}

enum LoadStatus {
	LOADING,
	SUCCESS,
	FAILURE,
}