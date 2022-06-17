import 'package:emira_all_in_one_mob/services/fb_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
//import 'package:url_launcher/url_launcher.dart';

String formatAmount(price, currency) {
  String oprice = price.toString();
  String priceInText = "";
  int counter = 0;
  for (int i = (oprice.length - 1); i >= 0; i--) {
    counter++;
    String str = oprice[i];
    if ((counter % 3) != 0 && i != 0) {
      priceInText = "$str$priceInText";
    } else if (i == 0) {
      priceInText = "$str$priceInText";
    } else {
      priceInText = ",$str$priceInText";
    }
  }
  if (currency == "MGA") {
    return priceInText.trim().replaceAll(",", ".");
  }
  return priceInText.trim();
}

Future<FilePickerResult?> selectFile(BuildContext context) async {
  final pm = await FBService.askPermission(context);
  if (pm) {
    return FilePicker.platform.pickFiles();
  } else {
    return null;
  }
}

// void openVisa(url) async {
//   print(url);
//   var urllaunchable =
//       await canLaunchUrl(url); //canLaunch is from url_launcher package
//   if (urllaunchable) {
//     await launchUrl(url);
//   } else {
//     print("cant");
//     throw Exception("URL can't be launched.");
//   }
// }
