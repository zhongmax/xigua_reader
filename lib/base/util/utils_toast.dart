import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:xigua_read/app/sq_color.dart';

class ToastUtils{

  static void showToast(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: SQColor.blackA99,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

}