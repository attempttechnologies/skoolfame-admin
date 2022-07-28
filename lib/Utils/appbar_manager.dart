import 'package:flutter/material.dart';

class AppBarManger {
  bool isStreamListen = false;

  ValueNotifier<bool> valueNotifier = ValueNotifier(true);

  void updateAppBarStatus(status) {
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => valueNotifier.value = status);
  }
}

var appBarManager = AppBarManger();
