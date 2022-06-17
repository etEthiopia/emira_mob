// ignore_for_file: avoid_unnecessary_containers

import 'package:emira_all_in_one_mob/components/app_bars.dart';
import 'package:emira_all_in_one_mob/screens/hotel/hotels.dart';
import 'package:emira_all_in_one_mob/screens/visa/visas.dart';
import 'package:emira_all_in_one_mob/services/const_data.dart';
import 'package:emira_all_in_one_mob/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:emira_all_in_one_mob/services/app_localizations.dart';
import 'package:getwidget/getwidget.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomePage extends StatefulWidget {
  final bool title;
  int page;
  HomePage({super.key, this.title = false, this.page = 0});
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    //print(widget.page);
    setState(() {
      page = widget.page;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("w:" + widget.page.toString());
    print("c:" + page.toString());
    if (page != widget.page) {
      setState(() {
        page = widget.page;
      });
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: white,
        appBar: widget.title ? cleanAppBar(title: "Emira E-Visa") : null,
        body: page == 0
            ? SingleChildScrollView(
                child: Stack(children: [
                Container(
                    child: Column(
                  children: [
                    GFCarousel(
                        viewportFraction: 1.0,
                        autoPlay: true,
                        hasPagination: true,
                        items: IMAGES_LIST.map((url) {
                          int ix = IMAGES_LIST.indexOf(url);
                          return Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: grey,
                                  image: DecorationImage(
                                      image: AssetImage(url),
                                      fit: BoxFit.cover)),
                              // margin: EdgeInsets.all(8.0),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      WELCOME_LIST[ix],
                                      style: TextStyle(
                                          shadows: <Shadow>[
                                            Shadow(
                                              offset: Offset(2.0, 2.0),
                                              blurRadius: 3.0,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                            Shadow(
                                              offset: Offset(2.0, 2.0),
                                              blurRadius: 8.0,
                                              color: Color.fromARGB(
                                                  124, 107, 107, 107),
                                            ),
                                          ],
                                          fontFamily: defaultFont,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                          color: white),
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate("since_2002"),
                                      style: TextStyle(
                                          fontFamily: defaultFont,
                                          fontSize: 15,
                                          color: white),
                                    )
                                  ],
                                ),
                              )
                              // ClipRRect(
                              //   child: Image.network(url, fit: BoxFit.cover, width: 1000),
                              // ),
                              );
                        }).toList()),
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.all(20.0),
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          gradient: LinearGradient(
                              colors: [
                                grey,
                                lightgrey,
                              ],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                        ),
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.translate("about"),
                              style: TextStyle(
                                  fontFamily: defaultFont,
                                  fontWeight: FontWeight.bold,
                                  color: white,
                                  fontSize: 30),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              AppLocalizations.of(context)!
                                  .translate("about_content"),
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontFamily: defaultFont,
                                  color: white,
                                  fontSize: 17),
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        AppLocalizations.of(context)!.translate("steps_header"),
                        style: TextStyle(
                            fontFamily: defaultFont,
                            color: red,
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    TimelineTile(
                      alignment: TimelineAlign.manual,
                      lineXY: 0.1,
                      isFirst: true,
                      indicatorStyle: IndicatorStyle(
                        width: 20,
                        color: red,
                      ),
                      beforeLineStyle: LineStyle(
                        color: lightgrey,
                        thickness: 3,
                      ),
                      endChild: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            AppLocalizations.of(context)!
                                .translate("step_1_header"),
                            style: TextStyle(
                                color: blueblack,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontFamily: defaultFont)),
                      ),
                    ),
                    TimelineDivider(
                      begin: 0.1,
                      end: 0.9,
                      thickness: 3,
                      color: lightgrey,
                    ),
                    TimelineTile(
                      alignment: TimelineAlign.manual,
                      lineXY: 0.9,
                      beforeLineStyle: LineStyle(
                        color: lightgrey,
                        thickness: 3,
                      ),
                      afterLineStyle: LineStyle(
                        color: lightgrey,
                        thickness: 3,
                      ),
                      indicatorStyle: IndicatorStyle(
                        width: 20,
                        color: red,
                      ),
                      startChild: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            AppLocalizations.of(context)!
                                .translate("step_2_header"),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: blueblack,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontFamily: defaultFont)),
                      ),
                    ),
                    TimelineDivider(
                      begin: 0.1,
                      end: 0.9,
                      thickness: 3,
                      color: lightgrey,
                    ),
                    TimelineTile(
                      alignment: TimelineAlign.manual,
                      lineXY: 0.1,
                      isLast: true,
                      beforeLineStyle: LineStyle(
                        color: lightgrey,
                        thickness: 3,
                      ),
                      indicatorStyle: IndicatorStyle(
                        width: 20,
                        color: red,
                      ),
                      endChild: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            AppLocalizations.of(context)!
                                .translate("step_3_header"),
                            style: TextStyle(
                                color: blueblack,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontFamily: defaultFont)),
                      ),
                    ),
                  ],
                ))
              ]))
            : page == 1
                ? VisasPage()
                : HotelsPage(),
        bottomNavigationBar: CurvedNavigationBar(
          index: page,
          key: _bottomNavigationKey,
          backgroundColor: white,
          color: background2,
          height: 60,
          items: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.home, size: 30),
                  Text(
                    AppLocalizations.of(context)!.translate("home"),
                    style: TextStyle(
                        fontFamily: defaultFont,
                        fontWeight: FontWeight.bold,
                        fontSize: 10),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.airplane_ticket, size: 30),
                  Text(
                    AppLocalizations.of(context)!.translate("visa"),
                    style: TextStyle(
                        fontFamily: defaultFont,
                        fontWeight: FontWeight.bold,
                        fontSize: 10),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.hotel, size: 30),
                  Text(
                    AppLocalizations.of(context)!.translate("hotel"),
                    style: TextStyle(
                        fontFamily: defaultFont,
                        fontWeight: FontWeight.bold,
                        fontSize: 10),
                  )
                ],
              ),
            ),
          ],
          onTap: (index) {
            //print(index);
            widget.page = index;
            setState(() {
              page = index;
            });
          },
        ),
      ),
    );
  }
}
