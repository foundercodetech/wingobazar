
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wingo/generated/assets.dart';
import 'package:wingo/main.dart';
import 'package:wingo/res/aap_colors.dart';
import 'package:wingo/res/api_urls.dart';
import 'package:wingo/res/components/app_bar.dart';
import 'package:wingo/res/components/app_btn.dart';
import 'package:wingo/res/components/app_disable_button.dart';
import 'package:wingo/res/components/text_field.dart';
import 'package:wingo/res/components/text_widget.dart';
import 'package:wingo/res/provider/auth_provider.dart';
import 'package:wingo/utils/routes/routes_name.dart';
import 'package:wingo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../res/components/rich_text.dart';
import 'package:http/http.dart' as http;

import '../../res/provider/register-provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool hideSetPassword = true;
  bool hideConfirmPassword = true;
  bool readAndAgreePolicy = false;

  TextEditingController phoneCon = TextEditingController();
  TextEditingController setPasswordCon = TextEditingController();
  TextEditingController confirmPasswordCon = TextEditingController();
  TextEditingController referCode = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  TextEditingController verifyCode = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  int secondsRemaining = 60;
  late Timer timer;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        if (secondsRemaining > 0) {
          secondsRemaining--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

bool disable=false;
  @override
  Widget build(BuildContext context) {
    // final refCode= Provider.of<ReferralProvider>(context).referralCode;
    final authProvider = Provider.of<UserAuthProvider>(context);
    String argument = ModalRoute.of(context)!.settings.arguments.toString();

    return Scaffold(
      appBar: const GradientAppBar(
        title: Text(
          'Register',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        gradient: AppColors.primaryGradient,
        centerTitle: true,
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const CircleAvatar(
                  radius: 80,
                  backgroundImage: AssetImage(Assets.imagesWingoLogo),
                ),
                const SizedBox(height: 20),
                Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 100,
                          child: CustomTextField(
                            enabled: false,
                            hintText: '+91',
                            prefixIcon: Icon(
                              Icons.mobile_friendly,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        Expanded(
                            child: CustomTextField(
                          keyboardType: TextInputType.phone,
                          controller: phoneCon,
                          maxLength: 10,
                          hintText: 'Mobile number',
                        )),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                  child: CustomTextField(
                    obscureText: hideSetPassword,
                    controller: setPasswordCon,
                    maxLines: 1,
                    hintText: 'Login password (≥6 characters)',
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.red,
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            hideSetPassword = !hideSetPassword;
                          });
                        },
                        icon: Image.asset(hideSetPassword
                            ? Assets.iconsEyeClose
                            : Assets.iconsEyeOpen)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                  child: CustomTextField(
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.red,
                    ),
                    obscureText: hideConfirmPassword,
                    controller: confirmPasswordCon,
                    maxLines: 1,
                    hintText: 'Confirm Login password',
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            hideConfirmPassword = !hideConfirmPassword;
                          });
                        },
                        icon: Image.asset(hideConfirmPassword
                            ? Assets.iconsEyeClose
                            : Assets.iconsEyeOpen)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                  child: CustomTextField(
                    controller: referCode,
                    prefixIcon: const Icon(
                      Icons.source,
                      color: Colors.red,
                    ),
                    maxLines: 1,
                    hintText: 'Invite code',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                  child: CustomTextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailCon,
                    prefixIcon: const Icon(
                      Icons.source,
                      color: Colors.red,
                    ),
                    maxLines: 1,
                    hintText: 'Email here',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                  child: Row(
                    children: [
                      CustomTextField(
                        width: width / 1.6,
                        controller: verifyCode,
                        prefixIcon: const Icon(
                          Icons.verified_user,
                          color: Colors.red,
                        ),
                        maxLines: 1,
                        hintText: 'Verification code',
                      ),
                      AppBtn(
                        onTap: () {
                          if (phoneCon.text.isEmpty || phoneCon.text.length != 10) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please enter a valid 10-digit phone number."),
                              ),
                            );
                          } else if (secondsRemaining == 0 || secondsRemaining == 60) {
                            otpSent(phoneCon.text);
                            startTimer();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please wait for 60 seconds before requesting OTP again."),
                              ),
                            );
                          }
                        },
                        title: secondsRemaining == 0 || secondsRemaining == 60
                            ? "Code"
                            : '$secondsRemaining s',
                        width: width / 4.8,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                  child: AppBtn(
                      title: 'Register',
                      fontSize: 20,
                      loading: authProvider.regLoading,
                      onTap: () async{
                        if (phoneCon.text.isEmpty || phoneCon.text.length != 10) {
                          Utils.flushBarSuccessMessage(
                              "Enter phone number", context, Colors.red);
                        } else if (setPasswordCon.text.isEmpty) {
                          Utils.flushBarSuccessMessage(
                              "Set your password", context, Colors.red);
                        } else if (confirmPasswordCon.text.isEmpty) {
                          Utils.flushBarSuccessMessage(
                              "Confirm your password", context, Colors.red);
                        } else if (emailCon.text.isEmpty) {
                          Utils.flushBarSuccessMessage(
                              "Confirm your email", context, Colors.red);
                        } else {
                         final res= await http.get(Uri.parse("https://otp.hopegamings.in/verifyotp.php?mobile=${phoneCon.text}&otp=${verifyCode.text}"));
                         String data=jsonDecode(res.body)['error'];
                         data=="400"?Utils.flushBarSuccessMessage(
                             "Wrong Otp", context, Colors.red):
                          authProvider.userRegister(
                              context,
                              phoneCon.text,
                              setPasswordCon.text,
                              confirmPasswordCon.text,
                              referCode.text,
                              emailCon.text
                          );
                        }
                      },
                      hideBorder: true,
                      gradient: AppColors.primaryGradient),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textWidget(
                          text: 'Already have an account?',
                          fontSize: 14,
                          color: AppColors.secondaryTextColor,
                          fontWeight: FontWeight.w600),
                      const SizedBox(width: 5),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, RoutesName.loginScreen);
                          },
                          child: textWidget(
                              text: 'Log in',
                              fontSize: 18,
                              color: AppColors.gradientFirstColor,
                              fontWeight: FontWeight.w600))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 5, 20, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            readAndAgreePolicy = !readAndAgreePolicy;
                          });
                        },
                        child: Container(
                          height: 25,
                          width: 25,
                          alignment: Alignment.center,
                          decoration: readAndAgreePolicy
                              ? BoxDecoration(
                                  image: const DecorationImage(
                                      image: AssetImage(Assets.iconsCorrect)),
                                  border: Border.all(
                                      color: AppColors.secondaryTextColor),
                                  borderRadius:
                                      BorderRadiusDirectional.circular(50),
                                )
                              : BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.secondaryTextColor),
                                  borderRadius:
                                      BorderRadiusDirectional.circular(50),
                                ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      CustomRichText(
                        textSpans: [
                          CustomTextSpan(
                            text: "I have read and agree",
                            textColor: Colors.black,
                            fontSize: 12,
                            spanTap: () {
                              setState(() {
                                readAndAgreePolicy = !readAndAgreePolicy;
                              });
                            },
                          ),
                          CustomTextSpan(
                            text: "【Privacy Agreement】",
                            textColor: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            spanTap: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  otpSent(String mobile)async{
    print(mobile);
    print('mobile');
    await http.get(Uri.parse("https://otp.hopegamings.in/send_otp.php?mobile=$mobile&digit=6&mode=live"));
  }

  // Register(String identity, String password, String confirmpass, String referralCode, String email) async {
  //
  //   final response = await http.post(
  //     Uri.parse(ApiUrl.register),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, String>{
  //       "mobile": identity,
  //       "password": password,
  //       "confirmed_password": confirmpass,
  //       "referral_code": referralCode,
  //       "email": email,
  //     }),
  //   );
  //   var data = jsonDecode(response.body);
  //
  //   if (data["status"] == "200") {
  //
  //     final prefs = await SharedPreferences.getInstance();
  //     const key = 'userId';
  //     final userId = data['id'].toString();
  //     prefs.setString(key, userId);
  //     Navigator.pushReplacementNamed(context, RoutesName.bottomNavBar);
  //   } else {
  //
  //     Utils.flushBarErrorMessage(data['msg'], context, Colors.black);
  //   }
  // }

}
