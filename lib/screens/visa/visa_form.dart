// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emira_all_in_one_mob/components/app_bars.dart';
import 'package:emira_all_in_one_mob/components/progress.dart';
import 'package:emira_all_in_one_mob/main.dart';
import 'package:emira_all_in_one_mob/services/fb_service.dart';
import 'package:emira_all_in_one_mob/services/utils.dart';
import 'package:emira_all_in_one_mob/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:emira_all_in_one_mob/services/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:country_picker/country_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class VisaFormPage extends StatefulWidget {
  final bool title;
  final dynamic visa;

  const VisaFormPage({super.key, this.title = false, required this.visa});
  @override
  VisaFormPageState createState() => VisaFormPageState();
}

class VisaFormPageState extends State<VisaFormPage> {
  var currentStep = 0;
  String currentAppState = "none";
  String refnum = "";
  TextEditingController controllerOTP = TextEditingController();
  bool otpPassed = false;

  Future<void> showOTPDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.translate("verification")),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.number,
                  maxLines: 1,
                  maxLength: 6,
                  controller: controllerOTP,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.password,
                      color: Colors.grey,
                    ),
                    hintText: AppLocalizations.of(context)!
                        .translate("verfication_code"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    ),
                  ),
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return AppLocalizations.of(context)!.translate("error");
                    } else if (value.length != 6) {
                      return AppLocalizations.of(context)!.translate("error");
                    }
                    return null;
                  },
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.translate("cancel")),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.translate("submit")),
              onPressed: () {
                FBService.verifyOTP(controllerOTP.text).then((value) {
                  if (value) {
                    setState(() {
                      otpPassed = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.green,
                      content: Text(AppLocalizations.of(context)!
                          .translate("verification_success")),
                      duration: const Duration(seconds: 5),
                    ));
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: red,
                      content: Text(AppLocalizations.of(context)!
                          .translate("verification_failure")),
                      duration: const Duration(seconds: 5),
                    ));
                    setState(() {
                      otpPassed = false;
                    });
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    DetailsState.controllerFirstName.text = "";
    DetailsState.controllerLastName.text = "";
    DetailsState.controllerPhone.text = "";
    DetailsState.controllerEmail.text = "";
    DetailsState.controllerCitizenship.text = "";
    DetailsState.controllerPassportNumber.text = "";
    DetailsState.controllerProfession.text = "";
    DetailsState.controllerTravelDate.text = "";
    DetailsState.controllerPurpose.text = "";
    ContactState.passportUploaded = "none";
    currentAppState = "none";
    currentStep = 0;
    otpPassed = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mapData = <String, String>{};
    mapData["fname"] = DetailsState.controllerFirstName.text;
    mapData["lname"] = DetailsState.controllerLastName.text;
    mapData["phone"] = DetailsState.controllerPhone.text;
    mapData["email"] = DetailsState.controllerEmail.text;
    mapData["citizenship"] = DetailsState.controllerCitizenship.text;
    mapData["passportNumber"] = DetailsState.controllerPassportNumber.text;
    mapData["profession"] = DetailsState.controllerProfession.text;
    mapData["travelDate"] = DetailsState.controllerTravelDate.text;
    mapData["purpose"] = DetailsState.controllerPurpose.text;

    // DetailsState.controllerFirstName.text = "Dagmawi";
    // DetailsState.controllerLastName.text = "Negussu";
    // DetailsState.controllerPhone.text = "+251937886725";
    // DetailsState.controllerEmail.text = "daginegussu@gmail.com";
    // DetailsState.controllerCitizenship.text = "Ethiopia";
    // DetailsState.controllerPassportNumber.text = "EP3243124";
    // DetailsState.controllerProfession.text = "S.E";
    // DetailsState.controllerTravelDate.text = "2022-06-23";
    // DetailsState.controllerPurpose.text = "Visit";

    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                AppLocalizations.of(context)!.translate("visa_app_sent"),
                textAlign: TextAlign.center),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Image.asset(
                      'assets/images/done.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                          "${AppLocalizations.of(context)!.translate("reference_number")}: ",
                          textAlign: TextAlign.center),
                      Text(
                        refnum,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(AppLocalizations.of(context)!.translate("check_inbox"),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  AppLocalizations.of(context)!.translate("ok"),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute<MainPage>(
                    builder: (BuildContext context) {
                      return const MainPage();
                    },
                  ));
                },
              ),
            ],
          );
        },
      );
    }

    void paypalvisamastercard() {
      final Uri url = Uri.parse("https://emirapay.web.app/pay/$refnum");

      launchUrl(url).then((value) {
        final docRef = FirebaseFirestore.instance
            .collection("visaapplications")
            .doc(refnum);
        docRef.snapshots().listen((event) {
          if (event.data()!["paid"]) {
            _showMyDialog();
          }
        }, onError: (error) => {});
      });
    }

    List<Step> steps = [
      Step(
        title: Text(AppLocalizations.of(context)!.translate("details")),
        content: Details(),
        state: currentStep == 0 ? StepState.editing : StepState.indexed,
        isActive: true,
      ),
      Step(
        title: Text(AppLocalizations.of(context)!.translate("passport")),
        content: Contact(),
        state: currentStep == 1 ? StepState.editing : StepState.indexed,
        isActive: true,
      ),
      Step(
        title: Text(AppLocalizations.of(context)!.translate("review")),
        content: Upload(mapData),
        state: currentStep == 2 ? StepState.editing : StepState.indexed,
        isActive: true,
      ),
      Step(
        title: Text(AppLocalizations.of(context)!.translate("checkout")),
        content: Container(
            child: Column(
          children: [
            // Text("Hello"),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Not Available'),
                    ));
                  },
                  child: Container(
                      // height: 100,
                      margin: EdgeInsets.all(8.0),
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              blueblack, //                   <--- border color
                          width: 5.0,
                        ),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: SizedBox(
                            // height: 100,
                            width: double.infinity,
                            child: Image.asset(
                              'assets/images/mvola.png',
                              // height: 100,
                            ),
                          ))),
                ),
                InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Not Available'),
                    ));
                    // print(p.link + "" + ref);
                  },
                  child: Container(
                      // height: 100,
                      margin: EdgeInsets.all(8.0),
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              blueblack, //                   <--- border color
                          width: 5.0,
                        ),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: SizedBox(
                            // height: 100,
                            width: double.infinity,
                            child: Image.asset(
                              'assets/images/orangemoney.png',
                              // height: 100,
                            ),
                          ))),
                ),
              ],
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    paypalvisamastercard();
                  },
                  child: Container(
                      margin: EdgeInsets.all(8.0),
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              blueblack, //                   <--- border color
                          width: 5.0,
                        ),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: SizedBox(
                            // height: 100,
                            width: double.infinity,
                            child: Image.asset(
                              'assets/images/paypal.png',
                              // height: 100,
                            ),
                          ))),
                ),
                InkWell(
                  onTap: () {
                    paypalvisamastercard();
                    // print(p.link + "" + ref);
                  },
                  child: Container(
                      margin: EdgeInsets.all(8.0),
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              blueblack, //                   <--- border color
                          width: 5.0,
                        ),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: Image.asset(
                              'assets/images/visacard.png',
                              // height: 100,
                            ),
                          ))),
                ),
              ],
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    paypalvisamastercard();
                    // print(p.link + "" + ref);
                  },
                  child: Container(
                      margin: EdgeInsets.all(8.0),
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              blueblack, //                   <--- border color
                          width: 5.0,
                        ),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: Image.asset(
                              'assets/images/mastercard.png',
                              // height: 100,
                            ),
                          ))),
                ),
              ],
            ),
          ],
        )),
        state: StepState.complete,
        isActive: true,
      ),
    ];

    return Scaffold(
      appBar: widget.title
          ? cleanAppBar(
              title: AppLocalizations.of(context)!.translate("visa_form"))
          : flatAppBar(
              title: AppLocalizations.of(context)!.translate("visa_form"),
            ),
      body: currentAppState == "loading"
          ? Container(
              child: Center(
              child: loadingWidget(context),
            ))
          : Container(
              child: Stepper(
                currentStep: currentStep,
                steps: steps,
                type: StepperType.vertical,
                controlsBuilder: (context, _) {
                  return Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      children: <Widget>[
                        currentStep > 0 && currentStep < 3
                            ? TextButton(
                                onPressed: () {},
                                child: TextButton(
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .translate("previous"),
                                    style: TextStyle(
                                        color: blueblack, fontSize: 20),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (currentStep > 0) {
                                        currentStep = currentStep - 1;
                                      } else {
                                        currentStep = 0;
                                      }
                                    });
                                  },
                                ),
                              )
                            : SizedBox(height: 0),
                        currentStep < 3
                            ? ElevatedButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            side: BorderSide(color: grey))),
                                    backgroundColor:
                                        MaterialStateProperty.all(grey)),
                                child: Padding(
                                    padding: EdgeInsets.all(
                                        currentStep == 3 ? 5 : 0),
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .translate("continue"),
                                      style: TextStyle(
                                          fontSize: currentStep == 3 ? 25 : 20),
                                    )),
                                onPressed: () {
                                  setState(() {
                                    if (currentStep < steps.length - 1) {
                                      if (currentStep == 0 &&
                                          DetailsState.formKey.currentState!
                                              .validate()) {
                                        if (otpPassed) {
                                          currentStep = currentStep + 1;
                                        } else {
                                          try {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(AppLocalizations.of(
                                                      context)!
                                                  .translate("sending_text")),
                                              duration:
                                                  const Duration(seconds: 3),
                                            ));
                                            setState(() {
                                              currentAppState = "loading";
                                            });
                                            String phone = DetailsState
                                                .controllerPhone.text;
                                            if (phone.substring(0, 2) == "00") {
                                              phone =
                                                  "+${DetailsState.controllerPhone.text.substring(2)}";
                                            }
                                            FBService.auth.verifyPhoneNumber(
                                              timeout: Duration(seconds: 60),
                                              phoneNumber: phone,
                                              verificationCompleted:
                                                  (PhoneAuthCredential
                                                      credential) async {
                                                //print("fbb: verification completed");
                                                setState(() {
                                                  currentAppState = "none";
                                                });
                                                await FBService.auth
                                                    .signInWithCredential(
                                                        credential)
                                                    .then((value) {
                                                  setState(() {
                                                    currentAppState = "none";
                                                  });
                                                  // print(
                                                  //     "fbb: You are logged in successfully");
                                                });
                                              },
                                              verificationFailed:
                                                  (FirebaseAuthException e) {
                                                setState(() {
                                                  currentAppState = "none";
                                                });
                                                errorSnack(context,
                                                    "OTP Failed, Please Try Again");
                                                //print("fbb: " + e.message.toString());
                                              },
                                              codeSent: (String verificationId,
                                                  int? resendToken) {
                                                // print("fbb: coderesent" +
                                                //     verificationId);
                                                FBService.verificationID =
                                                    verificationId;
                                                setState(() {
                                                  currentAppState = "none";
                                                });
                                                showOTPDialog();
                                                //print("fbb: otp popup");
                                                // status = true;
                                              },
                                              codeAutoRetrievalTimeout:
                                                  (String verificationId) {
                                                setState(() {
                                                  currentAppState = "none";
                                                });
                                                errorSnack(
                                                    context, "Request Timeout");
                                                // print(
                                                //     "fbb: timeout" + verificationId);
                                                // status = false;
                                              },
                                            );
                                          } catch (e) {
                                            setState(() {
                                              currentAppState = "none";
                                            });
                                            errorSnack(context,
                                                "Phone Verification Failed, Please Try Again");
                                            // print("fbb: e: " + e.toString());
                                            //return false;
                                          }
                                          // FBService.loginWithPhone(
                                          //         DetailsState.controllerPhone.text)
                                          //     .then((value) {
                                          //   print("fbb: value: " + value.toString());
                                          //   if (value) {
                                          //     showOTPDialog();
                                          //   }
                                          //});
                                        }
                                      } else if (currentStep == 1 &&
                                          ContactState.passportUploaded !=
                                              "none") {
                                        currentStep = currentStep + 1;
                                      } else if (currentStep == 2) {
                                        setState(() {
                                          currentAppState = "loading";
                                        });
                                        try {
                                          DateTime.parse(DetailsState
                                              .controllerTravelDate.text);
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            backgroundColor: red,
                                            content: Text(AppLocalizations.of(
                                                    context)!
                                                .translate(
                                                    "couldnt_submit_try_again")),
                                            duration: Duration(seconds: 4),
                                          ));
                                        }
                                        FBService.saveApplication(
                                                fname: DetailsState
                                                    .controllerFirstName.text,
                                                lname: DetailsState
                                                    .controllerLastName.text,
                                                phone: DetailsState
                                                    .controllerPhone.text,
                                                email: DetailsState
                                                    .controllerEmail.text,
                                                passno: DetailsState
                                                    .controllerPassportNumber
                                                    .text,
                                                profes: DetailsState
                                                    .controllerProfession.text,
                                                tdate: DetailsState
                                                    .controllerTravelDate.text,
                                                from: DetailsState
                                                    .controllerCitizenship.text,
                                                purpo: DetailsState
                                                    .controllerPurpose.text,
                                                passportscan: ContactState
                                                    .passportUploaded,
                                                visaid: widget.visa["id"])
                                            .then((value) {
                                          if (value != "") {
                                            currentStep = currentStep + 1;
                                            refnum = value;
                                            setState(() {
                                              currentAppState = "none";
                                            });
                                          } else {
                                            setState(() {
                                              currentAppState = "none";
                                            });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              backgroundColor: red,
                                              content: Text(AppLocalizations.of(
                                                      context)!
                                                  .translate(
                                                      "couldnt_submit_try_again")),
                                              duration: Duration(seconds: 4),
                                            ));
                                          }
                                        }).catchError((e) {
                                          setState(() {
                                            currentAppState = "none";
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            backgroundColor: red,
                                            content: Text(AppLocalizations.of(
                                                    context)!
                                                .translate(
                                                    "couldnt_submit_try_again")),
                                            duration: Duration(seconds: 4),
                                          ));
                                          // print(e);
                                        });
                                      }
                                    } else {
                                      // if (!await launchUrl(_url)) throw 'Could not launch $_url';

                                      // setState(() {
                                      //   currentAppState = "loading";
                                      // });
                                      // try {
                                      //   DateTime.parse(
                                      //       DetailsState.controllerTravelDate.text);
                                      // } catch (e) {
                                      //   ScaffoldMessenger.of(context)
                                      //       .showSnackBar(SnackBar(
                                      //     backgroundColor: red,
                                      //     content: Text(AppLocalizations.of(context)!
                                      //         .translate("couldnt_submit_try_again")),
                                      //     duration: Duration(seconds: 4),
                                      //   ));
                                      // }
                                      // FBService.saveApplication(
                                      //         fname: DetailsState
                                      //             .controllerFirstName.text,
                                      //         lname: DetailsState
                                      //             .controllerLastName.text,
                                      //         phone:
                                      //             DetailsState.controllerPhone.text,
                                      //         email:
                                      //             DetailsState.controllerEmail.text,
                                      //         passno: DetailsState
                                      //             .controllerPassportNumber.text,
                                      //         profes: DetailsState
                                      //             .controllerProfession.text,
                                      //         tdate: DetailsState
                                      //             .controllerTravelDate.text,
                                      //         from: DetailsState
                                      //             .controllerCitizenship.text,
                                      //         purpo:
                                      //             DetailsState.controllerPurpose.text,
                                      //         passportscan:
                                      //             ContactState.passportUploaded,
                                      //         visaid: widget.visa["id"])
                                      //     .then((value) {
                                      //   if (value != "") {
                                      //     setState(() {
                                      //       refnum:
                                      //       value;
                                      //     });
                                      //     _showMyDialog();
                                      //     setState(() {
                                      //       currentAppState = "none";
                                      //     });
                                      //   } else {
                                      //     setState(() {
                                      //       currentAppState = "none";
                                      //     });
                                      //     ScaffoldMessenger.of(context)
                                      //         .showSnackBar(SnackBar(
                                      //       backgroundColor: red,
                                      //       content: Text(
                                      //           AppLocalizations.of(context)!
                                      //               .translate(
                                      //                   "couldnt_submit_try_again")),
                                      //       duration: Duration(seconds: 4),
                                      //     ));
                                      //   }
                                      // }).catchError((e) {
                                      //   setState(() {
                                      //     currentAppState = "none";
                                      //   });
                                      //   ScaffoldMessenger.of(context)
                                      //       .showSnackBar(SnackBar(
                                      //     backgroundColor: red,
                                      //     content: Text(AppLocalizations.of(context)!
                                      //         .translate("couldnt_submit_try_again")),
                                      //     duration: Duration(seconds: 4),
                                      //   ));
                                      //   // print(e);
                                      // });

                                      // APIService.applyVisa(
                                      //         fname: DetailsState
                                      //             .controllerFirstName.text,
                                      //         lname: DetailsState
                                      //             .controllerLastName.text,
                                      //         phone:
                                      //             DetailsState.controllerPhone.text,
                                      //         email:
                                      //             DetailsState.controllerEmail.text,
                                      //         passno: DetailsState
                                      //             .controllerPassportNumber.text,
                                      //         profes: DetailsState
                                      //             .controllerProfession.text,
                                      //         tdate: DateTime.parse(DetailsState
                                      //             .controllerTravelDate.text),
                                      //         from: DetailsState
                                      //             .controllerCitizenship.text,
                                      //         purpo:
                                      //             DetailsState.controllerPurpose.text,
                                      //         passportscan:
                                      //             ContactState.passportUploaded,
                                      //         selectedvisa: widget.visa["id"])
                                      //     .then((value) {
                                      //   //print(value);
                                      //   _showMyDialog(value);
                                      //   setState(() {
                                      //     currentAppState = "none";
                                      //   });
                                      // }).catchError((e) {
                                      //   setState(() {
                                      //     currentAppState = "none";
                                      //   });
                                      //   ScaffoldMessenger.of(context)
                                      //       .showSnackBar(SnackBar(
                                      //     backgroundColor: red,
                                      //     content: Text(AppLocalizations.of(context)!
                                      //         .translate("couldnt_submit_try_again")),
                                      //     duration: Duration(seconds: 4),
                                      //   ));
                                      //   // print(e);
                                      // });
                                    }
                                  });
                                },
                              )
                            : SizedBox(height: 0),
                      ],
                    ),
                  );
                },
                onStepTapped: (step) {
                  // print(step);
                  // print(currentStep);

                  if (currentStep < 3 && step < currentStep && refnum == "") {
                    setState(() {
                      currentStep = step;
                    });
                  }
                  // else {
                  //   setState(() {
                  //     if (currentStep < steps.length - 1) {
                  //       if (currentStep == 0 &&
                  //           DetailsState.formKey.currentState!.validate()) {
                  //         currentStep = currentStep + 1;
                  //       } else if (currentStep == 1 &&
                  //           ContactState.formKey.currentState!.validate()) {
                  //         currentStep = currentStep + 1;
                  //       } else if (currentStep == 2) {
                  //         currentStep = currentStep + 1;
                  //       }
                  //     } else {
                  //       currentStep = 0;
                  //     }
                  //   });
                  // }

                  // setState(() {
                  //   currentStep = step;
                  // });
                },
              ),
            ),
    );
  }
}

