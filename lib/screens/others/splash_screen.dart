import 'dart:async';

import 'package:emira_all_in_one_mob/main.dart';
import 'package:emira_all_in_one_mob/services/app_localizations.dart';
import 'package:emira_all_in_one_mob/services/fb_service.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  final bool title;

  const SplashPage({super.key, this.title = false});
  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    FBService.fetchAPI();
    FBService.fetchVisas();
    FBService.fetchRate();
    FBService.fetchHotels();
    AppLocalizations.getCurrentCurrency().then((locale) => {
          Timer(
              const Duration(seconds: 2),
              () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const MainPage())))
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    var assetsImage = const AssetImage(
        'assets/images/logo.png'); //<- Creates an object that fetches an image.
    var image = Image(
        image: assetsImage,
        height: 300); //<- Creates a widget that displays an image.

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        /* appBar: AppBar(
          title: Text("MyApp"),
          backgroundColor:
              Colors.blue, //<- background color to combine with the picture :-)
        ),*/
        body: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Stack(
              children: <Widget>[
                orientation == Orientation.portrait
                    ? Positioned.fill(
                        child: Image.asset(
                          "assets/images/dubai.jpg",
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.bottomCenter,
                        ),
                      )
                    : const SizedBox(
                        height: 0,
                      ),
                Center(
                  child: image,
                )
              ],
            )), //<- place where the image appears
      ),
    );
  }
}
