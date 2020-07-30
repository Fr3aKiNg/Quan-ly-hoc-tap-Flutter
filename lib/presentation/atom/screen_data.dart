import 'package:flutter/cupertino.dart';
import 'package:scheduleapp/presentation/page/on_board_detail.dart';


List<Widget> screenData(int numOfPages, data) {
  List<Widget> list = [];

  for (int i = 0; i < numOfPages; i++) {
    try {
      list.add(OnBoardInfo(data[i]));
    } catch (e) {
      print("You should provide enough content for all screens");
    }
  }
  return list;
}

