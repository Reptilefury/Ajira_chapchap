import 'package:ajira_chapchap/Models/address.dart';
import 'package:flutter/material.dart';
class AppData extends ChangeNotifier{
Address PickUpLocation, dropOffLocation;
void updatePickUpLocationAddress(Address pickUpAddress)
{
  PickUpLocation = pickUpAddress;
  notifyListeners();

}
void updateDropOffLocationAddress(Address dropOffAddress)
{
  PickUpLocation = dropOffAddress;
  notifyListeners();

}
}