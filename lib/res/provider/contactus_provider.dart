import 'package:wingo/model/aboutus_model.dart';
import 'package:wingo/model/termsconditionModel.dart';
import 'package:flutter/material.dart';


class ContactUsProvider with ChangeNotifier {
  TcModel? _contactusData;

  TcModel? get ContactusData => _contactusData;

  void setCu(TcModel contactData) {
    _contactusData = contactData;
    notifyListeners();
  }
}