class Details extends StatefulWidget {
  const Details({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DetailsState();
  }
}

class DetailsState extends State<Details> {
  static final formKey = GlobalKey<FormState>();
  static TextEditingController controllerFirstName = TextEditingController();
  static TextEditingController controllerLastName = TextEditingController();

  static TextEditingController controllerPhone = TextEditingController();

  static TextEditingController controllerEmail = TextEditingController();

  static TextEditingController controllerCitizenship = TextEditingController();

  static TextEditingController controllerPassportNumber =
      TextEditingController();

  static TextEditingController controllerProfession = TextEditingController();

  static TextEditingController controllerTravelDate = TextEditingController();

  static TextEditingController controllerPurpose = TextEditingController();

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
                  prefixIcon: Icon(Icons.search),
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
          prefixIcon: Icon(
            Icons.location_on,
            color: Colors.grey,
          ),
          hintText: AppLocalizations.of(context)!.translate("nationality"),
          border: OutlineInputBorder(
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

    Widget passportNumber() {
      return TextFormField(
        keyboardType: TextInputType.text,
        maxLines: 1,
        controller: controllerPassportNumber,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.confirmation_number,
            color: Colors.grey,
          ),
          hintText: AppLocalizations.of(context)!.translate("passport_no"),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
        validator: (value) {
          if (value!.trim().isEmpty) {
            return AppLocalizations.of(context)!.translate("passport_empty");
          } else if (value.length > 45) {
            return AppLocalizations.of(context)!.translate("passport_l_45");
          }
          return null;
        },
      );
    }

