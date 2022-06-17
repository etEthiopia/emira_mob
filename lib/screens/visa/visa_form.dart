// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'package:emira_all_in_one_mob/components/app_bars.dart';
import 'package:emira_all_in_one_mob/components/progress.dart';
import 'package:emira_all_in_one_mob/main.dart';
import 'package:emira_all_in_one_mob/services/api_service.dart';
import 'package:emira_all_in_one_mob/services/fb_service.dart';
import 'package:emira_all_in_one_mob/services/utils.dart';
import 'package:emira_all_in_one_mob/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:emira_all_in_one_mob/services/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:country_picker/country_picker.dart';

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mapData = Map<String, String>();
    mapData["fname"] = DetailsState.controllerFirstName.text;
    mapData["lname"] = DetailsState.controllerLastName.text;
    mapData["phone"] = DetailsState.controllerPhone.text;
    mapData["email"] = DetailsState.controllerEmail.text;
    mapData["citizenship"] = DetailsState.controllerCitizenship.text;
    mapData["passportNumber"] = DetailsState.controllerPassportNumber.text;
    mapData["profession"] = DetailsState.controllerProfession.text;
    mapData["travelDate"] = DetailsState.controllerTravelDate.text;
    mapData["purpose"] = DetailsState.controllerPurpose.text;

    List<Step> steps = [
      Step(
        title: const Text('Details'),
        content: Details(),
        state: currentStep == 0 ? StepState.editing : StepState.indexed,
        isActive: true,
      ),
      Step(
        title: const Text('Documents'),
        content: Contact(),
        state: currentStep == 1 ? StepState.editing : StepState.indexed,
        isActive: true,
      ),
      Step(
        title: const Text('Review'),
        content: Upload(mapData),
        state: currentStep == 2 ? StepState.editing : StepState.indexed,
        isActive: true,
      ),
      Step(
        title: const Text('Checkout'),
        content: Container(
            height: 100,
            child: Center(
              child: const Text("All Done!\nPlease Submit Your Application",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            )),
        state: StepState.complete,
        isActive: true,
      ),
    ];

    Future<void> _showMyDialog(ref) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
                // AppLocalizations.of(context)!
                //     .translate("confirmation_dialog_title"),
                "Visa Application Sent"),
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
                  Row(
                    children: [
                      const Text(
                        // AppLocalizations.of(context)
                        //     .translate("restart_confirmation_dialog_text"),
                        "Reference Number : ",
                      ),
                      Text(
                        ref,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  const Text(
                    // AppLocalizations.of(context)
                    //     .translate("restart_confirmation_dialog_text"),
                    "Please, check your email inbox",
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  // AppLocalizations.of(context)
                  //     .translate("restart_later_btn_text"),
                  "Ok",
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

    return Scaffold(
      appBar: widget.title
          ? cleanAppBar(title: "VisaForm Emira")
          : flatAppBar(title: "Visa Form"),
      body: currentAppState == "loading"
          ? Container(
              child: Center(
              child: loadingWidget(context),
            ))
          : Container(
              child: Stepper(
                currentStep: this.currentStep,
                steps: steps,
                type: StepperType.vertical,
                controlsBuilder: (context, _) {
                  return Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      children: <Widget>[
                        currentStep > 0
                            ? TextButton(
                                onPressed: () {},
                                child: TextButton(
                                  child: Text(
                                    "Previous",
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
                        ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      side: BorderSide(color: grey))),
                              backgroundColor: MaterialStateProperty.all(grey)),
                          child: Text(
                            currentStep == 3 ? "Submit" : "Continue",
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            setState(() {
                              if (currentStep < steps.length - 1) {
                                if (currentStep == 0 &&
                                    DetailsState.formKey.currentState!
                                        .validate()) {
                                  currentStep = currentStep + 1;
                                } else if (currentStep == 1 &&
                                    ContactState.passportUploaded != "none") {
                                  currentStep = currentStep + 1;
                                } else if (currentStep == 2) {
                                  currentStep = currentStep + 1;
                                }
                              } else {
                                setState(() {
                                  currentAppState = "loading";
                                });
                                APIService.applyVisa(
                                        fname: DetailsState
                                            .controllerFirstName.text,
                                        lname: DetailsState
                                            .controllerLastName.text,
                                        phone:
                                            DetailsState.controllerPhone.text,
                                        email:
                                            DetailsState.controllerEmail.text,
                                        passno: DetailsState
                                            .controllerPassportNumber.text,
                                        profes: DetailsState
                                            .controllerProfession.text,
                                        tdate: DateTime.parse(DetailsState
                                            .controllerTravelDate.text),
                                        from: DetailsState
                                            .controllerCitizenship.text,
                                        purpo:
                                            DetailsState.controllerPurpose.text,
                                        passportscan:
                                            ContactState.passportUploaded,
                                        selectedvisa: widget.visa["id"])
                                    .then((value) {
                                  print(value);
                                  _showMyDialog(value);
                                  setState(() {
                                    currentAppState = "none";
                                  });
                                }).catchError((e) {
                                  setState(() {
                                    currentAppState = "none";
                                  });
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    backgroundColor: red,
                                    content: Text(
                                        "Couldn't Submit Your Application, Please Try Again"),
                                    duration: Duration(seconds: 4),
                                  ));
                                  // print(e);
                                });
                              }
                            });
                          },
                        )
                      ],
                    ),
                  );
                },
                onStepTapped: (step) {
                  // if(step < currentStep){
                  // setState(() {
                  //  currentStep = step;
                  // });
                  // }
                  // else{
                  //   setState(() {
                  //             if (currentStep < steps.length - 1) {
                  //               if (currentStep == 0 &&
                  //                   DetailsState.formKey.currentState!.validate()) {
                  //                 currentStep = currentStep + 1;
                  //               } else if (currentStep == 1 &&
                  //                   ContactState.formKey.currentState!.validate()) {
                  //                 currentStep = currentStep + 1;
                  //               } else if (currentStep == 2) {
                  //                 currentStep = currentStep + 1;
                  //               }
                  //             } else {
                  //               currentStep = 0;
                  //             }
                  //           });
                  // }

                  setState(() {
                    currentStep = step;
                  });
                },
              ),
            ),
    );
  }
}

