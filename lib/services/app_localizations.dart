import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:emira_all_in_one_mob/main.dart';

class AppLocalizations {
  final Locale locale;
  static String currency = "";
  static Map<String, double> rate = {};

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  Map<String, String> _localizedStrings = {};

  Future<bool> load() async {
    String jsonString =
        await rootBundle.loadString('lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));

    return true;
  }

  // String? translate(String key) {
  //   return _localizedStrings[key];
  // }

  String translate(String key) {
// Returns a localized text
    String? text = _localizedStrings[key];
    if (text == null) return "";
    return text;
  }

  static Future<void> getCurrentCurrency() async {
    var scurrency = await storage.read(key: "currency");
    try {
      if (scurrency != null) {
        AppLocalizations.currency = scurrency;
      }
      if (scurrency == "") {
        AppLocalizations.currency = "MGA";
      }
    } catch (e) {
      AppLocalizations.currency = "MGA";
    }
  }

  static Future<Locale> getCurrentLang() async {
    var str = await storage.read(key: "lang");

    Locale locale;
    try {
      if (str != null) {
        if (str.length == 5) {
          locale = Locale(str.substring(0, 2), str.substring((3)));
          return locale;
        }
      }
      locale = const Locale('en', 'US');
      return locale;
    } catch (e) {
      locale = const Locale('en', 'US');
      return locale;
    }
  }

  static Future<bool> storelang(Locale l) async {
    if (l.languageCode == 'en' && l.countryCode == 'US') {
      await storage.delete(key: 'lang');
      return true;
    } else {
      await storage.write(
          key: 'lang', value: '${l.languageCode}-${l.countryCode}');
      return true;
    }
  }

  static Future<bool> storecurrency(String currency) async {
    await storage.write(key: 'currency', value: currency);
    return true;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'am', 'fr'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}
