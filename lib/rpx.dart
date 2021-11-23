library rpx;

import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

extension RpxExtension on num {
  double get rpx {
    return Rpx._getPx(toDouble());
  }
}

class Rpx {
  static late double _rpx;
  static late double _scale;
  static late double _screenWidth;
  static late double _screenHeight;
  static late double _designWidth;
  static late double _standardWidth;

  static Future<void> init({
    double designWidth = 375,
    double standardWidth = 750,
  }) {
    _designWidth = designWidth;
    _standardWidth = standardWidth;
    final Completer completer = Completer();
    // https://www.jianshu.com/p/4f0651241956
    if (window.physicalSize.isEmpty) {
      window.onMetricsChanged = () {
        if (!window.physicalSize.isEmpty) {
          window.onMetricsChanged = null;
          _setup();
          completer.complete();
        }
      };
    } else {
      _setup();
      completer.complete();
    }
    return completer.future;
  }

  static void _setup() {
    Size physicalSize = window.physicalSize;
    double dpr = window.devicePixelRatio;
    _screenWidth = physicalSize.width / dpr;
    _screenHeight = physicalSize.height / dpr;
    _scale = _standardWidth / _designWidth;
    _rpx = _screenWidth < _screenHeight
        ? _screenWidth / _standardWidth
        : _screenHeight / _standardWidth;
  }

  static double _getPx(double size) {
    return _rpx * size * _scale;
  }
}
