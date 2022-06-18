// ignore_for_file: avoid_unnecessary_containers

import 'package:emira_all_in_one_mob/components/app_bars.dart';
import 'package:emira_all_in_one_mob/main.dart';
import 'package:emira_all_in_one_mob/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:emira_all_in_one_mob/services/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  final bool title;

  const SettingsPage({super.key, this.title = false});
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  String lang = "en_US";

  @override
  void initState() {
    AppLocalizations.getCurrentLang().then((value) => setState(() {
          lang = value.toString();
        }));
    super.initState();
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.translate("restart")),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  AppLocalizations.of(context)!.translate("restart_content"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.translate("ok")),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    changeLang(String lang, String country) async {
      if (this.lang != lang + "_" + country) {
        Locale locale = Locale(lang, country);
        await AppLocalizations.storelang(locale);
        _showMyDialog();
      }
    }

    Widget _logoSection() {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/logo.png'),
          ),
        ),
      );
    }

    Widget _goBackBtn() {
      return SizedBox(
        width: double.infinity,
        child: Material(
          color: grey,
          borderRadius: BorderRadius.circular(15.0),
          child: TextButton(
            onPressed: () async {
              Navigator.of(context).pushReplacement(MaterialPageRoute<MainPage>(
                builder: (BuildContext context) {
                  return const MainPage();
                },
              ));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_back,
                  color: white,
                ),
                Text(
                  AppLocalizations.of(context)!.translate("go_back"),
                  style: TextStyle(color: white, fontFamily: defaultFont),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget _divider() {
      return Divider(color: lightgrey);
    }

    Widget _chooseLang() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10, left: 5, bottom: 5),
            margin: EdgeInsets.only(left: 20.0),
            child: Text(
              AppLocalizations.of(context)!.translate("choose_language"),
              style: TextStyle(
                  color: black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: defaultFont),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: this.lang != null
                ? (this.lang == "en_US" ? double.infinity : size.width * 0.75)
                : size.width * 0.75,
            margin: EdgeInsets.all(20.0),
            padding: EdgeInsets.symmetric(
                horizontal: this.lang == "en_US" ? 30 : 30,
                vertical: this.lang == "en_US" ? 22 : 20),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withAlpha(100), blurRadius: 10.0),
                ],
                borderRadius: BorderRadius.all(Radius.circular(15)),
                gradient: this.lang != null
                    ? (this.lang == "en_US"
                        ? LinearGradient(
                            colors: [
                              blueblack,
                              lightgrey,
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp)
                        : LinearGradient(
                            colors: [
                              lightgrey,
                              background2,
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp))
                    : LinearGradient(
                        colors: [
                          lightgrey,
                          background3,
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp)),
            child: SizedBox(
              width: this.lang != null
                  ? (this.lang == "en_US" ? double.infinity : size.width * 0.75)
                  : size.width * 0.75,
              child: Material(
                color: Colors.transparent,
                child: TextButton(
                  onPressed: () {
                    changeLang("en", "US");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          height: this.lang != null
                              ? (this.lang == "en_US" ? 30 : 25)
                              : 25,
                          margin: const EdgeInsets.only(right: 5),
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/images/us.png",
                          )),
                      SizedBox(width: 10),
                      Text(
                        "English",
                        style: TextStyle(
                            color: white,
                            fontSize: this.lang != null
                                ? (this.lang == "en_US" ? 30 : 25)
                                : 25,
                            fontFamily: defaultFont),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: this.lang != null
                ? (this.lang == "fr_FR" ? double.infinity : size.width * 0.75)
                : size.width * 0.75,
            margin: EdgeInsets.all(20.0),
            padding: EdgeInsets.symmetric(
                horizontal: this.lang == "fr_FR" ? 30 : 30,
                vertical: this.lang == "fr_FR" ? 22 : 20),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withAlpha(100), blurRadius: 10.0),
                ],
                borderRadius: BorderRadius.all(Radius.circular(15)),
                gradient: this.lang != null
                    ? (this.lang == "fr_FR"
                        ? LinearGradient(
                            colors: [
                              blueblack,
                              lightgrey,
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp)
                        : LinearGradient(
                            colors: [
                              lightgrey,
                              background2,
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp))
                    : LinearGradient(
                        colors: [
                          lightgrey,
                          background3,
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp)),
            child: SizedBox(
              width: double.infinity,
              child: Material(
                color: Colors.transparent,
                child: TextButton(
                  onPressed: () {
                    changeLang("fr", "FR");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          height: this.lang != null
                              ? (this.lang == "fr_FR" ? 30 : 25)
                              : 25,
                          margin: const EdgeInsets.only(right: 5),
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/images/fr.png",
                          )),
                      SizedBox(width: 10),
                      Text(
                        "Française",
                        style: TextStyle(
                            color: white,
                            fontSize: this.lang != null
                                ? (this.lang == "en_US" ? 30 : 25)
                                : 25,
                            fontFamily: defaultFont),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: this.lang != null
                ? (this.lang == "am_ET" ? double.infinity : size.width * 0.75)
                : size.width * 0.75,
            margin: EdgeInsets.all(20.0),
            padding: EdgeInsets.symmetric(
                horizontal: this.lang == "am_ET" ? 30 : 30,
                vertical: this.lang == "am_ET" ? 22 : 20),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withAlpha(100), blurRadius: 10.0),
                ],
                borderRadius: BorderRadius.all(Radius.circular(15)),
                gradient: this.lang != null
                    ? (this.lang == "am_ET"
                        ? LinearGradient(
                            colors: [
                              blueblack,
                              lightgrey,
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp)
                        : LinearGradient(
                            colors: [
                              lightgrey,
                              background2,
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp))
                    : LinearGradient(
                        colors: [
                          lightgrey,
                          background3,
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp)),
            child: SizedBox(
              width: double.infinity,
              child: Material(
                color: Colors.transparent,
                child: TextButton(
                  onPressed: () {
                    changeLang("am", "ET");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          height: this.lang != null
                              ? (this.lang == "am_ET" ? 30 : 25)
                              : 25,
                          margin: const EdgeInsets.only(right: 5),
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/images/et.png",
                          )),
                      SizedBox(width: 10),
                      Text(
                        "አማርኛ",
                        style: TextStyle(
                            color: white,
                            fontWeight: FontWeight.bold,
                            fontSize: this.lang != null
                                ? (this.lang == "am_ET" ? 30 : 25)
                                : 25,
                            fontFamily: defaultFont),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );

      // Container(
      //   height: 150,
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Padding(
      //         padding: const EdgeInsets.only(top: 10, left: 17, bottom: 5),
      //         child: Text(
      //           // AppLocalizations.of(context).translate("choose_lang_text"),
      //           "Choose Language",
      //           style: TextStyle(color: black, fontSize: 16),
      //         ),
      //       ),
      //       Row(
      //         children: [
      //           Expanded(
      //             child: SizedBox(
      //               width: double.infinity,
      //               child: Material(
      //                 color: this.lang != null
      //                     ? (this.lang == "am_ET" ? blueblack : background)
      //                     : background,
      //                 child: TextButton(
      //                   onPressed: () {
      //                     changeLang("am", "ET");
      //                   },
      //                   child: Row(
      //                     mainAxisAlignment: MainAxisAlignment.center,
      //                     children: [
      //                       Container(
      //                           height: 17,
      //                           margin: const EdgeInsets.only(right: 5),
      //                           alignment: Alignment.center,
      //                           child: Image.asset(
      //                             "assets/images/et.png",
      //                           )),
      //                       Text(
      //                         "አማርኛ",
      //                         style: TextStyle(
      //                             color: this.lang != null
      //                                 ? (this.lang == "am_ET"
      //                                     ? Colors.white
      //                                     : black)
      //                                 : black,
      //                             fontFamily: defaultFont),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ),
      //           Expanded(
      //             child: SizedBox(
      //               width: double.infinity,
      //               child: Material(
      //                 color: this.lang != null
      //                     ? (this.lang == "en_US" ? blueblack : background)
      //                     : background,
      //                 child: TextButton(
      //                   onPressed: () {
      //                     changeLang("en", "US");
      //                   },
      //                   child: Row(
      //                     mainAxisAlignment: MainAxisAlignment.center,
      //                     children: [
      //                       Container(
      //                           height: 17,
      //                           margin: const EdgeInsets.only(right: 5),
      //                           alignment: Alignment.center,
      //                           child: Image.asset(
      //                             "assets/images/us.png",
      //                           )),
      //                       Text(
      //                         "English",
      //                         style: TextStyle(
      //                             color: this.lang != null
      //                                 ? (this.lang == "en_US"
      //                                     ? Colors.white
      //                                     : black)
      //                                 : black,
      //                             fontFamily: defaultFont),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ),
      //           Expanded(
      //             child: SizedBox(
      //               width: double.infinity,
      //               child: Material(
      //                 color: this.lang != null
      //                     ? (this.lang == "fr_FR" ? blueblack : background)
      //                     : background,
      //                 child: TextButton(
      //                   onPressed: () {
      //                     changeLang("fr", "FR");
      //                   },
      //                   child: Row(
      //                     mainAxisAlignment: MainAxisAlignment.center,
      //                     children: [
      //                       Container(
      //                           height: 17,
      //                           margin: const EdgeInsets.only(right: 5),
      //                           alignment: Alignment.center,
      //                           child: Image.asset(
      //                             "assets/images/fr.png",
      //                           )),
      //                       Text(
      //                         "Française",
      //                         style: TextStyle(
      //                             color: this.lang != null
      //                                 ? (this.lang == "fr_FR"
      //                                     ? Colors.white
      //                                     : black)
      //                                 : black,
      //                             fontFamily: defaultFont),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      // );
    }

    Orientation orientation = MediaQuery.of(context).orientation;

    if (orientation == Orientation.portrait) {
      return Scaffold(
          appBar: widget.title
              ? cleanAppBar(
                  title: AppLocalizations.of(context)!.translate("settings"))
              : null,
          body: SafeArea(
              child: Container(
                  child: Center(
            child: Column(
              children: <Widget>[
                Expanded(flex: 1, child: _logoSection()),
                // _thememode(),
                _chooseLang(),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: AlignmentDirectional.bottomEnd,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        // _loginOrRegister(),
                        _divider(),
                        _goBackBtn(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ))));
    } else {
      return Scaffold(
          appBar: widget.title
              ? cleanAppBar(
                  title: AppLocalizations.of(context)!.translate("settings"))
              : null,
          body: SafeArea(
              child: Container(
                  child: Center(
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: _logoSection(),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          _chooseLang(),
                          _divider(),
                          _goBackBtn(),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ))));
    }
  }
}
