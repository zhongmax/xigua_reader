import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui show window;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Screen {
  static double get width {
    MediaQueryData mediaQueryData = MediaQueryData.fromWindow(ui.window);
    return mediaQueryData.size.width;
  }

  static double get height {
    MediaQueryData mediaQueryData = MediaQueryData.fromWindow(ui.window);
    return mediaQueryData.size.height;
  }

  static double get scale {
    MediaQueryData mediaQueryData = MediaQueryData.fromWindow(ui.window);
    return mediaQueryData.devicePixelRatio;
  }

  static double get textScaleFactor {
    MediaQueryData mediaQueryData = MediaQueryData.fromWindow(ui.window);
    return mediaQueryData.textScaleFactor;
  }

  static double get navigationBarHeight {
    MediaQueryData mediaQueryData = MediaQueryData.fromWindow(ui.window);
    return mediaQueryData.padding.top + kToolbarHeight;
  }

  static double get topSafeHeight {
    MediaQueryData mediaQueryData = MediaQueryData.fromWindow(ui.window);
    return mediaQueryData.padding.top;
  }

  static double get bottomSafeHeight {
    MediaQueryData mediaQueryData = MediaQueryData.fromWindow(ui.window);
    return mediaQueryData.padding.bottom;
  }

  static updateStatusBarStyle(SystemUiOverlayStyle style) {
    SystemChrome.setSystemUIOverlayStyle(style);
  }
}