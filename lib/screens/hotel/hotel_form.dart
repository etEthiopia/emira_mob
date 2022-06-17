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
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.person,
            color: Colors.grey,
          ),
          hintText: 'First Name',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
        validator: (value) {
          if (value!.trim().isEmpty) {
            return "First Name cannot be empty";
          } else if (value.length > 25) {
            return "First Name length must be < 25";
          } else if (value.length < 2) {
            return "First Name length must be > 2";
          }
        },
      );
    }

    Widget lastName() {
      return TextFormField(
        keyboardType: TextInputType.name,
        maxLines: 1,
        controller: controllerLastName,
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.person,
            color: Colors.grey,
          ),
          hintText: 'Last Name',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
        validator: (value) {
          if (value!.trim().isEmpty) {
            return "Last Name cannot be empty";
          } else if (value.length > 25) {
            return "Last Name length must be < 25";
          } else if (value.length < 2) {
            return "Last Name length must be > 2";
          }
        },
      );
    }

    Widget phone() {
      return TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.phone,
        controller: controllerPhone,
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.phone,
            color: Colors.grey,
          ),
          hintText: 'Phone',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
        validator: (value) {
          if (value!.trim().isEmpty) {
            return "Phone cannot be empty";
          } else if (value.length > 20) {
            return "Invalid Phone Number";
          } else if (value.length < 10) {
            return "Invalid Phone Number";
          } else if (!value.startsWith("+") && !value.startsWith("00")) {
            return "Phone must start with '+' or '00'";
          }
        },
      );
    }

    Widget email() {
      return TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        controller: controllerEmail,
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.email,
            color: Colors.grey,
          ),
          hintText: 'Email',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
        validator: (value) {
          if (value!.trim().isEmpty) {
            return "Email cannot be empty";
          } else if (value.length > 60) {
            return "Invalid Email";
          } else if (value.length < 10) {
            return "Invalid Email";
          } else if (!value.contains(".") || !value.contains("@")) {
            return "Invalid Email";
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
                    content:
                        Text("Couldn't Submit Your Request, Please Try Again"),
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
              "Submit",
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
                                Colors.black.withOpacity(0.7),
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
                                                    "Book Hotel",
                                                    style: TextStyle(
                                                        color: blueblack,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 30),
                                                  ),
                                                  smallVSizedBox(),
                                                  Text(
                                                    "Submit your personal information, we will contact you via WhatsApp",
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
                                                    "Book Hotel",
                                                    style: TextStyle(
                                                        color: blueblack,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 30),
                                                  ),
                                                  smallVSizedBox(),
                                                  Text(
                                                    "Submit your personal information, we will contact you via WhatsApp",
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
                                          ? errorWidget(context, "", "Error")
                                          : this.currentState == "done"
                                              ? doneWidget(context, "",
                                                  "We Will Contact You Via WhatsApp")
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