class Details extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DetailsState();
  }
}

class DetailsState extends State<Details> {
  static final formKey = GlobalKey<FormState>();
  static TextEditingController controllerFirstName =
      new TextEditingController();
  static TextEditingController controllerLastName = new TextEditingController();

  static TextEditingController controllerPhone = new TextEditingController();

  static TextEditingController controllerEmail = new TextEditingController();

  static TextEditingController controllerCitizenship =
      new TextEditingController();

  static TextEditingController controllerPassportNumber =
      new TextEditingController();

  static TextEditingController controllerProfession =
      new TextEditingController();

  static TextEditingController controllerTravelDate =
      new TextEditingController();

  static TextEditingController controllerPurpose = new TextEditingController();

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
                  topLeft: const Radius.circular(20.0),
                  topRight: const Radius.circular(20.0),
                ),
                //Optional. Styles the search field.
                inputDecoration: const InputDecoration(
                  labelText: 'Search',
                  hintText: 'Start typing to search',
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
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.location_on,
            color: Colors.grey,
          ),
          hintText: 'Nationality',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
        validator: (value) {
          if (value!.trim().isEmpty) {
            return "Citizenship cannot be empty";
          } else if (value.length > 35) {
            return "Citizenship length must be < 25";
          } else if (value.length < 2) {
            return "Citizenship length must be > 2";
          }
        },
      );
    }

    Widget passportNumber() {
      return TextFormField(
        keyboardType: TextInputType.text,
        maxLines: 1,
        controller: controllerPassportNumber,
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.confirmation_number,
            color: Colors.grey,
          ),
          hintText: 'Passport Number',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
        validator: (value) {
          if (value!.trim().isEmpty) {
            return "Passport cannot be empty";
          } else if (value.length > 45) {
            return "Passport length must be < 5";
          }
        },
      );
    }

    Widget profession() {
      return TextFormField(
        keyboardType: TextInputType.text,
        maxLines: 1,
        controller: controllerProfession,
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.cases_sharp,
            color: Colors.grey,
          ),
          hintText: 'Profession',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
        validator: (value) {
          if (value!.length > 35) {
            return "Profession length must be < 55";
          } else if (value.length < 2) {
            return "Citizenship length must be > 2";
          }
        },
      );
    }

    Widget travelDate() {
      return TextFormField(
        keyboardType: TextInputType.datetime,
        maxLines: 1,
        controller: controllerTravelDate,
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.calendar_today,
            color: Colors.grey,
          ),
          hintText: 'Travel Date',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
        readOnly: true, //set it true, so that user will not able to edit text
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(
                  2000), //DateTime.now() - not to allow to choose before today.
              lastDate: DateTime(2101));

          if (pickedDate != null) {
            print(
                pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
            String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
            print(
                formattedDate); //formatted date output using intl package =>  2021-03-16
            //you can implement different kind of Date Format here according to your requirement

            controllerTravelDate.text =
                formattedDate; //set output date to TextField value.

          } else {
            print("Date is not selected");
          }
        },

        validator: (value) {
          if (value!.trim().isEmpty) {
            return "Travel Date cannot be empty";
          }
        },
      );
    }

    Widget purposeOfTravel() {
      return TextFormField(
        keyboardType: TextInputType.text,
        maxLines: 1,
        controller: controllerPurpose,
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.grade_outlined,
            color: Colors.grey,
          ),
          hintText: 'Purpose of Travel',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
        ),
        validator: (value) {
          if (value!.trim().isEmpty) {
            return "Purpose cannot be empty";
          } else if (value.length > 55) {
            return "Purpose length must be < 55";
          }
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

    // TODO: implement build
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
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ContactState();
  }
}

