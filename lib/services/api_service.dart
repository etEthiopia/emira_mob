import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class APIService {
  static String SERVER_IP = "serene-ocean-60681.herokuapp.com";
  //serene-ocean-60681.herokuapp.com

  // Apply For A Visa
  static Future<String> applyVisa({
    required String fname,
    required String lname,
    required String phone,
    required String email,
    required String passno,
    required String profes,
    required DateTime tdate,
    required String from,
    required String purpo,
    required String passportscan,
    required String selectedvisa,
  }) async {
    try {
      var url = Uri.https(SERVER_IP, '/applications');
      print(selectedvisa);
      var res = await http
          .post(url,
              headers: {'Content-Type': 'application/json; charset=UTF-8'},
              body: jsonEncode(<String, dynamic>{
                "id": selectedvisa,
                "applicant": {
                  "fname": fname,
                  "lname": lname,
                  "phone": phone,
                  "email": email,
                  "passno": passno,
                  "profes": profes,
                  "tdate": tdate.toIso8601String(),
                  "from": from,
                  "purpo": purpo,
                  "passportscan": passportscan,
                },
                "selectedvisa": selectedvisa,
                "client": "android"
              }))
          .timeout(Duration(seconds: 60));
      if (res.statusCode == 201) {
        if (json.decode(res.body)['success']) {
          print(json.decode(res.body)['reference']);
          return json.decode(res.body)['reference'];
        } else {
          print('Wrong Request');
          throw Exception('Wrong Request');
        }
      } else {
        print('Wrong Connection ${res.statusCode}');
        print(res.body);
        throw Exception('Wrong Connection');
      }
    } catch (e) {
      if (e is SocketException) {
        if (e.toString().contains("Network is unreachable")) {
          print('Internet Error');
          throw Exception("Check Your Connection");
        } else if (e.toString().contains("Connection refused")) {
          print('Error from Server');
          throw Exception("Sorry, We couldn't reach the server");
        } else {
          print('Connection Error $e');
          throw Exception("Sorry, We couldn't get a response from our server");
        }
      } else {
        print(e);
        throw Exception("Sorry, We couldn't get a response from our server");
      }
    }
  }

  // Apply For A Hotel Booking
  static Future<bool> applyHotel({
    required String fname,
    required String lname,
    required String phone,
    required String email,
    required String selectedhotel,
  }) async {
    try {
      var url = Uri.https(SERVER_IP, '/hotels');

      var res = await http
          .post(url,
              headers: {'Content-Type': 'application/json; charset=UTF-8'},
              body: jsonEncode(<String, dynamic>{
                "hfname": fname,
                "hlname": lname,
                "hphone": phone,
                "hemail": email,
                "hotel_id": selectedhotel,
                "client": "android"
              }))
          .timeout(Duration(seconds: 60));
      if (res.statusCode == 201) {
        if (json.decode(res.body)['success']) {
          print(json.decode(res.body)['reference']);
          return true;
        } else {
          print('Wrong Request');
          throw Exception('Wrong Request');
        }
      } else {
        print('Wrong Connection ${res.statusCode}');
        throw Exception('Wrong Connection');
      }
    } catch (e) {
      if (e is SocketException) {
        if (e.toString().contains("Network is unreachable")) {
          print('Internet Error');
          throw Exception("Check Your Connection");
        } else if (e.toString().contains("Connection refused")) {
          print('Error from Server');
          throw Exception("Sorry, We couldn't reach the server");
        } else {
          print('Connection Error $e');
          throw Exception("Sorry, We couldn't get a response from our server");
        }
      } else {
        print(e);
        throw Exception("Sorry, We couldn't get a response from our server");
      }
    }
  }
}
