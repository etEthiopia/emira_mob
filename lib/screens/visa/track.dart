// ignore_for_file: avoid_unnecessary_containers

import 'package:emira_all_in_one_mob/components/app_bars.dart';
import 'package:flutter/material.dart';
import 'package:emira_all_in_one_mob/services/app_localizations.dart';

class TrackPage extends StatefulWidget {
  final bool title;

  const TrackPage({super.key, this.title = false});
  @override
  TrackPageState createState() => TrackPageState();
}

class TrackPageState extends State<TrackPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.title ? cleanAppBar(title: "Track Emira") : null,
        body: Container(
          child: const Center(
            child: Text("Track Emira"),
          ),
        ));
  }
}
