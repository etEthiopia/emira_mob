// ignore_for_file: avoid_unnecessary_containers

import 'package:emira_all_in_one_mob/components/app_bars.dart';
import 'package:emira_all_in_one_mob/components/progress.dart';
import 'package:emira_all_in_one_mob/screens/visa/visa_detail.dart';
import 'package:emira_all_in_one_mob/services/const_data.dart';
import 'package:emira_all_in_one_mob/services/fb_service.dart';
import 'package:emira_all_in_one_mob/services/utils.dart';
import 'package:emira_all_in_one_mob/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:emira_all_in_one_mob/services/app_localizations.dart';
import "package:intl/intl.dart";
import 'package:url_launcher/link.dart';

class VisasPage extends StatefulWidget {
  final bool title;

  const VisasPage({super.key, this.title = false});
  @override
  VisasPageState createState() => VisasPageState();
}

class VisasPageState extends State<VisasPage> {
  ScrollController controller = ScrollController();
  static TextEditingController controllerReference =
      new TextEditingController();
  bool closeTopContainer = false;
  double topContainer = 0;
  bool track = false;
  String currentAppState = "none";
  dynamic visaResponse = {};
  String visaStatus = FBService.visaStatus;
  String currencyStatus = FBService.currencyStatus;

  List<Widget> itemsData = [];

