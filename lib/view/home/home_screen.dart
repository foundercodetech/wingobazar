// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables, depend_on_referenced_packages

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wingo/Aviator/home_page_aviator.dart';
import 'package:wingo/generated/assets.dart';
import 'package:wingo/main.dart';
import 'package:wingo/res/aap_colors.dart';
import 'package:wingo/res/api_urls.dart';
import 'package:wingo/res/components/app_bar.dart';
import 'package:wingo/res/components/app_btn.dart';
import 'package:wingo/res/components/clipboard.dart';
import 'package:wingo/res/components/text_widget.dart';
import 'package:wingo/res/helper/api_helper.dart';
import 'package:wingo/res/provider/profile_provider.dart';
import 'package:wingo/res/provider/wallet_provider.dart';
import 'package:wingo/utils/routes/routes_name.dart';
import 'package:wingo/view/activity/attendence_bonus.dart';
import 'package:wingo/view/home/lottery/WinGo/win_go_screen.dart';
import 'package:wingo/view/home/widgets/slider_widget.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:wingo/view/wallet/recharge_screen.dart';
import 'package:wingo/view/wallet/wallet_history.dart';
import 'package:wingo/view/wallet/wallet_screen.dart';
import 'package:wingo/view/wallet/withdraw_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    versionCheck();
    fetchData();
    super.initState();
  }

  BaseApiHelper baseApiHelper = BaseApiHelper();

  Future<void> walletFetch() async {
    try {
      if (kDebugMode) {
        print("qwerfghj");
      }
      final walletData = await baseApiHelper.fetchWalletData();
      if (kDebugMode) {
        print(walletData);
        print("wallet_data");
      }
      Provider.of<WalletProvider>(context, listen: false)
          .setWalletList(walletData!);
    } catch (error) {
      // Handle error here
      if (kDebugMode) {
        print("hiiii $error");
      }
    }
  }

  int selectedCategoryIndex = 0;

  bool versionView = false;

  @override
  Widget build(BuildContext context) {
    List imageItems = [
      FinalImage(Assets.imagesFastParity, () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const WinGoScreen(1, 'Fast-Parity')));
      }),
      FinalImage(Assets.imagesParity, () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const WinGoScreen(2, 'Parity')));
      }),
      FinalImage(Assets.imagesJetX, () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>GameAviator()));

      }),
      FinalImage(Assets.imagesDice, () {}),
      FinalImage(Assets.imagesAndarBahar, () {}),
      // FinalImage(Assets.imagesCircle, () {}),

      FinalImage(Assets.imagesMineSweeper, () {}),
      // FinalImage(Assets.imagesLudo, () {}),
    ];
    final userData = Provider.of<ProfileProvider>(context).userData;

    return Scaffold(
      appBar: GradientAppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image(image: AssetImage(Assets.imagesAppBarSecond,), height: 50),
            kIsWeb==true?
          Row(
            children: [
              IconButton(
                onPressed: () {
                  _launchURL1();
                },
                icon: const Icon(Icons.download_for_offline),
              ),
              IconButton(
                onPressed: () {
                  _launchURL();
                },
                icon: const Icon(Icons.support_agent),
              )
            ],
          ):
            IconButton(
              onPressed: () {
                _launchURL();
              },
              icon: const Icon(Icons.support_agent),
            )

          ],
        ),
        gradient: AppColors.primaryGradient,
        centerTitle: true,
      ),
      body: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: userData != null
              ? SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 120,
                        width: 350,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Balance',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w300),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.currency_rupee, size: 25),
                                    textWidget(
                                        text: userData.wallet,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 25),
                                    InkWell(
                                        onTap: () {
                                          fetchData();
                                        },
                                        child: Image.asset(
                                            Assets.iconsTotalBal,height: 35,)),
                                  ],
                                ),
                                Container(
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: AppColors.gradientSecondColor,
                                    borderRadius:
                                        BorderRadiusDirectional.circular(30),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        textWidget(
                                            text: 'UID',
                                            color: AppColors.primaryTextColor,
                                            fontSize: 16),
                                        const SizedBox(width: 8),
                                        Container(
                                          width: 2,
                                          height: 18,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 8),
                                        textWidget(
                                            text: userData.custId.toString(),
                                            color: AppColors.primaryTextColor,
                                            fontSize: 16),
                                        const SizedBox(width: 8),
                                        InkWell(
                                            onTap: () {
                                              fetchData();
                                              copyToClipboard(userData.custId.toString(), context);
                                            },
                                            child:
                                                Image.asset(Assets.iconsCopy)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                AppBtn(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const RechargeScreen()
                                                // const WalletScreen()
                                        )
                                    );
                                  },
                                  title: 'Recharge',
                                  width: 90,
                                  height: 45,
                                  gradient: AppColors.blueGradient,
                                  hideBorder: true,
                                ),
                                AppBtn(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const WithdrawScreen()));
                                  },
                                  title: 'Withdraw',
                                  titleColor: Colors.black,
                                  gradient: AppColors.greyGradient,
                                  hideBorder: true,
                                  width: 90,
                                  height: 45,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const WalletHistory(
                                                name: "Bonus", type: "3")));
                              },
                              child: const SizedBox(
                                width: 130,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image(
                                      image: AssetImage(Assets.iconsTastreward),
                                      height: 45,
                                    ),
                                    Text(
                                      'Task reward',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              )),
                          SizedBox(
                            width: width / 10,
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AttendenceBonus()));
                              },
                              child: const SizedBox(
                                width: 130,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Image(
                                        image: AssetImage(Assets.iconsCheckin),
                                        height: 45),
                                    Text(
                                      'Check in',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                          onTap: () {
                            _launchURL();
                          },
                          child: const SliderWidget()),
                      SizedBox(
                        height: 730,
                        width: 350,
                        child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: imageItems.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  2, // Number of columns in the grid
                              crossAxisSpacing: 8.0, // Spacing between columns
                              mainAxisSpacing: 8.0, // Spacing between rows
                            ),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: imageItems[index].onTap,
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image:
                                            AssetImage(imageItems[index].image),
                                      )),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image(
                        image: const AssetImage(Assets.imagesNoDataAvailable),
                        height: height / 3,
                        width: width / 2,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        textWidget(text: "No data available"),
                        TextButton(
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.remove('token');
                              Navigator.pushNamed(
                                  context, RoutesName.loginScreen);
                            },
                            child: const Text("Try Again"))
                      ],
                    )
                  ],
                )),
    );
  }

  Future<void> fetchData() async {
    try {
      final userDataa = await baseApiHelper.fetchProfileData();
      print(userDataa);
      print("userData");
      if (userDataa != null) {
        Provider.of<ProfileProvider>(context, listen: false).setUser(userDataa);
      }
    } catch (error) {

      // Handle error here

    }
  }

  void showAlert(BuildContext context) {
    versionView == true
        ? showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => AlertDialog(
                  content: SizedBox(
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(
                          width: 80,
                          height: 100,
                          child:
                              Image(image: AssetImage(Assets.imagesWingoLogo)),
                        ),
                        const Text('new version are available',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )),
                        Text('Update your app  ${ApiUrl.version}  to  $map',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          _launchURL();
                          print(versionlink);
                          print("versionlink");
                        },
                        child: const Text("UPDATE"))
                  ],
                ))
        : Container();
  }

  var map;
  var versionlink;

  Future<void> versionCheck() async {
    final response = await http.get(
      Uri.parse(ApiUrl.versionlink),
    );
    print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      print(responseData);
      print('rrrrrrrr');
      if (responseData['version'] != ApiUrl.version) {
        setState(() {
          map = responseData['version'];
          versionlink = responseData['link'];
          versionView = true;
        });
      } else {
        print('Version is up-to-date');
      }
    } else {
      print('Failed to fetch version data');
    }
  }

  _launchURL() async {
    var url = 'https://telegram.me/Wingo01';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
_launchURL1() async {
  var url = "https://wingobazaar.com/apk/wingobazar.apk";
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class FinalImage {
  final String image;
  final Function() onTap;

  FinalImage(this.image, this.onTap);
}
