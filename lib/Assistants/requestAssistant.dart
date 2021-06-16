import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ajira_chapchap/Assistants/assistantMethods.dart';

class RequestAssistant {
  static Future<dynamic> getRequest(String url) async {
    http.Response response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key=AIzaSyAJORVTfBFTKvb7RQ8aGkaypVa3-TqX6ZQ'));
    try {
      if (response.statusCode == 200) {
        String jSondata = response.body;
        var decodeData = jsonDecode(jSondata);
        return decodeData;
      } else {
        return "failed";
      }
    } catch (exp) {
      return "failed";
    }
  }
}
