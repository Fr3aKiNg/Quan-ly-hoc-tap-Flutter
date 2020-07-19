import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Educare/application/color_app.dart';
import 'package:Educare/presentation/atom/page_indicator.dart';
import 'package:Educare/presentation/atom/screen_data.dart';

import 'on_board_detail.dart';


class OnboardingMe extends StatefulWidget {
  /// Number of Pages for the screens
  @required
  int numOfPage;

  List<String> ctaText = [];
  List<OnBoardDetail> dataScreen;
  List<OnBoardDetail> data = [
    OnBoardDetail(
        "assets/on_board_1.png",
        "Lorem ipsum dolor sit amet, consectetur adipiscing",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut morbi at odio ut."),
    OnBoardDetail(
        "assets/on_board_2.png",
        "Lorem ipsum dolor sit amet, consectetur adipiscing",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut morbi at odio ut."),
    OnBoardDetail(
        "assets/on_board_3.png",
        "Lorem ipsum dolor sit amet, consectetur adipiscing",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut morbi at odio ut."),
    OnBoardDetail(
        "assets/on_board_4.png",
        "Lorem ipsum dolor sit amet, consectetur adipiscing",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut morbi at odio ut."),
    OnBoardDetail(
        "assets/login.png",
        "Lorem ipsum dolor sit amet, consectetur adipiscing",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut morbi at odio ut.")
  ];

  bool isPageIndicatorCircle = true;

  @required
  String homeRoute;

  OnboardingMe({
    numOfPage = 5,
    ctaText = const ['Skip', 'Get Started'],
    data,
    isPageIndicatorCircle = true,
    homeRoute = '/',
  }) {
    this.numOfPage = numOfPage;
    this.ctaText = ctaText;
    this.isPageIndicatorCircle = isPageIndicatorCircle;
    this.homeRoute = homeRoute;
    this.dataScreen = data;
  }

  @override
  _OnboardingMeState createState() => _OnboardingMeState();
}

class _OnboardingMeState extends State<OnboardingMe> {
  /// PageController will control the view of screens
  PageController pageController = PageController(initialPage: 0);

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width / 100;
    double h = MediaQuery.of(context).size.height / 100;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
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


                Padding(padding: EdgeInsets.fromLTRB(w*35, h*10, 0, h*20),child:Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: pageIndicator(widget.numOfPage, currentPage,
                            widget.isPageIndicatorCircle),
                      ),
                      SizedBox(
                          width: w * 15),
                      GestureDetector(
                              child: Text("Bỏ qua",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white)))
                    ])),
            Container(
              height: h * 100,
              child: PageView(
                physics: ClampingScrollPhysics(),
                controller: pageController,
                onPageChanged: (int page) {
                  /// Setting current page for page indicator
                  setState(() {
                    currentPage = page;
                  });
                },

                /// Screen Data
                children: screenData(widget.numOfPage, widget.data),
              ),
            ),
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  /// Page Indicator
//                  children: pageIndicator(widget.numOfPage, currentPage,
//                      widget.isPageIndicatorCircle),
//                ),
          ],
        ),
      ),

      /// Will show Main Call to action on the last page
//      bottomSheet: currentPage == widget.numOfPage - 1
//          ? callToAction(text: widget.ctaText[1], homeRoute: widget.homeRoute, context: context)
//          : Text(''),
    );
  }
}
