// ignore_for_file: avoid_unnecessary_containers

import 'package:emira_all_in_one_mob/components/app_bars.dart';
import 'package:emira_all_in_one_mob/components/progress.dart';
import 'package:emira_all_in_one_mob/services/fb_service.dart';
import 'package:emira_all_in_one_mob/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:emira_all_in_one_mob/services/app_localizations.dart';
import 'package:country_picker/country_picker.dart';

class HotelFormPage extends StatefulWidget {
  final bool title;
  final dynamic hotel;

  const HotelFormPage({super.key, this.title = false, required this.hotel});
  @override
  HotelFormPageState createState() => HotelFormPageState();
}

class HotelFormPageState extends State<HotelFormPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController controllerFirstName = TextEditingController();
  TextEditingController controllerLastName = TextEditingController();
  TextEditingController controllerPhone = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerCitizenship = TextEditingController();
  String currentState = "none";

  @override
  void dispose() {
    controllerFirstName.text = "";
    controllerLastName.text = "";
    controllerPhone.text = "";
    controllerEmail.text = "";

    currentState = "none";
    super.dispose();
  }

  @override
  void initState() {
    if (FBService.apiStatus != "done") {
      FBService.fetchAPI();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final Size size = MediaQuery.of(context).size;

    Widget firstName() {
      return TextFormField(
        keyboardType: TextInputType.name,
        maxLines: 1,
        controller: controllerFirstName,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.person,
            color: Colors.grey,
          ),
          hintText: AppLocalizations.of(context)!.translate("first_name"),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
        validator: (value) {
          if (value!.trim().isEmpty) {
            return AppLocalizations.of(context)!.translate("first_name_empty");
          } else if (value.length > 25) {
            return AppLocalizations.of(context)!.translate("first_name_l_25");
          } else if (value.length < 2) {
            return AppLocalizations.of(context)!.translate("first_name_g_2");
          }
          return null;
        },
      );
    }

    Widget lastName() {
      return TextFormField(
        keyboardType: TextInputType.name,
        maxLines: 1,
        controller: controllerLastName,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.person,
            color: Colors.grey,
          ),
          hintText: AppLocalizations.of(context)!.translate("last_name"),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
        validator: (value) {
          if (value!.trim().isEmpty) {
            return AppLocalizations.of(context)!.translate("last_name_empty");
          } else if (value.length > 25) {
            return AppLocalizations.of(context)!.translate("last_name_l_25");
          } else if (value.length < 2) {
            return AppLocalizations.of(context)!.translate("last_name_g_2");
          }
          return null;
        },
      );
    }

    Widget phone() {
      return TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.phone,
        controller: controllerPhone,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.phone,
            color: Colors.grey,
          ),
          hintText: AppLocalizations.of(context)!.translate("phone"),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
        validator: (value) {
          if (value!.trim().isEmpty) {
            return AppLocalizations.of(context)!.translate("phone_empty");
          } else if (value.length > 20) {
            return AppLocalizations.of(context)!.translate("invalid_phone");
          } else if (value.length < 10) {
            return AppLocalizations.of(context)!.translate("invalid_phone");
          } else if (!value.startsWith("+") && !value.startsWith("00")) {
            return AppLocalizations.of(context)!
                .translate("phone_format_problem");
          }
          return null;
        },
      );
    }

    Widget email() {
      return TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        controller: controllerEmail,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.email,
            color: Colors.grey,
          ),
          hintText: AppLocalizations.of(context)!.translate("email"),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
        validator: (value) {
          if (value!.trim().isEmpty) {
            return AppLocalizations.of(context)!.translate("email_empty");
          } else if (value.length > 60) {
            return AppLocalizations.of(context)!.translate("email_empty");
          } else if (value.length < 10) {
            return AppLocalizations.of(context)!.translate("email_empty");
          } else if (!value.contains(".") || !value.contains("@")) {
            return AppLocalizations.of(context)!.translate("email_empty");
          }
          return null;
        },
      );
    }

    Widget citizenship() {
      return TextFormField(
        keyboardType: TextInputType.name,
        maxLines: 1,
        readOnly: true,
        controller: controllerCitizenship,
        onTap: () {
          showCountryPicker(
              context: context,
              countryListTheme: CountryListThemeData(
                flagSize: 25,
                backgroundColor: Colors.white,
                textStyle: TextStyle(fontSize: 16, color: grey),
                bottomSheetHeight: 500, // Optional. Country list modal height
                //Optional. Sets the border radius for the bottomsheet.
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                //Optional. Styles the search field.
                inputDecoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate("search"),
                  hintText:
                      AppLocalizations.of(context)!.translate("type_to_search"),
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                ),
              ),
              onSelect: (Country country) {
                controllerCitizenship.text = country.name;
              });
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.location_on,
            color: Colors.grey,
          ),
          hintText: AppLocalizations.of(context)!.translate("nationality"),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
        validator: (value) {
          if (value!.trim().isEmpty) {
            return AppLocalizations.of(context)!.translate("nationality_empty");
          } else if (value.length > 35) {
            return AppLocalizations.of(context)!.translate("nationality_l_35");
          } else if (value.length < 2) {
            return AppLocalizations.of(context)!.translate("nationality_g_2");
          }
          return null;
        },
      );
    }

    Widget bookBtn() {
      return SizedBox(
          width: double.maxFinite,
          height: 60,
          child: ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                setState(() {
                  currentState = "loading";
                });
                FBService.saveBooking(
                        fname: controllerFirstName.text,
                        lname: controllerLastName.text,
                        phone: controllerPhone.text,
                        email: controllerEmail.text,
                        from: controllerCitizenship.text,
                        hotelid: widget.hotel["id"])
                    .then((value) {
                  if (value != "") {
                    setState(() {
                      currentState = "done";
                    });
                  } else {
                    setState(() {
                      currentState = "none";
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(AppLocalizations.of(context)!
                          .translate("couldnt_submit_try_again")),
                      duration: const Duration(seconds: 5),
                    ));
                  }

                  //print(value);
                  // _showMyDialog(value);
                }).catchError((e) {
                  setState(() {
                    currentState = "none";
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(AppLocalizations.of(context)!
                        .translate("couldnt_submit_try_again")),
                    duration: const Duration(seconds: 5),
                  ));

                  ////print(e);
                });
              }
            },
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(color: grey))),
                backgroundColor: MaterialStateProperty.all(grey)),
            child: Text(
              AppLocalizations.of(context)!.translate("submit"),
              style: const TextStyle(fontSize: 20),
            ),
          ));
    }

    Widget smallVSizedBox() {
      return const SizedBox(
        height: 10,
      );
    }

    Widget smallHSizedBox() {
      return const SizedBox(
        width: 10,
      );
    }

    return Scaffold(
      backgroundColor: background3,
      appBar: widget.title ? cleanAppBar(title: "VisaDetail Emira") : null,
      body: Container(
        color: white,
        height: double.infinity,
        child: Stack(
          children: <Widget>[
            orientation == Orientation.portrait
                ? Container(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    height: size.height / 4,
                    decoration: BoxDecoration(
                        color: black,
                        image: DecorationImage(
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.9), BlendMode.dstATop),
                          fit: BoxFit.cover,
                          image: NetworkImage(widget.hotel["image"]),
                        )),
                    child: const Center(child: Text("")))
                : const SizedBox(
                    height: 0,
                  ),
            Container(
              height: double.maxFinite,
              color: Colors.transparent,
              margin: orientation == Orientation.portrait
                  ? EdgeInsets.only(top: size.height / 4 - (10))
                  : const EdgeInsets.only(
                      top: 0,
                    ),
              child: Container(
                decoration: BoxDecoration(
                    color: white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withAlpha(100), blurRadius: 10.0),
                    ],
                    borderRadius: orientation == Orientation.portrait
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))
                        : const BorderRadius.all(Radius.zero)),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
                  child: Column(
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            currentState == "none"
                                ? Form(
                                    key: formKey,
                                    autovalidateMode: AutovalidateMode.disabled,
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(32.0),
                                      child: orientation == Orientation.portrait
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .translate("book_hotel"),
                                                  style: TextStyle(
                                                      color: blueblack,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 30),
                                                ),
                                                smallVSizedBox(),
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .translate(
                                                          "submit_personal_info"),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: grey,
                                                      fontSize: 17),
                                                ),
                                                smallVSizedBox(),
                                                smallVSizedBox(),
                                                firstName(),
                                                smallVSizedBox(),
                                                lastName(),
                                                smallVSizedBox(),
                                                phone(),
                                                smallVSizedBox(),
                                                email(),
                                                smallVSizedBox(),
                                                citizenship(),
                                                smallVSizedBox(),
                                                bookBtn()
                                              ],
                                            )
                                          : Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .translate("book_hotel"),
                                                  style: TextStyle(
                                                      color: blueblack,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 30),
                                                ),
                                                smallVSizedBox(),
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .translate(
                                                          "submit_personal_info"),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: grey,
                                                      fontSize: 17),
                                                ),
                                                smallVSizedBox(),
                                                smallVSizedBox(),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                        child: firstName()),
                                                    smallHSizedBox(),
                                                    Expanded(child: lastName())
                                                  ],
                                                ),
                                                smallVSizedBox(),
                                                Row(
                                                  children: [
                                                    Expanded(child: phone()),
                                                    smallHSizedBox(),
                                                    Expanded(child: email())
                                                  ],
                                                ),
                                                smallVSizedBox(),
                                                bookBtn()
                                              ],
                                            ),
                                    ),
                                  )
                                : currentState == "loading"
                                    ? Padding(
                                        padding: const EdgeInsets.only(top: 70),
                                        child: loadingWidget(context))
                                    : currentState == "error"
                                        ? errorWidget(
                                            context,
                                            AppLocalizations.of(context)!
                                                .translate("error"),
                                          )
                                        : currentState == "done"
                                            ? doneWidget(
                                                context,
                                                "",
                                                AppLocalizations.of(context)!
                                                    .translate(
                                                        "submitted_we_will_contact_you_whatsapp"),
                                              )
                                            : const SizedBox(
                                                height: 0,
                                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBar(
                foregroundColor:
                    orientation == Orientation.portrait ? white : blueblack,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            ),
            // Positioned(
            //   bottom: 0,
            //   left: 0,
            //   right: 0,
            //   child:
            //   ),
          ],
        ),
      ),
    );
  }
}
