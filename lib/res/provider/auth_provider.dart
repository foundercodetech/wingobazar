// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:wingo/model/user_model.dart';
import 'package:wingo/res/api_urls.dart';
import 'package:wingo/res/provider/user_view_provider.dart';
import 'package:wingo/utils/routes/routes_name.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:wingo/view/bottom/bottom_nav_bar.dart';

class UserAuthProvider with ChangeNotifier {

  //setter and getter for loading

  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  UserModel? _loginResponse;

  UserModel? get loginResponse => _loginResponse;

  Future userLogin(context, String phoneNumber, String password) async {
    setRegLoading(true);

    final request = http.MultipartRequest('POST',
        Uri.parse("${ApiUrl.baseUrl}/admin/index.php/mahajongapi/login"));
    // final request = http.MultipartRequest('POST', Uri.parse(ApiUrl.login));
    print("futdu");
    print("${ApiUrl.baseUrl}/admin/index.php/mahajongapi/login");
    request.fields['identity'] = phoneNumber;
    request.fields['password'] = password;

    try {
      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final decodeData = json.decode(responseData);
      print(response);
      print("response");
      print(responseData);
      print("responseData");
      print(decodeData);
      print("decodeData");

      if (decodeData['status'] == '200') {
        if (kDebugMode) {
          print('User Success Registration: $decodeData');
        }
        setRegLoading(false);
        final userPref = Provider.of<UserViewProvider>(context, listen: false);
        userPref.saveUser(UserModel(id: decodeData['id'].toString()));
        // Navigator.pushReplacementNamed(context, RoutesName.bottomNavBar);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>BottomNavBar()));
        return Fluttertoast.showToast(msg: decodeData['msg']);
      } else {
        setRegLoading(false);
        return Fluttertoast.showToast(msg: decodeData['msg']);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }


  ///register
  bool _regLoading = false;
  bool get regLoading => _regLoading;

  setRegLoading(bool value) {
    _regLoading = value;
    notifyListeners();
  }

  Future userRegister(context, String identity, String password, String confirmpass, String referralCode, String email) async {

    setRegLoading(true);
    final request = http.MultipartRequest('POST', Uri.parse(ApiUrl.register));
    print(ApiUrl.register);
    print('🎋🎋🎋');
    request.fields['mobile'] = identity;
    request.fields['password'] = password;
    request.fields['confirmed_password'] = confirmpass;
    request.fields['referral_code'] = referralCode;
    request.fields['email'] = email;
    try {
      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final decodeData = json.decode(responseData);
      if (decodeData['status'] == '200') {
        if (kDebugMode) {
          print('User Success Registration: $decodeData');
        }
        setRegLoading(false);
        final userPref = Provider.of<UserViewProvider>(context, listen: false);
        userPref.saveUser(UserModel(id: decodeData['id'].toString()));
        Navigator.pushReplacementNamed(context, RoutesName.bottomNavBar);
        return Fluttertoast.showToast(msg: decodeData['msg']);
      } else {
        setRegLoading(false);
        return Fluttertoast.showToast(msg: decodeData['msg']);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }

    }
  }

}
