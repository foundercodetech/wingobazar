// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:wingo/model/user_model.dart';
import 'package:wingo/res/api_urls.dart';
import 'package:wingo/res/provider/user_view_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';


class GiftcardProvider with ChangeNotifier {

  UserViewProvider userProvider = UserViewProvider();

  bool _regLoading = false;
  bool get regLoading =>_regLoading;
  setRegLoading(bool value){
    _regLoading=value;
    notifyListeners();
  }
  Future Giftcode(context, String code) async {
    UserModel user = await userProvider.getUser();
    String token = user.id.toString();

    setRegLoading(true);
    final response = await http.get(Uri.parse("${ApiUrl.giftcardapi}userid=$token&code=$code")).timeout(const Duration(seconds: 10));

    final Map<String, dynamic> responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print(response);
      print("response gift");
      print(responseData);
      print("responseData");
      setRegLoading(false);

      return Fluttertoast.showToast(msg: responseData['msg']);
    }
    else {
      setRegLoading(false);

      return Fluttertoast.showToast(msg: responseData['msg']);
    }
  }
}