class ContactState extends State<Contact> {
  static final formKey = GlobalKey<FormState>();
  static TextEditingController controllerEmail = new TextEditingController();
  static TextEditingController controllerAddress = new TextEditingController();
  static TextEditingController controllerMobileNo = new TextEditingController();
  String fileuploaded = "none";
  static String passportUploaded = "none";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return fileuploaded == "uploading"
        ? Container(height: 200, child: loadingWidget(context))
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
                        width: 300,
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
                                      if (value != null) {
                                        setState(() {
                                          fileuploaded = "uploading";
                                        });
                                        FBService.uploadFile(value, context)
                                            .then((v) {
                                          print("v");
                                          print(v);
                                          if (v != "") {
                                            passportUploaded = v;
                                            print(v);
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
                                          print(e);
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
                                      print(e);
                                      setState(() {
                                        fileuploaded = "error";
                                      });
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Scanned Passport (JPG, PNG)",
                                        style: TextStyle(
                                            fontSize: 18, color: white),
                                      ),
                                      Icon(
                                        Icons.upload,
                                        size: 20,
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
                          "Passport Scan Uploaded!",
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    : fileuploaded == "error"
                        ? Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              "Couldn't Upload Passport Scan!",
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
  var mapInfo = Map<String, String>();

  Upload(this.mapInfo);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
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
            "$title: ",
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

    // TODO: implement build
    return Container(
        child: orientation == Orientation.portrait
            ? Column(
                children: <Widget>[
                  formItem(title: "Full Name", data: name),
                  smallVSizedBox(),
                  formItem(title: "Citizenship", data: citizenship!),
                  smallVSizedBox(),
                  formItem(title: "Phone", data: phone!),
                  smallVSizedBox(),
                  formItem(title: "Email", data: email!),
                  smallVSizedBox(),
                  formItem(title: "Passport Number", data: passportNumber!),
                  smallVSizedBox(),
                  formItem(title: "Profession", data: profession!),
                  smallVSizedBox(),
                  formItem(title: "Travel Date", data: travelDate!),
                  smallVSizedBox(),
                  formItem(title: "Purpose", data: purpose!),
                ],
              )
            : Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: formItem(title: "Full Name", data: name),
                      ),
                      smallHSizedBox(),
                      Expanded(
                        child:
                            formItem(title: "Citizenship", data: citizenship!),
                      )
                    ],
                  ),
                  smallVSizedBox(),
                  Row(
                    children: [
                      Expanded(
                        child: formItem(title: "Phone", data: phone!),
                      ),
                      smallHSizedBox(),
                      Expanded(
                        child: formItem(title: "Email", data: email!),
                      )
                    ],
                  ),
                  smallVSizedBox(),
                  Row(
                    children: [
                      Expanded(
                        child: formItem(
                            title: "Passport Number", data: passportNumber!),
                      ),
                      smallHSizedBox(),
                      Expanded(
                        child: formItem(title: "Profession", data: profession!),
                      )
                    ],
                  ),
                  smallVSizedBox(),
                  Row(
                    children: [
                      Expanded(
                        child:
                            formItem(title: "Travel Date", data: travelDate!),
                      ),
                      smallHSizedBox(),
                      Expanded(
                        child: formItem(title: "Purpose", data: purpose!),
                      )
                    ],
                  ),
                ],
              ));
  }
}
