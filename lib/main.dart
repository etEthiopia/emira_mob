// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'package:emira_all_in_one_mob/components/app_bars.dart';
import 'package:emira_all_in_one_mob/screens/hotel/hotels.dart';
import 'package:emira_all_in_one_mob/screens/others/about.dart';
import 'package:emira_all_in_one_mob/screens/others/contactus.dart';
import 'package:emira_all_in_one_mob/screens/others/faq.dart';
import 'package:emira_all_in_one_mob/screens/others/home.dart';
import 'package:emira_all_in_one_mob/screens/others/splash_screen.dart';
import 'package:emira_all_in_one_mob/screens/visa/track.dart';
import 'package:emira_all_in_one_mob/screens/visa/visas.dart';
import 'package:emira_all_in_one_mob/screens/others/settings.dart';
import 'package:emira_all_in_one_mob/services/app_localizations.dart';
import 'package:emira_all_in_one_mob/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'components/my_drawer_header.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_core/firebase_core.dart';

const storage = FlutterSecureStorage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Locale locale = Locale('en', 'US');

  @override
  void initState() {
    AppLocalizations.getCurrentLang().then((locale) => {
          setState(() {
            //print(AppLocalizations.currency);
            this.locale = locale;
          })
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('am', 'ET'),
        Locale('fr', 'FR')
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale!.languageCode &&
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      home: SplashPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  var currentPage = DrawerSections.home;
  var currentTitle = "emira_full_name";

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_typing_uninitialized_variables
    var container;
    if (currentPage == DrawerSections.home) {
      container = HomePage(page: 0);
    } else if (currentPage == DrawerSections.visa) {
      container = HomePage(
        page: 1,
      );
    } else if (currentPage == DrawerSections.hotel) {
      container = HomePage(
        page: 2,
      );
    } else if (currentPage == DrawerSections.faq) {
      container = const FAQPage();
    } else if (currentPage == DrawerSections.contact) {
      container = const ContactUsPage();
    } else if (currentPage == DrawerSections.settings) {
      container = const SettingsPage();
    } else {
      container = HomePage(
        page: 0,
      );
    }
    return Scaffold(
      appBar: cleanAppBar(
          title: AppLocalizations.of(context)!.translate(currentTitle)),
      body: container,
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                const MyHeaderDrawer(),
                myDrawerList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget myDrawerList() {
    return Container(
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        // shows the list of menu drawer
        children: [
          menuItem(1, AppLocalizations.of(context)!.translate("home"),
              Icons.home, currentPage == DrawerSections.home ? true : false),
          menuItem(
              2,
              AppLocalizations.of(context)!.translate("visa"),
              Icons.airplane_ticket,
              currentPage == DrawerSections.visa ? true : false),
          menuItem(3, AppLocalizations.of(context)!.translate("hotel"),
              Icons.hotel, currentPage == DrawerSections.hotel ? true : false),
          // menuItem(
          //     3,
          //     AppLocalizations.of(context)!.translate("track"),
          //     Icons.track_changes,
          //     currentPage == DrawerSections.track ? true : false),
          menuItem(
              4,
              AppLocalizations.of(context)!.translate("faq"),
              Icons.question_mark_rounded,
              currentPage == DrawerSections.faq ? true : false),
          menuItem(
              5,
              AppLocalizations.of(context)!.translate("contact"),
              Icons.phone,
              currentPage == DrawerSections.contact ? true : false),
          const Divider(),
          menuItem(
              6,
              AppLocalizations.of(context)!.translate("settings"),
              Icons.settings_outlined,
              currentPage == DrawerSections.settings ? true : false),
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage = DrawerSections.home;
              currentTitle = "emira_full_name";
            } else if (id == 2) {
              currentPage = DrawerSections.visa;
              currentTitle = "emira_full_name";
            } else if (id == 3) {
              currentPage = DrawerSections.hotel;
              currentTitle = "emira_full_name";
            } else if (id == 4) {
              currentPage = DrawerSections.faq;
              currentTitle = "faq";
            } else if (id == 5) {
              currentPage = DrawerSections.contact;
              currentTitle = "contact";
            } else if (id == 6) {
              currentPage = DrawerSections.settings;
              currentTitle = "settings";
            }
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: red,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: TextStyle(
                    color: blueblack,
                    fontSize: 16,
                    fontFamily: defaultFont,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum DrawerSections { home, visa, hotel, faq, contact, settings }