    Widget profession() {
      return TextFormField(
        keyboardType: TextInputType.text,
        maxLines: 1,
        controller: controllerProfession,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.cases_sharp,
            color: Colors.grey,
          ),
          hintText: AppLocalizations.of(context)!.translate("profession"),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
        validator: (value) {
          if (value!.trim().isEmpty) {
            return AppLocalizations.of(context)!.translate("profession_empty");
          } else if (value.length > 35) {
            return AppLocalizations.of(context)!.translate("profession_l_55");
          } else if (value.isEmpty) {
            return AppLocalizations.of(context)!.translate("profession_g_1");
          }
          return null;
        },
      );
    }

    Widget travelDate() {
      return TextFormField(
        keyboardType: TextInputType.datetime,
        maxLines: 1,
        controller: controllerTravelDate,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.calendar_today,
            color: Colors.grey,
          ),
          hintText: AppLocalizations.of(context)!.translate("travel_date"),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
        readOnly: true, //set it true, so that user will not able to edit text
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2100),
          );

          if (pickedDate != null) {
            // print(
            //     pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
            // print(
            //     formattedDate); //formatted date output using intl package =>  2021-03-16
            //you can implement different kind of Date Format here according to your requirement

            controllerTravelDate.text =
                formattedDate; //set output date to TextField value.

          }
          // else {
          //   print("Date is not selected");
          // }
        },

        validator: (value) {
          if (value!.trim().isEmpty) {
            return AppLocalizations.of(context)!.translate("travel_date_empty");
          }
          return null;
        },
      );
    }

    Widget purposeOfTravel() {
      return TextFormField(
        keyboardType: TextInputType.text,
        maxLines: 1,
        controller: controllerPurpose,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.grade_outlined,
            color: Colors.grey,
          ),
          hintText: AppLocalizations.of(context)!.translate("purpose"),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
        validator: (value) {
          if (value!.trim().isEmpty) {
            return AppLocalizations.of(context)!.translate("purpose_empty");
          } else if (value.length > 55) {
            return AppLocalizations.of(context)!.translate("purpose_l_55");
          }
          return null;
        },
      );
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

    return Container(
        child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: orientation == Orientation.portrait
                ? Column(
                    children: <Widget>[
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
                      passportNumber(),
                      smallVSizedBox(),
                      profession(),
                      smallVSizedBox(),
                      travelDate(),
                      smallVSizedBox(),
                      purposeOfTravel(),
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: firstName()),
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
                      Row(
                        children: [
                          Expanded(child: citizenship()),
                          smallHSizedBox(),
                          Expanded(child: passportNumber())
                        ],
                      ),
                      smallVSizedBox(),
                      Row(
                        children: [
                          Expanded(child: profession()),
                          smallHSizedBox(),
                          Expanded(child: travelDate())
                        ],
                      ),
                      smallVSizedBox(),
                      purposeOfTravel()
                    ],
                  )));
  }
}

