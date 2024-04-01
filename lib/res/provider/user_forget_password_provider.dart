// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wingo/model/user_model.dart';
import 'package:wingo/res/api_urls.dart';
import 'package:wingo/res/provider/user_view_provider.dart';
import 'package:wingo/utils/utils.dart';

class UserForgetPasswordProvider with ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  UserViewProvider userProvider = UserViewProvider();

  Future forgetUpdateUser(
    context,
    String mobile,
    String password,
    String newPassword,
  ) async {
    UserModel user = await userProvider.getUser();
    String token = user.id.toString();
    print(ApiUrl.forgetPasswordUrl);
    try {
      setLoading(true);
      final response = await http
          .post(
            Uri.parse(ApiUrl.forgetPasswordUrl),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "mobile": mobile,
              "password": password,
              "new_password": newPassword
            }),
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        setLoading(false);
        if (responseData["error"] == 200) {
          setLoading(false);
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          Utils.flushBarSuccessMessage(
              responseData["msg"], context, Colors.white);
        } else {
          setLoading(false);
          return Utils.flushBarErrorMessage(
              responseData["msg"], context, Colors.white);
        }
      } else {
        setLoading(false);
        return Utils.flushBarErrorMessage(
            "Server Error", context, Colors.white);
      }
    } catch (e) {
      throw Exception('No Internet connection');
    }
  }
}
