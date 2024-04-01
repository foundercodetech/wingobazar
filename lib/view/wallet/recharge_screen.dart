import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wingo/main.dart';
import 'package:wingo/model/user_model.dart';
import 'package:wingo/res/aap_colors.dart';
import 'package:wingo/res/components/app_bar.dart';
import 'package:wingo/res/components/app_btn.dart';
import 'package:wingo/res/components/text_widget.dart';
import 'package:wingo/res/helper/api_helper.dart';
import 'package:wingo/res/provider/user_view_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wingo/utils/utils.dart';
import 'package:wingo/view/wallet/deposit_history.dart';
import 'package:wingo/view/wallet/depositweb.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../res/api_urls.dart';
import '../../res/provider/wallet_provider.dart';

class RechargeScreen extends StatefulWidget {
  const RechargeScreen({super.key});

  @override
  State<RechargeScreen> createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  BaseApiHelper baseApiHelper = BaseApiHelper();

  @override
  void initState() {
    walletFetch();
    super.initState();
  }

  TextEditingController selectCon = TextEditingController();

  List<RupeesModel> itemRupees = [
    RupeesModel('500'),
    RupeesModel('1000'),
    RupeesModel('2000'),
    RupeesModel('5000'),
    RupeesModel('10000'),
    RupeesModel('20000'),
    RupeesModel('50000'),
    RupeesModel('100000'),
  ];

  void updateTextField(String value) {
    selectCon.text = value;
  }

  @override
  Widget build(BuildContext context) {
    final walletdetails = Provider.of<WalletProvider>(context).walletlist;

    _launchURL() async {
      var url = 'https://telegram.me/wingobazaar';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
      appBar: GradientAppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DepositHistory()));
              },
              child: textWidget(
                  text: 'Records',
                  fontSize: 15,
                  color: AppColors.primaryTextColor),
            ),
            textWidget(
                text: 'Recharge',
                fontSize: 25,
                color: AppColors.primaryTextColor),
            InkWell(
              onTap: () {
                _launchURL();
              },
              child: textWidget(
                  text: 'Help',
                  fontSize: 15,
                  color: AppColors.primaryTextColor),
            ),
          ],
        ),
        gradient: AppColors.primaryGradient,
        centerTitle: true,
      ),
      body: walletdetails != null
          ? Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      height: 135,
                      width: width,
                      decoration: const BoxDecoration(
                          gradient: AppColors.primaryGradient),
                      child: Column(
                        children: [
                          textWidget(
                            text: 'Balance',
                            color: AppColors.primaryTextColor,
                            fontSize: 17,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.currency_rupee,
                                  size: 20, color: AppColors.iconSecondColor),
                              textWidget(
                                  text: walletdetails.wallet.toString(),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: AppColors.primaryTextColor),
                            ],
                          ),
                          const SizedBox(height: 40)
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                    top: height * 0.12,
                    child: Container(
                        height: height * 0.50,
                        width: width * 0.95,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadiusDirectional.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '₹ Amount',
                                style: TextStyle(fontSize: 20),
                              ),
                              TextFormField(
                                controller: selectCon,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    hintText: '500 - 100000',
                                    prefixIcon: Icon(Icons.currency_rupee)),
                                style: const TextStyle(fontSize: 25),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: itemRupees.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        crossAxisSpacing: 2,
                                        mainAxisSpacing: 5,
                                        childAspectRatio: 2),
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        updateTextField(
                                            itemRupees[index].rupees);
                                      });
                                    },
                                    child: Container(
                                      height: 58,
                                      width: 60,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.3),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Text(
                                        '₹' + itemRupees[index].rupees,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  );
                                }, //EdgeInsets.fromLTRB(1,25,1,25),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              AppBtn(
                                loading: _loading,
                                onTap: () {
                                  addmony(selectCon.text);
                                },
                                title: 'Recharge',
                              )
                            ],
                          ),
                        ))),
              ],
            )
          : Container(),
    );
  }

  bool _loading = false;
  UserViewProvider userProvider = UserViewProvider();
  addmony(String depositCon) async {
    setState(() {
      _loading = true;
    });
    print(depositCon);
    UserModel user = await userProvider.getUser();
    String token = user.id.toString();
    print(ApiUrl.deposit);
    final response = await http.post(
      Uri.parse(ApiUrl.deposit),
      body: jsonEncode(
          <String, String>{"userid": token, "amount": depositCon, "type": '1'}),
    );
    try {
      final data = jsonDecode(response.body);
      print(data);
      if (data["status"] == 'SUCCESS') {
        var url = data['payment_link'].toString();
        print('saijfiosdjgiosg');
        setState(() {
          _loading = false;
        });
        print(url);

        if (kIsWeb) {
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Could not launch URL'),
              ),
            );
          }
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => payment_Web(
                        url: url,
                      )));
        }
        //Utils.flushBarSuccessMessage(data["msg"],context, Colors.white);
      } else {
        Fluttertoast.showToast(msg: data['msg']);
        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
      Fluttertoast.showToast(msg: 'Something went wrong\n    try again');
    }
  }

  Future<void> walletFetch() async {
    try {
      if (kDebugMode) {
        print("qwerfghj");
      }
      final wallet_data = await baseApiHelper.fetchWalletData();
      if (kDebugMode) {
        print(wallet_data);
        print("wallet_data");
      }
      Provider.of<WalletProvider>(context, listen: false)
          .setWalletList(wallet_data!);
    } catch (error) {
      // Handle error here
      if (kDebugMode) {
        print("hiiii $error");
      }
    }
  }

  Widget itemWidget(Function()? onTap, String image, String title) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(image, height: 50),
          const SizedBox(height: 10),
          textWidget(
              text: title,
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: AppColors.secondaryTextColor),
        ],
      ),
    );
  }
}

class RupeesModel {
  final String rupees;
  RupeesModel(this.rupees);
}
