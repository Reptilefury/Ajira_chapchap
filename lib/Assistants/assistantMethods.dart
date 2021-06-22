import 'package:ajira_chapchap/Assistants/requestAssistant.dart';
import 'package:ajira_chapchap/DataHandler/appData.dart';
import 'package:ajira_chapchap/Models/address.dart';
import 'package:ajira_chapchap/Models/directDetails.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:ajira_chapchap/configMaps.dart';
import 'package:ajira_chapchap/Assistants/assistantMethods.dart';

import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:ajira_chapchap/Assistants/requestAssistant.dart';
import 'dart:async';

import 'package:ajira_chapchap/AllScreens/searchScreen.dart';
import 'package:ajira_chapchap/AllWidgets/Divider.dart';
import 'package:ajira_chapchap/AllWidgets/progressDialog.dart';
import 'package:ajira_chapchap/DataHandler/appData.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ajira_chapchap/Assistants/assistantMethods.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';

class AssistantMethods {
  static Future<String> searchCoordinateAddress(
      Position position, context) async {
    String placeAddress = "";
    String st1, st2, st3, st4;
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude},&key= mapKey";
    var response = await RequestAssistant.getRequest(url);
    if (response != "failed") {
      // placeAddress = response[""][0]["formatted address"];
      st1 = response["result"][0]["address_components"][0]["Long_name"];
      st2 = response["result"][0]["address_components"][1]["Long_name"];
      st3 = response["result"][0]["address_components"][5]["Long_name"];
      st4 = response["result"][0]["address_components"][6]["Long_name"];

      placeAddress = st1 + "," + st2 + "," + st3 + "," + st4;

      Address userPickAddress = new Address();
      userPickAddress.longitude = position.latitude;
      userPickAddress.latitude = position.latitude;
      userPickAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false)
          .updatePickUpLocationAddress(userPickAddress);
    }
    return placeAddress;
  }

  static Future<DirectionsDetails> obtainPlaceDirectionDetails(
    LatLng initialPosition,
    LatLng finalPosition,
  ) async {
    String directionUrl =
        "https://maps.googleapis.com/maps/api/directions/json? origin=${initialPosition.latitude},${initialPosition.longitude}&destination${finalPosition.longitude}&key=$mapKey";
    var res = await RequestAssistant.getRequest(directionUrl);
    if (res == "failed") {
      return null;
    }
    DirectionsDetails directionsDetails = DirectionsDetails();
    directionsDetails.encodePoints =
        res["routes"][0]["overview_polyline"]["points"];
    directionsDetails.distanceText =
        res["routes"][0]["legs"][0]["distance"]["text"];
    directionsDetails.distanceValue =
        res["routes"][0]["legs"][0]["distance"]["value"];
    directionsDetails.durationText =
        res["routes"][0]["legs"][0]["duration"]["text"];
    directionsDetails.durationValue =
        res["routes"][0]["legs"][0]["duration"]["value"];

    return directionsDetails;
  }

  static int calculateFares(DirectionsDetails directionsDetails) {
    //in terms of KSH
    double timeTraveledFare = (directionsDetails.durationValue / 60) * 0.20;
    double distanceTraveledFare = (directionsDetails.durationValue / 1000) * 0.20;
    double totalFareAmount = timeTraveledFare + distanceTraveledFare;

 double totalLocalAmount = totalFareAmount * 160;
 return totalFareAmount.truncate();

  }
}
