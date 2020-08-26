import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scheduleapp/presentation/facebook_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scheduleapp/application/color_app.dart';
import 'package:scheduleapp/presentation/atom/page_indicator.dart';
import 'package:scheduleapp/presentation/atom/screen_data.dart';
import 'package:scheduleapp/presentation/page/home_screen.dart';

import 'on_board_detail.dart';

class OnboardingMe extends StatefulWidget {
  @required
  int numOfPage;
  List<OnBoardDetail> dataScreen;


  bool isPageIndicatorCircle = true;

  @required
  String homeRoute;

  OnboardingMe({
    numOfPage = 5,
    data,
    isPageIndicatorCircle = true,
    homeRoute = '/',
  }) {
    this.numOfPage = numOfPage;
    this.isPageIndicatorCircle = isPageIndicatorCircle;
    this.homeRoute = homeRoute;
    this.dataScreen = data;
  }

  @override
  _OnboardingMeState createState() => _OnboardingMeState();
}

class _OnboardingMeState extends State<OnboardingMe> {
  PageController pageController = PageController(initialPage: 0);

  int currentPage = 0;
  bool skip = true;

  startTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('first_time');

    var _duration = new Duration(seconds: 3);

    if (firstTime != null && !firstTime) {// Not first time
      return new Timer(_duration, navigationPageHome);
    } else {// First time
      prefs.setBool('first_time', false);
      return new Timer(_duration, navigationPageWel);
    }
  }

  void navigationPageHome() {
    Navigator.of(context).pushReplacementNamed('home');
  }

  void navigationPageWel() {

    Navigator.of(context).pushReplacementNamed('on_board');
  }

  @override
  Widget build(BuildContext context) {
    List<OnBoardDetail> data = [
      OnBoardDetail(skip: true,img:
      "assets/on_board_1.png",
          title:"Giúp bạn quản lý học tập hiệu quả",
          des:"Ứng dụng cho phép đặt mục tiêu học tập, lưu và thống kê điểm số theo học kì, môn học do chính bạn cài đặt. Hỗ trợ theo dõi lịch học và ghi chú."),
      OnBoardDetail(skip: true,img:
      "assets/on_board_2.png",
          title:"Hoàn toàn miễn phí, không quảng cáo",
          des:"Bạn không phải trả bất kì loại phí nào và sẽ không bị làm phiền do quảng cáo gây xao nhãng và tốn thời gian."),
      OnBoardDetail(skip: true,img:
      "assets/on_board_3.png",
          title:"Đồng bộ hóa dữ liệu qua nhiều thiết bị",
          des:"Hỗ trợ đồng bộ hóa dữ liệu giúp bạn tiện theo dõi trên cái thiết bị sử dụng khác nhau. Hỗ trợ cả hệ điều hành Android và IOS."),
      OnBoardDetail(skip: true,img:
      "assets/on_board_4.png",
          title:"Tùy chỉnh theo nhu cầu cá nhân",
          des:"Cài đặt mọi thứ theo mục tiêu học tập của chính bạn. Bắt đầu cùng chúng tôi !"),
      OnBoardDetail(skip: false,img:
      "assets/login.png",
          title: "",
          des: "",
          loginFacebook: LoginFacebook(),
          loginGoogle: LoginGoogle()),
    ];
    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;
    return Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                  width: w * 100,
                  height: h * 45,
                  decoration: BoxDecoration(
                    color: ColorApp.backgroundColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.elliptical(160, 50),
                        bottomRight: Radius.elliptical(160, 50)),
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(w * 38, h * 10, 0, h * 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: pageIndicator(widget.numOfPage, currentPage,
                            widget.isPageIndicatorCircle),
                      ),
                      SizedBox(width: w * 15),
                    ],
                  )),

              Container(
                height: h * 100,
                child: PageView(
                  physics: ClampingScrollPhysics(),
                  controller: pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      currentPage = page;
                    });
                  },
                  children: screenData(widget.numOfPage, data),
                ),
              ),
//
            ],
          ),
        ));
  }
}