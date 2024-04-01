import 'package:wingo/generated/assets.dart';
import 'package:wingo/res/aap_colors.dart';
import 'package:wingo/res/components/app_bar.dart';
import 'package:wingo/res/components/app_btn.dart';
import 'package:wingo/res/components/text_field.dart';
import 'package:wingo/res/provider/auth_provider.dart';
import 'package:wingo/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  bool selectedButton = true;
  bool hidePassword = true;
  bool rememberPass = false;
  // bool activeButton = true;
  TextEditingController phoneCon = TextEditingController();
  TextEditingController emailCon = TextEditingController();
  TextEditingController passwordCon = TextEditingController();
  TextEditingController passwordConn = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserAuthProvider>(context);

    return Scaffold(
      appBar: const GradientAppBar(
        title: Text(
          'Login',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        leading: AppBackBtn(),
        gradient: AppColors.primaryGradient,
        centerTitle: false,
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                  child: CustomTextField(
                    onChanged: (value) {
                      if (phoneCon.text.length == 10) {}
                    },
                    prefixIcon: const Icon(
                      Icons.mobile_friendly,
                      color: Colors.red,
                    ),
                    keyboardType: TextInputType.number,
                    controller: phoneCon,
                    maxLength: 10,
                    hintText: 'Enter mobile number',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                  child: CustomTextField(
                    obscureText: hidePassword,
                    controller: passwordCon,
                    maxLines: 1,
                    hintText: 'Password (≥6 characters)',
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.red,
                    ),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                        icon: Image.asset(hidePassword
                            ? Assets.iconsEyeClose
                            : Assets.iconsEyeOpen)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                  child: AppBtn(
                      title: 'Log in',
                      fontSize: 20,
                      onTap: () {
                        if (selectedButton == true) {
                          print("object");
                          authProvider.userLogin(
                              context, phoneCon.text, passwordCon.text);
                        } else {
                          authProvider.userLogin(
                              context, emailCon.text, passwordCon.text);
                        }
                      },
                      hideBorder: true,
                      gradient: AppColors.primaryGradient),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                  child: Row(
                    children: [
                      AppBtn(
                        width: width / 2.5,
                        title: 'Create an account',
                        fontSize: 15,
                        titleColor: AppColors.gradientFirstColor,
                        onTap: () {
                          Navigator.pushNamed(
                              context, RoutesName.registerScreen,
                              arguments: '1');
                        },
                        gradient: AppColors.secondaryGradient,
                      ),
                      AppBtn(
                        width: width / 2.5,
                        title: 'Forgot password',
                        fontSize: 15,
                        titleColor: AppColors.gradientFirstColor,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            RoutesName.forgetPasswordScreen,
                          );
                        },
                        gradient: AppColors.secondaryGradient,
                      ),
                    ],
                  ), //forgetPasswordScreen
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
