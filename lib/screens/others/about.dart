// ignore_for_file: avoid_unnecessary_containers

import 'package:emira_all_in_one_mob/components/app_bars.dart';
import 'package:flutter/material.dart';
import 'package:emira_all_in_one_mob/services/app_localizations.dart';

class AboutPage extends StatefulWidget {
  final bool title;

  const AboutPage({super.key, this.title = false});
  @override
  AboutPageState createState() => AboutPageState();
}

class AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.title ? cleanAppBar(title: "About Emira") : null,
        body: Container(
          child: const Center(
            child: Text("About Emira"),
          ),
        ));
  }
}
