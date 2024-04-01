// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:wingo/generated/assets.dart';
import 'package:wingo/model/user_model.dart';
import 'package:wingo/res/api_urls.dart';
import 'package:wingo/res/components/image_tost.dart';
import 'package:wingo/res/provider/user_view_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;


class BetColorResultProvider with ChangeNotifier {

  UserViewProvider userProvider = UserViewProvider();

  bool _regLoading = false;
  bool get regLoading =>_regLoading;
  setRegLoading(bool value){
    _regLoading=value;
    notifyListeners();
  }
  Future colorBet(context, String amount, String number,int gameid) async {
    UserModel user = await userProvider.getUser();
    String token = user.id.toString();
    setRegLoading(true);
    if(int.parse(amount)>=10) {
      final response = await http.post(
        Uri.parse(ApiUrl.betColorPrediction),
        // headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "userid": token,
          "amount": amount,
          "gameid": gameid.toString(),
          "number": number
        }),
      );
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      if(responseData['error']=='200'){
        print(response);
          print("responsebet");
          print(responseData);
          print("responseData");

        Navigator.pop(context);
        ImageToast.show(imagePath: Assets.imagesBetSucessfull,
          context: context,
          heights: 200,
          widths: 200);
      }else{
        return Fluttertoast.showToast(msg: responseData['msg']);
      }

    }else{
      return Fluttertoast.showToast(msg: "Amount Should be Greater than 10rs");

    }
  }
}