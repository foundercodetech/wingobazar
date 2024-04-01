import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:wingo/generated/assets.dart';
import 'package:wingo/model/user_model.dart';
import 'package:wingo/res/aap_colors.dart';
import 'package:wingo/res/api_urls.dart';
import 'package:wingo/res/components/app_bar.dart';
import 'package:wingo/res/components/app_btn.dart';
import 'package:wingo/res/components/text_field.dart';
import 'package:wingo/res/components/text_widget.dart';
import 'package:wingo/res/provider/user_view_provider.dart';
import 'package:wingo/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {


  bool hideSetPassword = true;
  bool hideConfirmPassword = true;
  bool hideNewPassword = true;
  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  TextEditingController oldPassCon = TextEditingController();
  TextEditingController newPassCon = TextEditingController();
  TextEditingController confirmPassCon = TextEditingController();


  @override
  Widget build(BuildContext context) {

    final widths = MediaQuery.of(context).size.width;
    final heights = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: GradientAppBar(
          leading: AppBackBtn(),
          title: textWidget(
              text: 'Change Password',
              fontSize: 25,
              color: AppColors.primaryTextColor),
          gradient: AppColors.primaryGradient, centerTitle: true,),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: heights*0.01,),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                      child: Row(
                        children: [
                          Image.asset(
                            Assets.iconsPassword,
                            height: 30,
                          ),
                          const SizedBox(width: 20),
                          textWidget(
                              text: 'Old Password',
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                              color: AppColors.secondaryTextColor)
                        ],
                      ),
                    ),
                    SizedBox(height: heights*0.01,),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                      child: CustomTextField(
                        obscureText: hideSetPassword,
                        controller: oldPassCon,
                        maxLines: 1,
                        hintText: 'Enter your old password',
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                hideSetPassword = !hideSetPassword;
                              });
                            },
                            icon: Image.asset(hideSetPassword
                                ? Assets.iconsEyeClose
                                : Assets.iconsEyeOpen)),
                      )),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                      child: Row(
                        children: [
                          Image.asset(
                            Assets.iconsPassword,
                            height: 30,
                          ),
                          const SizedBox(width: 20),
                          textWidget(
                              text: 'New Password',
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                              color: AppColors.secondaryTextColor)
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                        child: CustomTextField(
                          obscureText: hideConfirmPassword,
                          controller: newPassCon,
                          maxLines: 1,
                          hintText: 'Please enter the new password',
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hideConfirmPassword = !hideConfirmPassword;
                                });
                              },
                              icon: Image.asset(hideConfirmPassword
                                  ? Assets.iconsEyeClose
                                  : Assets.iconsEyeOpen)),
                        )),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                      child: Row(
                        children: [
                          Image.asset(
                            Assets.iconsPassword,
                            height: 30,
                          ),
                          const SizedBox(width: 20),
                          textWidget(
                              text: 'Confirm Password',
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                              color: AppColors.secondaryTextColor)
                        ],
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                        child: CustomTextField(
                          obscureText: hideNewPassword,
                          controller: confirmPassCon,
                          maxLines: 1,
                          hintText: 'Please re-enterpassword',
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hideNewPassword = !hideNewPassword;
                                });
                              },
                              icon: Image.asset(hideNewPassword
                                  ? Assets.iconsEyeClose
                                  : Assets.iconsEyeOpen)),
                        )),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 40, 20, 0),
                      child: AppBtn(
                        loading: loading,
                        title: 'U p d a t e',
                        fontSize: 20,
                        titleColor: AppColors.gradientFirstColor,
                        onTap: () {
                          Changepass(oldPassCon.text,newPassCon.text,confirmPassCon.text);
                        },
                        gradient: AppColors.secondaryGradient,
                      ),
                    ),

                  ],
                ),
              ),

            ],
          ),
        ),
      )
    );
  }
  bool loading = false;
  UserViewProvider userProvider = UserViewProvider();
  Changepass(String oldpass, String newpass,String confirmpass) async {
    setState(() {
      loading = true;
    });
    if (kDebugMode) {
      print("guycyg");
    }
    UserModel user = await userProvider.getUser();
    String token = user.id.toString();
    if (kDebugMode) {
      print(token);
    }
    final response = await http.post(Uri.parse(ApiUrl.changepasswordapi),
        headers: <String,String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic >{
          "userid":token,
          "old_password":oldpass,
          "new_password":newpass,
          "confirm_password":confirmpass
        })
    );
    try{
    final data = jsonDecode(response.body);
    print(data);
    print('aaaaa');

    if(response.statusCode==200){

      setState(() {
        loading= false;
      });
      Fluttertoast.showToast(msg:data["msg"],);

    }
    else {
      setState(() {
        loading= false;
      });
      print('ggggg');
      Fluttertoast.showToast(msg:data["msg"],);
    }

 }catch(e){
      setState(() {
        loading= false;
      });
      print(e);
      print('ffffffffffffff');
      Fluttertoast.showToast(msg: "something want wrong\n  try again");
    }
  }
  }










