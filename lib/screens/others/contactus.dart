// ignore_for_file: avoid_unnecessary_containers

import 'package:emira_all_in_one_mob/components/app_bars.dart';
import 'package:emira_all_in_one_mob/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:emira_all_in_one_mob/services/app_localizations.dart';

class ContactUsPage extends StatefulWidget {
  final bool title;

  const ContactUsPage({super.key, this.title = false});
  @override
  ContactUsPageState createState() => ContactUsPageState();
}

class ContactUsPageState extends State<ContactUsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.title ? cleanAppBar(title: "Contact") : null,
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          CurvedListItem(
            title: '+971 58 870 5940',
            color: lightgrey,
            nextColor: grey,
            textColor: blueblack,
            icon: Icon(
              Icons.phone,
              size: 30,
              color: blueblack,
            ),
          ),
          CurvedListItem(
            title: 'contact@emiravisa.com',
            color: grey,
            nextColor: background3,
            icon: Icon(
              Icons.email,
              size: 30,
              color: white,
            ),
          ),
          CurvedListItem(
            title: 'Dubai Business Bay Tower',
            color: background3,
            textColor: blueblack,
            nextColor: grey,
            icon: Icon(
              Icons.location_on,
              size: 30,
              color: blueblack,
            ),
          ),
          CurvedListItem(
            title: '+971588705940',
            color: grey,
            nextColor: background2,
            icon: Icon(
              Icons.whatsapp,
              color: white,
              size: 30,
            ),
          ),
          CurvedListItem(
            title: 'EMIRAVISA',
            color: background2,
            textColor: blueblack,
            icon: Icon(
              Icons.facebook,
              size: 30,
              color: blueblack,
            ),
          ),
        ],
      ),
    );
  }
}

class CurvedListItem extends StatelessWidget {
  const CurvedListItem({
    required this.title,
    required this.color,
    required this.icon,
    // required this.people,
    // required this.color,
    this.textColor = Colors.white,
    this.nextColor = Colors.white,
  });

  final String title;
  final Color color;
  final Color textColor;
  // final String people;
  final Icon icon;
  final Color nextColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: nextColor,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(40.0),
          ),
        ),
        padding: const EdgeInsets.only(
          left: 32,
          top: 40.0,
          bottom: 30,
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              icon,
              const SizedBox(
                height: 2,
              ),
              Text(
                title,
                style: TextStyle(
                    color: textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              Row(),
            ]),
      ),
    );
  }
}
