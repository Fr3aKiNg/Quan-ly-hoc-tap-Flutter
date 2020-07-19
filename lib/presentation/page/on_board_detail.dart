import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:Educare/application/color_app.dart';

class OnBoardDetail {
  String imgUrl;
  String title;
  String des;
  OnBoardDetail(this.imgUrl, this.title, this.des);
}

class OnBoardInfo extends StatelessWidget {
  OnBoardDetail item;
  OnBoardInfo(OnBoardDetail _item) : item = _item;
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;
    return Container(margin: EdgeInsets.fromLTRB(0, h*15, 0, h*10),
        padding: EdgeInsets.fromLTRB(w*4, 0, w*2, 0),
        width: w*100,height: h*80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              item.imgUrl,
              fit: BoxFit.cover,
              width: w * 100,
              height: h * 45,
            ),
           Text(item.title,
                style: TextStyle(fontSize: 32, color: Colors.black,fontWeight: FontWeight.w600)),
            SizedBox(height: h * 5),
        Text(item.des, style: TextStyle(fontSize: 16, color: Colors.black)),

          ],
        ));
  }
}
