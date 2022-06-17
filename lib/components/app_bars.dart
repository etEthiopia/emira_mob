import 'package:emira_all_in_one_mob/theme/app_theme.dart';
import 'package:flutter/material.dart';

AppBar cleanAppBar({required String title}) {
  return AppBar(
    centerTitle: true,
    backgroundColor: grey,
    elevation: 0.5,
    title: Text(
      title,
      style: TextStyle(color: white, fontFamily: defaultFont),
    ),
  );
}

AppBar flatAppBar({required String title}) {
  return AppBar(
    centerTitle: true,
    backgroundColor: grey,
    elevation: 0.0,
    title: Text(
      title,
      style: TextStyle(color: white, fontFamily: defaultFont),
    ),
  );
}
