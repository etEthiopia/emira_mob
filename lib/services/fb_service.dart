import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:emira_all_in_one_mob/services/api_service.dart';
import 'package:emira_all_in_one_mob/services/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class FBService {
  static String visaStatus = "";
  static String hotelStatus = "";
  static String currencyStatus = "";
  static String apiStatus = "";
  static String faqStatus = "";
  static List<dynamic> visaTypes = [];
  static String verificationID = "";
  static FirebaseAuth auth = FirebaseAuth.instance;
  static Map<String, double> rateTypes = {
    "USD": 0,
    "MGA": 1,
    "EUR": 0,
    "ETB": 0
  };
  static List<dynamic> hotelTypes = [];
  static List<dynamic> faqList = [];

  static Future<dynamic> trackVisa({required String reference}) async {
    try {
      final va = FirebaseFirestore.instance
          .collection("visaapplications")
          .doc(reference);
      final snapshot = await va.get();
      if (snapshot.exists) {
        return snapshot.data();
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<dynamic> fetchRate() async {
    try {
      currencyStatus = "loading";
      final va = FirebaseFirestore.instance.collection("rate").doc("1");
      final snapshot = await va.get();
      if (snapshot.exists) {
        currencyStatus = "done";
        dynamic trate = snapshot.data()!["obj"];
        rateTypes["USD"] = trate["USD"];
        rateTypes["EUR"] = trate["EUR"];
        rateTypes["ETB"] = trate["ETB"];
        return rateTypes;
      } else {
        currencyStatus = "error";
        return null;
      }
    } catch (e) {
      currencyStatus = "error";
      return null;
    }
  }

  static Future<bool> fetchAPI() async {
    try {
      apiStatus = "loading";
      final va = FirebaseFirestore.instance.collection("api").doc("1");
      final snapshot = await va.get();
      if (snapshot.exists) {
        apiStatus = "done";
        APIService.serverIP = snapshot.data()!["link"];
        return true;
      } else {
        apiStatus = "error";
        return false;
      }
    } catch (e) {
      apiStatus = "error";
      return false;
    }
  }

  static Future<List<dynamic>> fetchVisas() async {
    try {
      visaStatus = "loading";
      final va = FirebaseFirestore.instance
          .collection("visatypes")
          .where("status", isEqualTo: true)
          .orderBy("duration");

      final snapshot = await va.get();
      List<dynamic> vs = [];
      if (snapshot.size > 0) {
        snapshot.docs.toList().forEach((element) {
          vs.add({...element.data(), "id": element.id});
        });
        visaTypes = vs;
        visaStatus = "done";
        return vs;
      } else {
        visaTypes = [];
        visaStatus = "done";
        return [];
      }
    } catch (e) {
      visaTypes = [];
      visaStatus = "error";
      return [];
    }
  }

  static Future<List<dynamic>> fetchHotels() async {
    try {
      hotelStatus = "loading";
      final va = FirebaseFirestore.instance
          .collection("hoteltypes")
          .where("status", isEqualTo: true)
          .orderBy("title");

      final snapshot = await va.get();
      List<dynamic> vs = [];
      if (snapshot.size > 0) {
        snapshot.docs.toList().forEach((element) {
          vs.add({...element.data(), "id": element.id});
        });
        hotelTypes = vs;
        hotelStatus = "done";

        return vs;
      } else {
        hotelTypes = [];
        hotelStatus = "done";

        return [];
      }
    } catch (e) {
      hotelTypes = [];
      hotelStatus = "error";
      ////print(e);
      return [];
    }
  }

  static Future<List<dynamic>> fetchFAQs() async {
    try {
      faqStatus = "loading";
      final va = FirebaseFirestore.instance.collection("faqs");

      final snapshot = await va.get();
      List<dynamic> vs = [];
      if (snapshot.size > 0) {
        snapshot.docs.toList().forEach((element) {
          vs.add({...element.data(), "id": element.id});
        });
        faqStatus = "done";
        faqList = vs;
        return vs;
      } else {
        faqStatus = "done";
        faqList = [];

        return [];
      }
    } catch (e) {
      faqStatus = "error";
      faqList = [];
      return [];
    }
  }

  static Future<bool> downloadFile(
      String ref, String filename, BuildContext context) async {
    try {
      final pm = await FBService.askPermission(context);
      if (pm) {
        Directory appDocDir = await getApplicationDocumentsDirectory();
        File downloadToFile = File('${appDocDir.path}/$filename.pdf');

        final downloadTask = FirebaseStorage.instance
            .refFromURL(ref)
            .writeToFile(downloadToFile);
        downloadTask.snapshotEvents.listen((taskSnapshot) async {
          switch (taskSnapshot.state) {
            case TaskState.running:
              ////print("running");
              break;
            case TaskState.paused:
              ////print("paused");
              break;
            case TaskState.success:
              downloadToFile.create(recursive: true);
              Uint8List bytes = await downloadToFile.readAsBytes();
              await downloadToFile.writeAsBytes(bytes);
              break;
            case TaskState.canceled:
              ////print("canceled");
              break;
            case TaskState.error:
              ////print("error");
              break;
          }
        });

        return true;
      } else {
        return false;
      }
    } on FirebaseException {
      // e.g, e.code == 'canceled'
      ////print('Download error: $e');
      return false;
    } catch (e) {
      // //print(e);
      return false;
    }
  }

  static Future uploadFile(
      FilePickerResult passport, BuildContext context) async {
    try {
      final pm = await FBService.askPermission(context);
      if (pm) {
        final file = File(passport.paths[0]!);
        final destination =
            "passports/${DateTime.now().toString().replaceAll('-', '_').substring(0, 10)}_${basename(passport.paths[0]!)}";

        final length = await file.length();
        if (length > 2097152) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("File size must be less than 2MB"),
            duration: Duration(seconds: 2),
          ));
          return "";
        } else {
          if (["JPEG", "JPG", "PNG"].contains(
              basename(passport.paths[0]!).split(".").last.toUpperCase())) {
            final ref = FirebaseStorage.instance.ref(destination).child('/');
            await ref.putFile(file);
            final url = await ref.getDownloadURL();
            return url;
          } else {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Passport must be a JPG or PNG"),
              duration: Duration(seconds: 2),
            ));
            return "";
          }
        }
      } else {
        return "";
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Couldn't Upload Your Passport"),
        duration: Duration(seconds: 2),
      ));
      ////print('error occured');
      return "";
    }
  }

  static Future<bool> askPermission(BuildContext context) async {
    final status = await Permission.storage.request();
    ////print("ask permission");
    if (status == PermissionStatus.granted) {
      ////print('Permission granted');
      return true;
    } else if (status == PermissionStatus.denied) {
      // //print(
      //     'Denied. Show a dialog with a reason and again ask for the permission.');
      //askPermission(context);
    } else if (status == PermissionStatus.permanentlyDenied) {}

    if (status != PermissionStatus.granted) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please Allow Emira E-Visa to Read and Write Files"),
        duration: Duration(seconds: 5),
      ));
      return false;
    }
    return true;
  }

  static Future<bool> loginWithPhone(String phone) async {
    bool status = false;
    //print("fbb: starting");
    try {
      await auth
          .verifyPhoneNumber(
            phoneNumber: phone,
            verificationCompleted: (PhoneAuthCredential credential) async {
              //print("fbb: verification completed");
              await auth.signInWithCredential(credential).then((value) {
                //print("fbb: You are logged in successfully");
                status = true;
              });
            },
            verificationFailed: (FirebaseAuthException e) {
              //print("fbb: " + e.message.toString());
              status = false;
            },
            codeSent: (String verificationId, int? resendToken) {
              //print("fbb: coderesent" + verificationId);
              FBService.verificationID = verificationId;
              status = true;
            },
            codeAutoRetrievalTimeout: (String verificationId) {
              //print("fbb: timeout" + verificationID);
              status = false;
            },
          )
          .then((value) => status);
      return status;
    } catch (e) {
      //print("fbb: e: " + e.toString());
      return false;
    }
  }

  static Future<bool> verifyOTP(String text) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: text);
    bool status = false;
    await auth.signInWithCredential(credential).then((value) {
      //print("You are logged in successfully");
      status = true;
    }).catchError((e) {
      //print(e);
      status = false;
    });
    return status;
  }

  static Future<String> saveApplication({
    required String fname,
    required String lname,
    required String phone,
    required String email,
    required String passno,
    required String profes,
    required String tdate,
    required String purpo,
    required String from,
    required String passportscan,
    required String visaid,
  }) async {
    try {
      //visaStatus = "loading";
      String ref = "EMV";
      var rng = Random();
      for (var i = 0; i < 10; i++) {
        ref += rng.nextInt(9).toString();
      }

      final va =
          FirebaseFirestore.instance.collection("visaapplications").doc(ref);
      final vt = FirebaseFirestore.instance.collection("visatypes").doc(visaid);
      final vasnapshot = await va.get();

      if (vasnapshot.exists) {
        return "";
      } else {
        final vtsnapshot = await vt.get();

        Map<String, dynamic> data = <String, dynamic>{
          "fname": fname,
          "lname": lname,
          "phone": phone,
          "email": email,
          "passno": passno,
          "profes": profes,
          "tdate": DateTime.parse(tdate),
          "purpo": purpo,
          "from": from.toLowerCase(),
          "passportscan": passportscan,
          "nationalidscan": "",
          "client": Platform.isAndroid ? "android" : "ios",
          "visa_id": visaid,
          "visa_name": vtsnapshot.data()!["duration"] +
              ", " +
              vtsnapshot.data()!["entry"],
          "visa_price": vtsnapshot.data()!["price"],
          "created_at": DateTime.now(),
          "updated_at": DateTime.now(),
          "paid": false,
          "currency": AppLocalizations.currency,
          "status": 0,
          "changed": false
        };

        //bool success = false;
        await va.set(data).then((value) async {
          // success = true;
          //  final vt = FirebaseFirestore.instance.collection("visatypes").doc(visaid);
          await vt.update({"applications": FieldValue.increment(1)}).then(
              (sappone) async {
            final appscountry = FirebaseFirestore.instance
                .collection("stats")
                .doc("applications_per_country");
            final visastatus =
                FirebaseFirestore.instance.collection("stats").doc("visa");
            await appscountry
                .update({from.toLowerCase(): FieldValue.increment(1)}).then(
                    (appscountry) async {
              await visastatus.update({"total": FieldValue.increment(1)}).then(
                  (visastatusres) {
                return ref;
              });
              return ref;
            });
          });
        });
        return ref;
      }
    } catch (e) {
      return "";
    }
  }
}
