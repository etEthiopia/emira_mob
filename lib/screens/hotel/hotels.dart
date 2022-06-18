// ignore_for_file: avoid_unnecessary_containers

import 'package:emira_all_in_one_mob/components/app_bars.dart';
import 'package:emira_all_in_one_mob/components/progress.dart';
import 'package:emira_all_in_one_mob/main.dart';
import 'package:emira_all_in_one_mob/screens/hotel/hotel_form.dart';
import 'package:emira_all_in_one_mob/services/const_data.dart';
import 'package:emira_all_in_one_mob/services/fb_service.dart';
import 'package:emira_all_in_one_mob/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:emira_all_in_one_mob/services/app_localizations.dart';

class HotelsPage extends StatefulWidget {
  final bool title;

  const HotelsPage({super.key, this.title = false});
  @override
  HotelsPageState createState() => HotelsPageState();
}

class HotelsPageState extends State<HotelsPage> {
  ScrollController controller = ScrollController();
  List<Widget> itemsData = [];
  List<Widget> hItemsData = [];

  String hotelStatus = FBService.hotelStatus;

  void getPostsData() {
    List<dynamic> responseList = FBService.hotelTypes;
    List<Widget> listItems = [];
    List<Widget> hIistItems = [];

    responseList.forEach((post) {
      listItems.add(hotelCard(post));
      hIistItems.add(hHotelCard(post));
    });
    setState(() {
      itemsData = listItems;
      hItemsData = hIistItems;
    });
  }

  void getHotelData() {
    setState(() {
      hotelStatus = "loading";
    });
    FBService.fetchHotels().then((value) {
      setState(() {
        hotelStatus = "done";
      });
      getPostsData();
    }).catchError((e) {
      print("error");
      setState(() {
        hotelStatus = "error";
      });
    });
  }

