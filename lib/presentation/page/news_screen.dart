import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scheduleapp/application/color_app.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:scheduleapp/presentation/atom/date_time_convert.dart';
import 'package:scheduleapp/presentation/page/home_screen.dart';
//import 'getRSS.dart';

class ListItem {
  String title;
  String subtitle;
  String imgUrl;
  String link;
  ListItem(this.title, this.subtitle, this.imgUrl, this.link);
}

class MyTabbedPage extends StatefulWidget {
  const MyTabbedPage({Key key}) : super(key: key);

  @override
  _MyTabbedPageState createState() => _MyTabbedPageState();
}

class _MyTabbedPageState extends State<MyTabbedPage>
    with SingleTickerProviderStateMixin {
  // rss url
  static const List<String> FEED_URL = [
    'https://thanhnien.vn/rss/giao-duc.rss',
    'https://tuoitre.vn/rss/giao-duc.rss',
  ];

  static const String placeholderImg = 'assets/no_image.png';
  RssFeed _feed;
  List<RssFeed> _feedList = [];

  List<ListItem> listItemDH = [];
  List<ListItem> listItemCD = [];
  List<ListItem> listItemC3 = [];
  List<ListItem> listItemC2 = [];
  List<ListItem> listItemC1 = [];
  List<ListItem> listItemAll = [];
  List<String> uniKeyword = ['đại học', 'đh'];
  List<String> colKeyword = ['cao đẳng', 'cđ', 'trung cấp'];
  List<String> higKeyword = [
    'cấp 3',
    'trung học phổ thông',
    'thpt',
    'khối 12',
    'khối 11',
    'khối 10',
    'lớp 10',
    'lớp 11',
    'lớp 12'
  ];
  List<String> junHigKeyword = [
    'cấp 2',
    'trung học cơ sở',
    'thcs',
    'khối 9',
    'khối 8',
    'khối 7',
    'lớp 6',
    'lớp 9',
    'lớp 8',
    'lớp 7',
    'lớp 6'
  ];
  List<String> eleKeyword = ['cấp 1', 'tiểu học', 'lớp 1'];
  List<String> allTabKeyword = ['học sinh'];

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

  @override
  void initState() {
    super.initState();

    load();
  }

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

  title(title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  subtitle(subTitle) {
    return Text(
      subTitle,
      style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w100),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  thumbnail(imageUrl) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0),
      child: CachedNetworkImage(
        placeholder: (context, url) => Image.asset(placeholderImg),
        imageUrl: imageUrl,
        height: 50,
        width: 70,
        alignment: Alignment.center,
        fit: BoxFit.fill,
      ),
    );
  }

  rightIcon() {
    return Icon(
      Icons.keyboard_arrow_right,
      color: Colors.grey,
      size: 30.0,
    );
  }

  isTabContain(List<String> keywords, String title) {
    for (int j = 0; j < keywords.length; j++) {
      if (title.toLowerCase().contains(keywords[j])) {
        return true;
      }
    }
    return false;
  }

  isAllTabContent(str) {
    bool tmp = false;
    if (isTabContain(higKeyword, str)) {
      tmp = true;
    }
    if (isTabContain(junHigKeyword, str)) {
      tmp = true;
    }
    if (isTabContain(eleKeyword, str)) {
      tmp = true;
    }
    if (tmp == false && isTabContain(allTabKeyword, str)) {
      return true;
    } else
      return false;
  }

  getItems() {
    listItemDH.clear();
    listItemCD.clear();
    listItemC3.clear();
    listItemC2.clear();
    listItemC1.clear();
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
        String str = _feedList[x].items[i].description;
        if (isTabContain(uniKeyword, str)) {
          listItemDH.add(item);
        }
        if (isTabContain(colKeyword, str)) {
          listItemCD.add(item);
        }
        if (isTabContain(higKeyword, str) || isAllTabContent(str)) {
          listItemC3.add(item);
        }
        if (isTabContain(junHigKeyword, str) || isAllTabContent(str)) {
          listItemC2.add(item);
        }
        if (isTabContain(eleKeyword, str) || isAllTabContent(str)) {
          listItemC1.add(item);
        }
      }
    }
  }

  list(listItem) {
    //getTHCS();
    return ListView.builder(
      itemCount: listItem.length,
      itemBuilder: (BuildContext context, int index) {
        final item = listItem[index];

        return ListTile(
          title: title(item.title),
          subtitle: subtitle(item.subtitle),
          leading: thumbnail(item.imgUrl),
          trailing: rightIcon(),
          contentPadding: EdgeInsets.all(5.0),
          onTap: () => openFeed(item.link),
        );
      },
    );
  }

  isFeedEmpty() {
    if (null == _feedList)
      return true;
    else {
      for (int i = 0; i < _feedList.length; i++) {
        if (_feedList[i] == null || _feedList[i].items == null) return true;
      }
    }
    return false;
  }

  body(listItem) {
    return isFeedEmpty()
        ? Center(
            child: CircularProgressIndicator(),
          )
        : list(listItem);
  }

  @override
  Widget build(BuildContext context) {
    double orjWidth = MediaQuery.of(context).size.width;
    double cameraWidth = orjWidth / 24;
    double yourWidth = (orjWidth - cameraWidth) / 4;
    double tabHeight = 50.0;

    return DefaultTabController(
      length: 5,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorApp.backgroundColor,
            centerTitle: true,
            leading: GestureDetector(
              child: Icon(Icons.arrow_back),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            title: Text(
              'Đọc báo',
              style: TextStyle(fontSize: 20.0),
            ),
            bottom: PreferredSize(
                child: TabBar(
                    isScrollable: true,
                    unselectedLabelColor: Colors.white.withOpacity(0.3),
                    indicatorColor: Colors.white,
                    tabs: [
                      Container(
                        width: yourWidth,
                        height: tabHeight,
                        alignment: Alignment.center,
                        child: Text("TẤT CẢ"),
                      ),
                      Container(
                        width: yourWidth,
                        height: tabHeight,
                        alignment: Alignment.center,
                        child: Text('ĐẠI HỌC'),
                      ),
                      /*Container(
                        width: yourWidth,
                        height: tabHeight,
                        alignment: Alignment.center,
                        child: Text('CAO ĐẲNG'),
                      ),*/
                      Container(
                        width: yourWidth,
                        height: tabHeight,
                        alignment: Alignment.center,
                        child: Text('CẤP 3'),
                      ),
                      Container(
                        width: yourWidth,
                        height: tabHeight,
                        alignment: Alignment.center,
                        child: Text('CẤP 2'),
                      ),
                      Container(
                        width: yourWidth,
                        height: tabHeight,
                        alignment: Alignment.center,
                        child: Text('TIỂU HỌC'),
                      ),
                    ]),
                preferredSize: Size.fromHeight(60.0)),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
              ),
            ],
          ),
          body: TabBarView(
            children: <Widget>[
              Container(
                child: body(listItemAll),
              ),
              Container(
                child: Center(
                  child: body(listItemDH),
                ),
              ),
              /*Container(
                child: Center(
                  child: body(listItemCD),
                ),
              ),*/
              Container(
                child: Center(
                  child: body(listItemC3),
                ),
              ),
              Container(
                child: Center(
                  child: body(listItemC2),
                ),
              ),
              Container(
                child: Center(
                  child: body(listItemC1),
                ),
              ),
            ],
          )),
    );
  }
}

getImgUrl(str) {
  final imgTag = 'img';
  final idx = str.indexOf(imgTag);
  final subStr = str.substring(idx);
  return getUrl(subStr);
}

getUrl(str) {
  var urlPattern =
      r"(https?|ftp)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?";
  final imgSrc =
      new RegExp(urlPattern, caseSensitive: false).firstMatch(str).group(0);
  return imgSrc;
}