class Contact extends StatefulWidget {
  const Contact({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ContactState();
  }
}

class ContactState extends State<Contact> {
  static final formKey = GlobalKey<FormState>();
  static TextEditingController controllerEmail = TextEditingController();
  static TextEditingController controllerAddress = TextEditingController();
  static TextEditingController controllerMobileNo = TextEditingController();
  String fileuploaded = "none";
  static String passportUploaded = "none";

  @override
  Widget build(BuildContext context) {
    return fileuploaded == "uploading"
        ? SizedBox(height: 200, child: loadingWidget(context))
        : Container(
            child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        // width: 300,
                        child: Material(
                            color: red,
                            borderRadius: BorderRadius.circular(15.0),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              child: TextButton(
                                  onPressed: () {
                                    passportUploaded = "none";
                                    selectFile(context).then((value) {
                                      //print("value");
                                      //print(value);
                                      if (value != null) {
                                        setState(() {
                                          fileuploaded = "uploading";
                                        });
                                        FBService.uploadFile(value, context)
                                            .then((v) {
                                          // print("v");
                                          // print(v);
                                          if (v != "") {
                                            passportUploaded = v;
                                            //print(v);
                                            setState(() {
                                              fileuploaded = "done";
                                            });
                                          } else {
                                            passportUploaded = "none";
                                            setState(() {
                                              fileuploaded = "error";
                                            });
                                          }
                                          // print("upload");
                                          // print(v);
                                        }).catchError((e) {
                                          passportUploaded = "none";
                                          //print(e);
                                          setState(() {
                                            fileuploaded = "error";
                                          });
                                        });
                                      } else {
                                        passportUploaded = "none";
                                        setState(() {
                                          fileuploaded = "error";
                                        });
                                      }
                                    }).catchError((e) {
                                      passportUploaded = "none";
                                      //print(e);
                                      setState(() {
                                        fileuploaded = "error";
                                      });
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .translate("scanned_passport"),
                                        style: TextStyle(
                                            fontSize: 15, color: white),
                                      ),
                                      Icon(
                                        Icons.upload,
                                        size: 17,
                                        color: white,
                                      ),
                                    ],
                                  )),
                            ))),
                  ],
                ),
                fileuploaded == "done"
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          AppLocalizations.of(context)!
                              .translate("passport_uploaded"),
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    : fileuploaded == "error"
                        ? Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translate("couldn't_upload_passport"),
                              style: TextStyle(fontSize: 20, color: red),
                            ),
                          )
                        : SizedBox(
                            height: 0,
                          )
              ],
            ),
          ));
  }
}

