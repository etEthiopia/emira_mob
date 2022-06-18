// ignore_for_file: avoid_unnecessary_containers

import 'package:emira_all_in_one_mob/components/app_bars.dart';
import 'package:emira_all_in_one_mob/screens/visa/visa_form.dart';
import 'package:emira_all_in_one_mob/services/const_data.dart';
import 'package:emira_all_in_one_mob/services/fb_service.dart';
import 'package:emira_all_in_one_mob/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:emira_all_in_one_mob/services/app_localizations.dart';
import 'package:emira_all_in_one_mob/services/utils.dart';

class VisaDetailPage extends StatefulWidget {
  final bool title;
  final dynamic visa;

  const VisaDetailPage({super.key, this.title = false, required this.visa});
  @override
  VisaDetailPageState createState() => VisaDetailPageState();
}

class VisaDetailPageState extends State<VisaDetailPage> {
  @override
  Widget build(BuildContext context) {
    int convertedPrice = (widget.visa["price"].toDouble() *
            FBService.rateTypes[AppLocalizations.currency])
        .round();
    String formatedPrice =
        "${formatAmount(convertedPrice, AppLocalizations.currency)} ${AppLocalizations.currency}";
    if (AppLocalizations.currency == "MGA") {
      formatedPrice.replaceAll(",", ".");
    }

    final Orientation orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      backgroundColor: background3,
      appBar: widget.title ? cleanAppBar(title: "VisaDetail Emira") : null,
      body: SafeArea(
        child: Container(
          color: white,
          height: double.infinity,
          child: Stack(
            children: <Widget>[
              orientation == Orientation.portrait
                  ? Container(
                      padding: EdgeInsets.only(top: 20, bottom: 10),
                      height: 100,
                      decoration: BoxDecoration(color: background3),
                      child: Center(
                          child: Image.asset("assets/images/visa.png",
                              fit: BoxFit.cover)))
                  : SizedBox(
                      height: 0,
                    ),
              Container(
                height: double.maxFinite,
                color: background3,
                margin: orientation == Orientation.portrait
                    ? const EdgeInsets.only(top: 100)
                    : EdgeInsets.only(
                        top: 0,
                      ),
                child: Container(
                  decoration: BoxDecoration(
                      color: white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withAlpha(100),
                            blurRadius: 10.0),
                      ],
                      borderRadius: orientation == Orientation.portrait
                          ? BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))
                          : BorderRadius.all(Radius.zero)),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
                    child: Column(
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Center(
                                    child: orientation == Orientation.portrait
                                        ? Text(
                                            "${widget.visa['duration']}\n${widget.visa['entry']}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: blueblack,
                                                fontSize: 28.0,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : Row(
                                            children: [
                                              Container(
                                                  padding:
                                                      EdgeInsets.only(left: 40),
                                                  height: 70,
                                                  decoration: BoxDecoration(
                                                      color: white),
                                                  child: Center(
                                                      child: Image.asset(
                                                          "assets/images/${widget.visa['image']}",
                                                          fit: BoxFit.cover))),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "${widget.visa['duration']}\n${widget.visa['entry']}",
                                                style: TextStyle(
                                                    color: blueblack,
                                                    fontSize: 28.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          )),
                              ),
                              Container(
                                padding: const EdgeInsets.all(32.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "${widget.visa['note']}",
                                                style: TextStyle(
                                                    color: red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          formatedPrice,
                                          style: TextStyle(
                                              color: red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 30.0),
                                    // Text(
                                    //   "Description".toUpperCase(),
                                    //   style: TextStyle(
                                    //       fontWeight: FontWeight.w600,
                                    //       fontSize: 14.0),
                                    // ),
                                    // const SizedBox(height: 10.0),
                                    Text(
                                      "${widget.visa['description']}",
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 17.0),
                                    ),
                                    const SizedBox(height: 10.0),
                                    Container(
                                      width: double.infinity,
                                      child: Material(
                                        color: red,
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        child: TextButton(
                                          onPressed: () async {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      VisaFormPage(
                                                          visa: widget.visa)),
                                            );
                                          },
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .translate("apply"),
                                            style: TextStyle(
                                                color: white,
                                                fontFamily: defaultFont),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AppBar(
                  foregroundColor:
                      orientation == Orientation.portrait ? white : blueblack,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
              ),
              // Positioned(
              //   bottom: 0,
              //   left: 0,
              //   right: 0,
              //   child:
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}