  void getPostsData() {
    List<dynamic> responseList = FBService.visaTypes;
    List<Widget> listItems = [];
    print("currency");
    print(AppLocalizations.currency);
    print(AppLocalizations.currency == "");
    String currency = AppLocalizations.currency;
    //AppLocalizations.currency;
    if (FBService.rateTypes["USD"] == 0) {
      currency = "MGA";
      //AppLocalizations.currency = "MGA";
    } else if (currency == "") {
      currency = "USD";
      AppLocalizations.currency = "USD";
    }

    responseList.forEach((post) {
      double? ratee = 1;
      if (FBService.rateTypes[currency] != null) {
        ratee = FBService.rateTypes[currency];
      }
      // print("before");
      dynamic convertedPrice =
          (double.parse(post["price"].toString()) * ratee!).round();
      // print("after");
      String formatedPrice =
          "${formatAmount(convertedPrice, currency)} ${currency}";
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
            height: 150,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.all(const Radius.circular(20.0)),
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
    });
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
        print("error");
        setState(() {
          currencyStatus = "error";
        });
      });
    }).catchError((e) {
      print("error");
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
            backgroundColor: MaterialStateProperty.all(Color(0xFF4D5761))),
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
    controllerReference.text = "";
    currentAppState = "none";
    track = false;

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    print(FBService.visaStatus);
    print(FBService.currencyStatus);
    if (FBService.visaStatus == "done" && FBService.currencyStatus == "done") {
      getPostsData();
    }
    if (visaStatus == "done" && currencyStatus == "done") {
      getPostsData();
    } else {
      getVisaAndRateData();
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
                    ? FBService.visaTypes.length > 0 &&
                            FBService.rateTypes.length > 0
                        ? Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(
                                    right: 20, left: 20, bottom: 30, top: 5),
                                decoration: BoxDecoration(
                                    color: grey,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20))),
                                child: Column(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .translate("already_applied"),
                                      style:
                                          TextStyle(color: white, fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextField(
                                      controller: controllerReference,
                                      decoration: InputDecoration(
                                          hintText: AppLocalizations.of(
                                                  context)!
                                              .translate("enter_ref_number"),
                                          fillColor: white,
                                          filled: true,
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                track = true;
                                                currentAppState = "loading";
                                              });
                                              //"EMV3406110248"
                                              FBService.trackVisa(
                                                      reference:
                                                          controllerReference
                                                              .text)
                                                  .then((value) {
                                                if (value != null) {
                                                  setState(() {
                                                    currentAppState = "done";
                                                    visaResponse = value;
                                                  });
                                                } else {
                                                  setState(() {
                                                    currentAppState = "error";
                                                  });
                                                }
                                              }).catchError((e) {
                                                print("error");
                                                setState(() {
                                                  currentAppState = "error";
                                                });
                                              });
                                            },
                                            icon: Icon(Icons.search),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: BorderSide(
                                                  color: Colors.transparent)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: BorderSide(
                                                  color: Colors.transparent)),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5)),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              if (this.track)
                                SizedBox(
                                  height: 20,
                                )
                              else
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 25),
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
                                      SizedBox(
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
                                          SizedBox(
                                            width: 5,
                                          ),
                                          DropdownButton(
                                            value:
                                                AppLocalizations.currency == ""
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
                                                  enabled: FBService
                                                          .rateTypes[item] !=
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
                              this.track
                                  ? this.currentAppState == "loading"
                                      ? Center(
                                          child: loadingWidget(context),
                                        )
                                      : this.currentAppState == "error"
                                          ? Center(
                                              child: errorWidget(
                                                  context,
                                                  AppLocalizations.of(context)!
                                                      .translate("none_found")),
                                            )
                                          : this.currentAppState == "done"
                                              ? Container(
                                                  height: 150,
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              const Radius
                                                                      .circular(
                                                                  20.0)),
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.black
                                                                .withAlpha(100),
                                                            blurRadius: 10.0),
                                                      ]),
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 20.0,
                                                        vertical: 10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Text(
                                                                visaResponse[
                                                                    "visa_name"],
                                                                style: TextStyle(
                                                                    color:
                                                                        blueblack,
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  child: Text(
                                                                    AppLocalizations.of(
                                                                            context)!
                                                                        .translate(
                                                                            "weekend_contents"),
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        color: Colors
                                                                            .grey),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              AppLocalizations.of(
                                                                      context)!
                                                                  .translate(
                                                                      "status"),
                                                              style: TextStyle(
                                                                color: grey,
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                            visaResponse[
                                                                        "status"] ==
                                                                    1
                                                                ? Text(
                                                                    AppLocalizations.of(
                                                                            context)!
                                                                        .translate(
                                                                            "approved"),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .green,
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  )
                                                                : visaResponse[
                                                                            "status"] ==
                                                                        2
                                                                    ? Text(
                                                                        AppLocalizations.of(context)!
                                                                            .translate("rejected"),
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .red,
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      )
                                                                    : Text(
                                                                        AppLocalizations.of(context)!
                                                                            .translate("pending"),
                                                                        style: TextStyle(
                                                                            color:
                                                                                grey,
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            visaResponse["status"] ==
                                                                        1 &&
                                                                    visaResponse[
                                                                            "evisa"] !=
                                                                        null
                                                                ?
                                                                // Container(
                                                                //     child:
                                                                //         Material(
                                                                //     color: red,
                                                                //     borderRadius:
                                                                //         BorderRadius.circular(
                                                                //             15.0),
                                                                //     child:
                                                                //         Padding(
                                                                //       padding: EdgeInsets.symmetric(
                                                                //           horizontal:
                                                                //               10,
                                                                //           vertical:
                                                                //               0),
                                                                //       child: TextButton(
                                                                //           onPressed: () {
                                                                //             // this.setState(() {
                                                                //             //   currentAppState =
                                                                //             //       "loading";
                                                                //             // });
                                                                //             // // controllerReference.text
                                                                //             // FBService.downloadFile(
                                                                //             //         visaResponse[
                                                                //             //             "evisa"],
                                                                //             //         "evisa_${DateTime.now().second}",
                                                                //             //         context)
                                                                //             //     .then(
                                                                //             //         (value) => {
                                                                //             //               if (value)
                                                                //             //                 {
                                                                //             //                   this.setState(() {
                                                                //             //                     currentAppState = "done";
                                                                //             //                   })
                                                                //             //                 }
                                                                //             //               else
                                                                //             //                 {
                                                                //             //                   setState(() {
                                                                //             //                     currentAppState = "error";
                                                                //             //                   })
                                                                //             //                 }
                                                                //             //             })
                                                                //             //     .catchError(
                                                                //             //         (e) {
                                                                //             //   setState(() {
                                                                //             //     currentAppState =
                                                                //             //         "error";
                                                                //             //   });
                                                                //             // });
                                                                //           },
                                                                //           child: Row(
                                                                //             mainAxisAlignment:
                                                                //                 MainAxisAlignment.start,
                                                                //             children: [
                                                                //               Text(
                                                                //                 "E-Visa",
                                                                //                 style: TextStyle(fontSize: 18, color: white),
                                                                //               ),
                                                                //               Icon(
                                                                //                 Icons.download,
                                                                //                 size: 20,
                                                                //                 color: white,
                                                                //               ),
                                                                //             ],
                                                                //           )),
                                                                //     ),
                                                                //   ))
                                                                Link(
                                                                    target:
                                                                        LinkTarget
                                                                            .blank,
                                                                    uri: Uri.parse(
                                                                        visaResponse[
                                                                            "evisa"]),
                                                                    builder: (context,
                                                                            followLink) =>
                                                                        ElevatedButton(
                                                                            style:
                                                                                ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0), side: BorderSide(color: grey))), backgroundColor: MaterialStateProperty.all(blueblack)),
                                                                            child: Text(
                                                                              AppLocalizations.of(context)!.translate("e_visa"),
                                                                              style: TextStyle(fontSize: 25),
                                                                            ),
                                                                            onPressed: followLink))
                                                                : SizedBox(
                                                                    height: 50,
                                                                  ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ))
                                              : SizedBox(
                                                  height: 0,
                                                )
                                  : Expanded(
                                      child: ListView.builder(
                                          controller: controller,
                                          itemCount: itemsData.length,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            double scale = 1.0;
                                            if (topContainer > 0.5) {
                                              scale =
                                                  index + 0.5 - topContainer;
                                              if (scale < 0) {
                                                scale = 0;
                                              } else if (scale > 1) {
                                                scale = 1;
                                              }
                                            }
                                            return Opacity(
                                              opacity: scale,
                                              child: Transform(
                                                transform: Matrix4.identity()
                                                  ..scale(scale, scale),
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Align(
                                                    heightFactor: 0.7,
                                                    alignment:
                                                        Alignment.topCenter,
                                                    child: itemsData[index]),
                                              ),
                                            );
                                          })),
                              this.track
                                  ? this.currentAppState == "done" ||
                                          this.currentAppState == "error"
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30.0, vertical: 10),
                                          child: SizedBox(
                                              width: double.maxFinite,
                                              height: 60,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  this.setState(() {
                                                    track = false;
                                                  });
                                                },
                                                style: ButtonStyle(
                                                    shape: MaterialStateProperty.all<
                                                            RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                            side: BorderSide(
                                                                color: grey))),
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(grey)),
                                                child: Text(
                                                  AppLocalizations.of(context)!
                                                      .translate("go_back"),
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              )),
                                        )
                                      : const SizedBox(
                                          height: 20,
                                        )
                                  : const SizedBox(
                                      height: 20,
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
                          errorWidget(context,
                              AppLocalizations.of(context)!.translate("error")),
                          retryBtn()
                        ],
                      )),
      ),
    );
  }
}
