// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:wingo/model/user_model.dart';
import 'package:wingo/res/api_urls.dart';
import 'package:wingo/res/provider/user_view_provider.dart';
import 'package:wingo/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';


class AddacountProvider with ChangeNotifier {

  UserViewProvider userProvider = UserViewProvider();

  bool _regLoading = false;
  bool get regLoading =>_regLoading;
  setRegLoading(bool value){
    _regLoading=value;
    notifyListeners();
  }
  Future Addacount(context, String name, String bankname,String accountno,String branch, String ifsc) async {
    UserModel user = await userProvider.getUser();
    String token = user.id.toString();

    setRegLoading(true);
    final response = await http.post(
      Uri.parse(ApiUrl.addacount),

      body: jsonEncode({
        "user_id": token,
        "name":name,
        "account_no":accountno,
        "ifsc": ifsc,
        "bank_name": bankname,
        "branch":branch
      }),
    );
    if (response.statusCode == 200) {
      print(response);
      print("rrrrrrrrrr");
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print(responseData);
      print("nnnnnnnnn");
      setRegLoading(false);
      Navigator.pushReplacementNamed(context,  RoutesName.withdrawScreen);
       Fluttertoast.showToast(msg: responseData['msg']);
    } else {
      setRegLoading(false);
      final Map<String, dynamic> responseData = jsonDecode(response.body);
       Fluttertoast.showToast(msg: responseData['msg']);
    }
  }
}