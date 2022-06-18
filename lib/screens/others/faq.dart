// ignore_for_file: avoid_unnecessary_containers

import 'package:emira_all_in_one_mob/components/app_bars.dart';
import 'package:emira_all_in_one_mob/components/progress.dart';
import 'package:emira_all_in_one_mob/services/const_data.dart';
import 'package:emira_all_in_one_mob/services/fb_service.dart';
import 'package:emira_all_in_one_mob/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:emira_all_in_one_mob/services/app_localizations.dart';

class FAQPage extends StatefulWidget {
  final bool title;

  const FAQPage({super.key, this.title = false});
  @override
  FAQPageState createState() => FAQPageState();
}

class FAQPageState extends State<FAQPage> {
  String faqStatus = "loading";
  Widget _buildPlayerModelList(dynamic qa) {
    return Card(
      child: ExpansionTile(
        textColor: red,
        iconColor: red,
        title: Text(
          qa["question"],
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
        ),
        children: <Widget>[
          ListTile(
            minVerticalPadding: 15,
            title: Text(
              qa["answer"],
              style: TextStyle(fontSize: 17),
            ),
          )
        ],
      ),
    );
  }

  Widget retryBtn() {
    return TextButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            )),
            backgroundColor: MaterialStateProperty.all(Color(0xFF4D5761))),
        onPressed: () {
          getFAQData();
        },
        child: Icon(
          Icons.refresh,
          size: 30,
          color: white,
        ));
  }

  void getFAQData() {
    setState(() {
      faqStatus = "loading";
    });
    FBService.fetchFAQs().then((value) {
      setState(() {
        faqStatus = "done";
      });
    }).catchError((e) {
      print("error");
      setState(() {
        faqStatus = "error";
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getFAQData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: widget.title ? cleanAppBar(title: "FAQ") : null,
          body: faqStatus == "loading"
              ? loadingWidget(context)
              : faqStatus == "done"
                  ? FBService.faqList.length > 0
                      ? Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/images/logo.png'),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                itemCount: FBService.faqList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return _buildPlayerModelList(
                                      FBService.faqList[index]);
                                },
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
}