  Widget retryBtn() {
    return TextButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            )),
            backgroundColor: MaterialStateProperty.all(Color(0xFF4D5761))),
        onPressed: () {
          getHotelData();
        },
        child: Icon(
          Icons.refresh,
          size: 30,
          color: white,
        ));
  }

  @override
  void initState() {
    super.initState();
    print(FBService.hotelStatus);
    if (FBService.hotelStatus == "done") {
      getPostsData();
    }
    if (hotelStatus == "done") {
      getPostsData();
    } else {
      getHotelData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.title ? cleanAppBar(title: "Hotels") : null,
      body: Container(
          height: size.height,
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: hotelStatus == "loading"
              ? loadingWidget(context)
              : hotelStatus == "done"
                  ? FBService.hotelTypes.length > 0
                      ? Column(
                          children: <Widget>[
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              AppLocalizations.of(context)!
                                  .translate("book_what_suits"),
                              style: TextStyle(
                                  color: black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            orientation == Orientation.portrait
                                ? Expanded(
                                    child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        controller: controller,
                                        itemCount: FBService.hotelTypes.length,
                                        itemBuilder: (context, index) {
                                          return itemsData[index];

                                          // return Opacity(
                                          //   opacity: scale,
                                          //   child: Transform(
                                          //     transform: Matrix4.identity()..scale(scale, scale),
                                          //     alignment: Alignment.bottomCenter,
                                          //     child: Align(
                                          //         heightFactor: 0.7,
                                          //         alignment: Alignment.topCenter,
                                          //         child: itemsData[index]),
                                          //   ),
                                          // );
                                        }))
                                : Expanded(
                                    // padding: EdgeInsets.symmetric(
                                    //     horizontal: 16.0, vertical: 24.0),
                                    // height: MediaQuery.of(context).size.height * 0.35,
                                    child: Container(
                                      padding: EdgeInsets.only(bottom: 5),
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          controller: controller,
                                          itemCount:
                                              FBService.hotelTypes.length,
                                          itemBuilder: (context, index) {
                                            return hItemsData[index];
                                          }),
                                    ),
                                  ),
                          ],
                        )
                      : Column(
                          children: [
                            errorWidget(
                                context,
                                AppLocalizations.of(context)!
                                    .translate("none_found")),
                            retryBtn()
                          ],
                        )
                  : Column(
                      children: [
                        errorWidget(
                            context,
                            AppLocalizations.of(context)!
                                .translate("none_found")),
                        retryBtn()
                      ],
                    )),
    );
  }

  Widget hotelCard(dynamic hotel) {
    return Card(
      margin: EdgeInsets.only(bottom: 22.0),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 10.0,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HotelFormPage(
                      hotel: hotel,
                    )),
          );
        },
        child: Container(
          // decoration: BoxDecoration(
          //     image: DecorationImage(
          //   image: NetworkImage(hotel["image"]),
          //   fit: BoxFit.cover,
          //   scale: 2.0,
          // )),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    blueblack,
                    lightgrey,
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
              color: black,
              image: DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.9), BlendMode.dstATop),
                fit: BoxFit.cover,
                image: NetworkImage(hotel["image"]),
              )),
          height: 300.0,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.0),
                      decoration:
                          BoxDecoration(color: blueblack.withOpacity(0.5)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //this loop will allow us to add as many star as the rating
                          for (var i = 0; i < hotel["star"]; i++)
                            Icon(
                              Icons.star,
                              color: Color.fromARGB(255, 255, 195, 66),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(12.0),
                      decoration:
                          BoxDecoration(color: blueblack.withOpacity(0.5)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //this loop will allow us to add as many star as the rating
                          Text(
                            hotel["price"],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(12, 6, 12, 12),
                          width: double.infinity,
                          decoration:
                              BoxDecoration(color: blueblack.withOpacity(0.5)),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  hotel["title"],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(
                                  height: 3.0,
                                ),
                                Text(
                                  hotel["description"],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ]),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget hHotelCard(dynamic hotel) {
    return Card(
      margin: EdgeInsets.only(right: 22.0),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 10.0,
      child: Container(
        width: 400,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HotelFormPage(
                        hotel: hotel,
                      )),
            );
          },
          child: Container(
            // foregroundDecoration: BoxDecoration(color: Colors.black26),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      blueblack,
                      lightgrey,
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
                image: DecorationImage(
                  colorFilter: new ColorFilter.mode(
                      Colors.black.withOpacity(0.7), BlendMode.dstATop),
                  fit: BoxFit.cover,
                  image: NetworkImage(hotel["image"]),
                )),
            //     image: DecorationImage(
            //   image: NetworkImage(hotel["image"]),
            //   fit: BoxFit.cover,
            //   scale: 2.0,
            // )

            // width: 100.0,
            // height: 100,
            // height: 300.0,
            // width: double.infinity,
            child: Padding(
              padding: EdgeInsets.all(0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.0),
                        // decoration:
                        //     BoxDecoration(color: blueblack.withOpacity(0.5)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //this loop will allow us to add as many star as the rating
                            for (var i = 0; i < hotel["star"]; i++)
                              Icon(
                                Icons.star,
                                color: Color.fromARGB(255, 255, 195, 66),
                              ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(12.0),
                        // decoration:
                        //     BoxDecoration(color: blueblack.withOpacity(0.5)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //this loop will allow us to add as many star as the rating
                            Text(
                              hotel["price"],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(12, 6, 12, 12),
                            width: double.infinity,
                            // decoration:
                            //     BoxDecoration(color: blueblack.withOpacity(0.5)),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    hotel["title"],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3.0,
                                  ),
                                  Text(
                                    hotel["description"],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ]),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// Material(
//               elevation: 10.0,
//               borderRadius: BorderRadius.circular(30.0),
//               shadowColor: Color(0x55434343),
//               child: TextField(
//                 textAlign: TextAlign.start,
//                 textAlignVertical: TextAlignVertical.center,
//                 decoration: InputDecoration(
//                   hintText: "Search for Hotel, Flight...",
//                   prefixIcon: Icon(
//                     Icons.search,
//                     color: Colors.black54,
//                   ),
//                   border: InputBorder.none,
//                 ),
//               ),
//             ),