class Upload extends StatefulWidget {
  var mapInfo = <String, String>{};

  Upload(this.mapInfo, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return UploadState();
  }
}

class UploadState extends State<Upload> {
  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    var name = "${widget.mapInfo["fname"]} ${widget.mapInfo["lname"]}";
    var email = widget.mapInfo["email"];
    var phone = widget.mapInfo["phone"];
    var citizenship = widget.mapInfo["citizenship"];
    var passportNumber = widget.mapInfo["passportNumber"];
    var profession = widget.mapInfo["profession"];
    var travelDate = widget.mapInfo["travelDate"];
    var purpose = widget.mapInfo["purpose"];

    Widget formItem({required String title, required String data}) {
      return Row(
        children: <Widget>[
          Text(
            "${AppLocalizations.of(context)!.translate(title)} : ",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: blueblack),
          ),
          Text(data, style: const TextStyle(fontSize: 16)),
        ],
      );
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

    return Container(
        child: orientation == Orientation.portrait
            ? Column(
                children: <Widget>[
                  formItem(title: "full_name", data: name),
                  smallVSizedBox(),
                  formItem(title: "nationality", data: citizenship!),
                  smallVSizedBox(),
                  formItem(title: "phone", data: phone!),
                  smallVSizedBox(),
                  formItem(title: "email", data: email!),
                  smallVSizedBox(),
                  formItem(title: "passport_no", data: passportNumber!),
                  smallVSizedBox(),
                  formItem(title: "profession", data: profession!),
                  smallVSizedBox(),
                  formItem(title: "travel_date", data: travelDate!),
                  smallVSizedBox(),
                  formItem(title: "purpose", data: purpose!),
                ],
              )
            : Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: formItem(title: "full_name", data: name),
                      ),
                      smallHSizedBox(),
                      Expanded(
                        child:
                            formItem(title: "nationality", data: citizenship!),
                      )
                    ],
                  ),
                  smallVSizedBox(),
                  Row(
                    children: [
                      Expanded(
                        child: formItem(title: "phone", data: phone!),
                      ),
                      smallHSizedBox(),
                      Expanded(
                        child: formItem(title: "email", data: email!),
                      )
                    ],
                  ),
                  smallVSizedBox(),
                  Row(
                    children: [
                      Expanded(
                        child: formItem(
                            title: "passport_no", data: passportNumber!),
                      ),
                      smallHSizedBox(),
                      Expanded(
                        child: formItem(title: "profession", data: profession!),
                      )
                    ],
                  ),
                  smallVSizedBox(),
                  Row(
                    children: [
                      Expanded(
                        child:
                            formItem(title: "travel_date", data: travelDate!),
                      ),
                      smallHSizedBox(),
                      Expanded(
                        child: formItem(title: "purpose", data: purpose!),
                      )
                    ],
                  ),
                ],
              ));
  }
}
