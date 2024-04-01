import 'package:flutter/material.dart';

class ReferralProvider with ChangeNotifier {
  String? _referralCode;

  String? get referralCode => _referralCode;

  void setReferralCode(String code) {
    _referralCode = code;
    notifyListeners();
  }
}