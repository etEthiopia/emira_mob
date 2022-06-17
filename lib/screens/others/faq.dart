// ignore_for_file: avoid_unnecessary_containers

import 'package:emira_all_in_one_mob/components/app_bars.dart';
import 'package:emira_all_in_one_mob/services/const_data.dart';
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: widget.title ? cleanAppBar(title: "FAQ") : null,
        body: Column(
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
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: FAQ_LIST.length,
                itemBuilder: (BuildContext context, int index) {
                  return _buildPlayerModelList(FAQ_LIST[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
