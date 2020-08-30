import 'package:flutter/material.dart';
import 'package:scheduleapp/application/color_app.dart';
import 'package:scheduleapp/presentation/page/news_screen.dart';
import 'date_time_convert.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:scheduleapp/presentation/atom/date_time_convert.dart';

class ThumbnailNewcard extends StatelessWidget {
  ListItem _new;
  ThumbnailNewcard(ListItem TBNew) : _new = TBNew;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;
    return GestureDetector(
        onTap: () => openFeed(_new.link),
        child: Container(
            width: w * 50,
            height: h * 25,
            margin: EdgeInsets.fromLTRB(0, h * 2, w * 2, 0),
            padding: EdgeInsets.fromLTRB(w, h * 8, w, h),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(_new.imgUrl), fit: BoxFit.cover),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.schedule, size: 12, color: Colors.white),
                    Text(_new.subtitle,
                        style: TextStyle(fontSize: 12, color: Colors.white))
                  ],
                ),
                Expanded(
                    child: Text(
                  _new.title,
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ))
              ],
            )));
  }
}

class ThumbnailNews extends StatefulWidget {
  ThumbnailNewsState createState() => ThumbnailNewsState();
}

class ThumbnailNewsState extends State<ThumbnailNews> {
  static const List<String> FEED_URL = [
    'https://thanhnien.vn/rss/giao-duc.rss',
    'https://tuoitre.vn/rss/giao-duc.rss',
  ];
  RssFeed _feed;
  List<RssFeed> _feedList = [];
  List<ListItem> listItemAll = [];


  load() async {
    for (int i = 0; i < FEED_URL.length; i++) {
      loadFeed(FEED_URL[i]).then((result) {
        if (null == result || result.toString().isEmpty) {
          return;
        }
        updateFeed(result);
        getItems();
      });
    }
  }

  Future<RssFeed> loadFeed(url) async {
    try {
      final client = http.Client();
      final response = await client.get(url);
      return RssFeed.parse(response.body);
    } catch (e) {
      //
    }
    return null;
  }

  updateFeed(feed) {
    setState(() {
      _feed = feed;
    });
    _feedList.add(_feed);
  }

  getItems() {
    listItemAll.clear();
    for (int x = 0; x < _feedList.length; x++) {
      for (int i = 0; i < _feedList[x].items.length; i++) {
        var item = ListItem(
          _feedList[x].items[i].title,
          getDate(_feedList[x].items[i].pubDate) +
              ' ' +
              getTime(_feedList[x].items[i].pubDate),
          getImgUrl(_feedList[x].items[i].description),
          getUrl(_feedList[x].items[i].link),
        );

        listItemAll.add(item);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    load();
  }



  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
              flex: 6,
              child: Text("Tin tức",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
          Expanded(
              flex: 2,
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed('news_screen');
                  },
                  child: Text("Xem thêm",
                      style: TextStyle(
                          color: ColorApp.backgroundColor, fontSize: 16))))
        ],
      ),
      Container(
        width: w * 100,
        height: h * 18,
        child: ListView.builder(
            itemCount: 3,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final item = listItemAll[index];

              return ThumbnailNewcard(item);
            }),
      )
    ]);
  }
}

Future<void> openFeed(String url) async {
  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: true,
      forceWebView: false,
    );
    return;
  }
}