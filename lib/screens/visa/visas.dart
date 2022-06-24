// ignore_for_file: avoid_unnecessary_containers, unnecessary_new, sized_box_for_whitespace, unnecessary_this

import 'package:emira_all_in_one_mob/components/app_bars.dart';
import 'package:emira_all_in_one_mob/components/progress.dart';
import 'package:emira_all_in_one_mob/screens/visa/visa_detail.dart';
import 'package:emira_all_in_one_mob/services/fb_service.dart';
import 'package:emira_all_in_one_mob/services/utils.dart';
import 'package:emira_all_in_one_mob/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:emira_all_in_one_mob/services/app_localizations.dart';

class VisasPage extends StatefulWidget {
  final bool title;

  const VisasPage({super.key, this.title = false});
  @override
  VisasPageState createState() => VisasPageState();
}

class VisasPageState extends State<VisasPage> {
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;
  String currentAppState = "none";
  String visaStatus = FBService.visaStatus;
  String currencyStatus = FBService.currencyStatus;

  List<Widget> itemsData = [];

  void getPostsData() {
    List<dynamic> responseList = FBService.visaTypes;
    List<Widget> listItems = [];
    //print("currency");
    //print(AppLocalizations.currency);
    //print(AppLocalizations.currency == "");
    String currency = AppLocalizations.currency;
    //AppLocalizations.currency;
    if (FBService.rateTypes["USD"] == 0) {
      currency = "MGA";
      //AppLocalizations.currency = "MGA";
    } else if (currency == "") {
      currency = "MGA";
      AppLocalizations.currency = "MGA";
    }

    for (var post in responseList) {
      double? ratee = 1;
      if (FBService.rateTypes[currency] != null) {
        ratee = FBService.rateTypes[currency];
      }
      // //print("before");
      dynamic convertedPrice =
          (double.parse(post["price"].toString()) * ratee!).round();
      // //print("after");
      String formatedPrice =
          "${formatAmount(convertedPrice, currency)} $currency";
      if (currency == "MGA") {
        formatedPrice.replaceAll(",", ".");
      }
      listItems.add(InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VisaDetailPage(
                      visa: post,
                    )),
          );
        },
        child: Container(
            height: 130,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withAlpha(100), blurRadius: 10.0),
                ]),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image.asset(
                    "assets/images/visa.png",
                    height: double.infinity,
                    width: 75,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        post["duration"],
                        style: TextStyle(
                            color: blueblack,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        post["entry"],
                        style: TextStyle(
                            color: blueblack,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        post["note"],
                        style:
                            const TextStyle(fontSize: 17, color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        formatedPrice,
                        style: TextStyle(
                            fontSize: 20,
                            color: red,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ],
              ),
            )),
      ));
    }
    setState(() {
      itemsData = listItems;
    });
  }

  void getVisaAndRateData() {
    setState(() {
      visaStatus = "loading";
      currencyStatus = "loading";
    });
    FBService.fetchVisas().then((value) {
      setState(() {
        visaStatus = "done";
      });

      FBService.fetchRate().then((value) {
        setState(() {
          currencyStatus = "done";
        });
        getPostsData();
      }).catchError((e) {
        //print("error");
        setState(() {
          currencyStatus = "error";
        });
      });
    }).catchError((e) {
      //print("error");
      setState(() {
        visaStatus = "error";
      });
    });
  }

  Widget retryBtn() {
    return TextButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            )),
            backgroundColor:
                MaterialStateProperty.all(const Color(0xFF4D5761))),
        onPressed: () {
          getVisaAndRateData();
        },
        child: Icon(
          Icons.refresh,
          size: 30,
          color: white,
        ));
  }

  @override
  void dispose() {
    currentAppState = "none";

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //print(FBService.visaStatus);
    //print(FBService.currencyStatus);
    if (FBService.visaStatus == "done" && FBService.currencyStatus == "done") {
      getPostsData();
    }
    if (visaStatus == "done" && currencyStatus == "done") {
      getPostsData();
    } else {
      getVisaAndRateData();
    }

    if (FBService.apiStatus != "done") {
      FBService.fetchAPI();
    }

    //getVisaAndRateData();
    controller.addListener(() {
      double value = controller.offset / 119;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: background,
        appBar: widget.title ? flatAppBar(title: "Visas") : null,
        body: Container(
            height: size.height,
            child: visaStatus == "loading" || currencyStatus == "loading"
                ? loadingWidget(context)
                : visaStatus == "done" && currencyStatus == "done"
                    ? FBService.visaTypes.isNotEmpty &&
                            FBService.rateTypes.isNotEmpty
                        ? Column(
                            children: <Widget>[
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .translate("select_visa_type"),
                                        style: TextStyle(
                                            color: black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .translate("currency"),
                                          style: TextStyle(
                                              color: blueblack, fontSize: 15),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        DropdownButton(
                                          value: AppLocalizations.currency == ""
                                              ? "MGA"
                                              : AppLocalizations.currency,
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down),
                                          style: TextStyle(
                                              color: blueblack, //<-- SEE HERE
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                          items: FBService.rateTypes.keys
                                              .map((String item) {
                                            return DropdownMenuItem(
                                                enabled:
                                                    FBService.rateTypes[item] !=
                                                        0,
                                                value: item,
                                                child: Text(item));
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            if (newValue is String) {
                                              AppLocalizations.currency =
                                                  newValue;
                                              // setState(() {
                                              //   AppLocalizations.currency = newValue;
                                              // });
                                              AppLocalizations.storecurrency(
                                                  newValue);
                                              getPostsData();
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                child: ListView.builder(
                                    controller: controller,
                                    itemCount: itemsData.length,
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      double scale = 1.0;
                                      // if (topContainer > 0.5) {
                                      //   scale =
                                      //       index + 0.5 - topContainer;
                                      //   if (scale < 0) {
                                      //     scale = 0;
                                      //   } else if (scale > 1) {
                                      //     scale = 1;
                                      //   }
                                      // }
                                      return Opacity(
                                        opacity: scale,
                                        child: Transform(
                                          transform: Matrix4.identity()
                                            ..scale(scale, scale),
                                          alignment: Alignment.bottomCenter,
                                          child: Align(
                                              heightFactor: 0.7,
                                              alignment: Alignment.topCenter,
                                              child: itemsData[index]),
                                        ),
                                      );
                                    }),
                              )),
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
                          errorWidget(context,
                              AppLocalizations.of(context)!.translate("error")),
                          retryBtn()
                        ],
                      )),
      ),
    );
  }
}
