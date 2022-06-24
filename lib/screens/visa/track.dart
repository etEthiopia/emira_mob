// ignore_for_file: avoid_unnecessary_containers

import 'package:emira_all_in_one_mob/components/app_bars.dart';
import 'package:emira_all_in_one_mob/components/progress.dart';
import 'package:emira_all_in_one_mob/services/app_localizations.dart';
import 'package:emira_all_in_one_mob/services/fb_service.dart';
import 'package:emira_all_in_one_mob/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

class TrackPage extends StatefulWidget {
  final bool title;

  const TrackPage({super.key, this.title = false});
  @override
  TrackPageState createState() => TrackPageState();
}

class TrackPageState extends State<TrackPage> {
  static TextEditingController controllerReference = TextEditingController();
  String currentAppState = "none";
  dynamic visaResponse = {};

  @override
  void dispose() {
    controllerReference.text = "";
    currentAppState = "none";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: background,
        appBar: widget.title ? cleanAppBar(title: "Track Emira") : null,
        body: SizedBox(
            height: size.height,
            child: Column(children: <Widget>[
              Container(
                padding: const EdgeInsets.only(
                    right: 20, left: 20, bottom: 30, top: 5),
                decoration: BoxDecoration(
                    color: grey,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      AppLocalizations.of(context)!
                          .translate("already_applied"),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: white, fontSize: 25),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: controllerReference,
                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!
                              .translate("enter_ref_number"),
                          fillColor: white,
                          filled: true,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                currentAppState = "loading";
                              });
                              //"EMV3406110248"
                              FBService.trackVisa(
                                      reference: controllerReference.text
                                          .toUpperCase())
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
                                //print("error");
                                setState(() {
                                  currentAppState = "error";
                                });
                              });
                            },
                            icon: const Icon(Icons.search),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  const BorderSide(color: Colors.transparent)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  const BorderSide(color: Colors.transparent)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5)),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                  child: currentAppState == "none"
                      ? Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              colorFilter: ColorFilter.mode(
                                  background.withOpacity(0.5),
                                  BlendMode.dstATop),
                              image: const AssetImage('assets/images/logo.png'),
                            ),
                          ),
                        )
                      : currentAppState == "loading"
                          ? Center(
                              child: loadingWidget(context),
                            )
                          : currentAppState == "error"
                              ? Center(
                                  child: errorWidget(
                                      context,
                                      AppLocalizations.of(context)!
                                          .translate("none_found")),
                                )
                              : currentAppState == "done"
                                  ? Column(children: [
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      Container(
                                          height: 150,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20.0)),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black
                                                        .withAlpha(100),
                                                    blurRadius: 10.0),
                                              ]),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0, vertical: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
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
                                                            color: blueblack,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          child: Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .translate(
                                                                    "weekend_contents"),
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    color: Colors
                                                                        .grey),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .translate("status"),
                                                      style: TextStyle(
                                                        color: grey,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    visaResponse["status"] == 1
                                                        ? Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .translate(
                                                                    "approved"),
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        : visaResponse[
                                                                    "status"] ==
                                                                2
                                                            ? Text(
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .translate(
                                                                        "rejected"),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )
                                                            : Text(
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .translate(
                                                                        "pending"),
                                                                style: TextStyle(
                                                                    color: grey,
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    visaResponse["status"] == 1 &&
                                                            visaResponse[
                                                                    "evisa"] !=
                                                                null
                                                        ? Link(
                                                            target: LinkTarget
                                                                .blank,
                                                            uri: Uri.parse(
                                                                visaResponse[
                                                                    "evisa"]),
                                                            builder: (context,
                                                                    followLink) =>
                                                                ElevatedButton(
                                                                    style: ButtonStyle(
                                                                        shape:
                                                                            MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0), side: BorderSide(color: grey))),
                                                                        backgroundColor: MaterialStateProperty.all(blueblack)),
                                                                    onPressed: followLink,
                                                                    child: Text(
                                                                      AppLocalizations.of(
                                                                              context)!
                                                                          .translate(
                                                                              "e_visa"),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              25),
                                                                    )))
                                                        : const SizedBox(
                                                            height: 50,
                                                          ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          )),
                                    ])
                                  : const SizedBox(
                                      height: 0,
                                    )),
            ])));
  }
}
