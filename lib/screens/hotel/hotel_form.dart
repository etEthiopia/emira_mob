// ignore_for_file: avoid_unnecessary_containers

import 'package:emira_all_in_one_mob/components/app_bars.dart';
import 'package:emira_all_in_one_mob/components/progress.dart';
import 'package:emira_all_in_one_mob/screens/visa/visa_form.dart';
import 'package:emira_all_in_one_mob/services/api_service.dart';
import 'package:emira_all_in_one_mob/services/const_data.dart';
import 'package:emira_all_in_one_mob/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:emira_all_in_one_mob/services/app_localizations.dart';

class HotelFormPage extends StatefulWidget {
  final bool title;
  final dynamic hotel;

  const HotelFormPage({super.key, this.title = false, required this.hotel});
  @override
  HotelFormPageState createState() => HotelFormPageState();
}

class HotelFormPageState extends State<HotelFormPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController controllerFirstName = new TextEditingController();
  TextEditingController controllerLastName = new TextEditingController();
  TextEditingController controllerPhone = new TextEditingController();
  TextEditingController controllerEmail = new TextEditingController();
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
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;

    Widget firstName() {
      return TextFormField(
        keyboardType: TextInputType.name,
        maxLines: 1,
        controller: controllerFirstName,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.person,
            color: Colors.grey,
          ),
          hintText: AppLocalizations.of(context)!.translate("first_name"),
          border: OutlineInputBorder(
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
        },
      );
    }

    Widget lastName() {
      return TextFormField(
        keyboardType: TextInputType.name,
        maxLines: 1,
        controller: controllerLastName,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.person,
            color: Colors.grey,
          ),
          hintText: AppLocalizations.of(context)!.translate("last_name"),
          border: OutlineInputBorder(
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
        },
      );
    }

    Widget phone() {
      return TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.phone,
        controller: controllerPhone,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.phone,
            color: Colors.grey,
          ),
          hintText: AppLocalizations.of(context)!.translate("phone"),
          border: OutlineInputBorder(
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
        },
      );
    }

    Widget email() {
      return TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        controller: controllerEmail,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.email,
            color: Colors.grey,
          ),
          hintText: AppLocalizations.of(context)!.translate("email"),
          border: OutlineInputBorder(
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
                this.setState(() {
                  currentState = "loading";
                });
                APIService.applyHotel(
                        fname: controllerFirstName.text,
                        lname: controllerLastName.text,
                        phone: controllerPhone.text,
                        email: controllerEmail.text,
                        selectedhotel: widget.hotel["id"])
                    .then((value) {
                  this.setState(() {
                    currentState = "done";
                  });
                  print(value);
                  // _showMyDialog(value);
                }).catchError((e) {
                  this.setState(() {
                    currentState = "none";
                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(AppLocalizations.of(context)!
                        .translate("couldnt_submit_try_again")),
                    duration: Duration(seconds: 5),
                  ));

                  //print(e);
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
              style: TextStyle(fontSize: 20),
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
      body: SafeArea(
        child: Container(
          color: white,
          height: double.infinity,
          child: Stack(
            children: <Widget>[
              orientation == Orientation.portrait
                  ? Container(
                      padding: EdgeInsets.only(top: 20, bottom: 10),
                      height: 300,
                      decoration: BoxDecoration(
                          color: black,
                          image: DecorationImage(
                            colorFilter: new ColorFilter.mode(
                                Colors.black.withOpacity(0.9),
                                BlendMode.dstATop),
                            fit: BoxFit.cover,
                            image: NetworkImage(widget.hotel["image"]),
                          )),
                      child: Center(child: Text("")))
                  : SizedBox(
                      height: 0,
                    ),
              Container(
                height: double.maxFinite,
                color: Colors.transparent,
                margin: orientation == Orientation.portrait
                    ? const EdgeInsets.only(top: 290)
                    : EdgeInsets.only(
                        top: 0,
                      ),
                child: Container(
                  decoration: BoxDecoration(
                      color: white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withAlpha(100),
                            blurRadius: 10.0),
                      ],
                      borderRadius: orientation == Orientation.portrait
                          ? BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))
                          : BorderRadius.all(Radius.zero)),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
                    child: Column(
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              this.currentState == "none"
                                  ? Form(
                                      key: formKey,
                                      autovalidateMode:
                                          AutovalidateMode.disabled,
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(32.0),
                                        child: orientation ==
                                                Orientation.portrait
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .translate(
                                                            "book_hotel"),
                                                    style: TextStyle(
                                                        color: blueblack,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 30),
                                                  ),
                                                  smallVSizedBox(),
                                                  Text(
                                                    AppLocalizations.of(
                                                            context)!
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
                                                  bookBtn()
                                                ],
                                              )
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .translate(
                                                            "book_hotel"),
                                                    style: TextStyle(
                                                        color: blueblack,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 30),
                                                  ),
                                                  smallVSizedBox(),
                                                  Text(
                                                    AppLocalizations.of(
                                                            context)!
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
                                                      Expanded(
                                                          child: lastName())
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
                                  : this.currentState == "loading"
                                      ? Padding(
                                          padding: EdgeInsets.only(top: 70),
                                          child: loadingWidget(context))
                                      : this.currentState == "error"
                                          ? errorWidget(
                                              context,
                                              AppLocalizations.of(context)!
                                                  .translate("error"),
                                            )
                                          : this.currentState == "done"
                                              ? doneWidget(
                                                  context,
                                                  "",
                                                  AppLocalizations.of(context)!
                                                      .translate(
                                                          "submitted_we_will_contact_you_whatsapp"),
                                                )
                                              : SizedBox(
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
      ),
    );
  }
}
