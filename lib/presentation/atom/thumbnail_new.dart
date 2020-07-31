

import 'package:flutter/material.dart';
import 'package:scheduleapp/application/color_app.dart';

class News {
  String title;
  String date;
  News(this.date,this.title);
}
class ThumbnailNewcard extends StatelessWidget{
  News _new;
  ThumbnailNewcard(News TBNew):_new = TBNew;
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;
    return Container(
      width: w*50,
      height: h*25,
      margin: EdgeInsets.fromLTRB(0, h*2, w*2, 0),
      padding: EdgeInsets.fromLTRB(w, h*8, w, h),
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/tb.jpg"),fit: BoxFit.cover),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10)),
      child:
        Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(children: <Widget>[
              Icon(Icons.schedule,size:12,color: Colors.white),
              Text(_new.date,style:TextStyle(fontSize: 12,color: Colors.white))
          ],),
          Expanded(child: Text(_new.title,style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold)))
        ],)
    );
  }
}
class ThumbnailNews extends StatelessWidget{
  List<News> listNews = [
    News("21/07/2020","10 ngày \'đua' vào trường chuyên của học sinh Sài Gòn"),
    News("20/07/2020","Cơ hội làm việc nước ngoài khi học Viện Điện tử - Viễn thông")
  ];
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(flex: 6,child: Text("Tin tức",style: TextStyle(
                fontSize: 16,  fontWeight: FontWeight.bold))),
            Expanded(flex: 2,child:
            GestureDetector(onTap: (){},child: Text("Xem thêm",style: TextStyle(color: ColorApp.backgroundColor,fontSize: 16))
            ))],
    ),
      Container(width: w*100,height: h*18,child: ListView.builder(itemCount: listNews.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context,index){
        final item  = listNews[index];
        return ThumbnailNewcard(item);
      }),)]
        );
  }
}