// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'package:wingo/main.dart';
import 'package:wingo/model/bettingHistory_Model.dart';
import 'package:wingo/model/user_model.dart';
import 'package:wingo/res/api_urls.dart';
import 'package:wingo/res/helper/api_helper.dart';
import 'package:wingo/res/provider/user_view_provider.dart';
import 'package:wingo/res/provider/wallet_provider.dart';
import 'package:wingo/view/DummyGrid.dart';
import 'package:wingo/view/bottom/bottom_nav_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:wingo/generated/assets.dart';
import 'package:wingo/res/aap_colors.dart';
import 'package:wingo/res/components/app_bar.dart';
import 'package:wingo/res/components/commonbottomsheet.dart';
import 'package:wingo/res/components/text_widget.dart';
import 'package:wingo/view/home/lottery/WinGo/more_screen.dart';
import 'package:wingo/view/home/lottery/WinGo/my_order.dart';
import 'package:wingo/view/home/lottery/WinGo/win_go_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class WinGoScreen extends StatefulWidget {
  final int type;
  final String title;
  const WinGoScreen(this.type, this.title, {super.key});

  @override
  _WinGoScreenState createState() => _WinGoScreenState();
}

class _WinGoScreenState extends State<WinGoScreen>
    with SingleTickerProviderStateMixin {
  late int selectedCatIndex;

  @override
  void initState() {
    startCountdown();
    walletfetch();
    partelyRecord();
    Partelyrecords();
    BettingHistory();
    super.initState();
    selectedCatIndex = 0;
  }

  int selectedContainerIndex = -1;

  List<BetNumbers> betNumbers = [
    BetNumbers(Assets.images0, Colors.red, Colors.purple, "0"), //
    BetNumbers(Assets.images1, Colors.green, Colors.green, "1"),
    BetNumbers(Assets.images2, Colors.red, Colors.red, "2"),
    BetNumbers(Assets.images3, Colors.green, Colors.green, "3"),
    BetNumbers(Assets.images4, Colors.red, Colors.red, "4"),
    BetNumbers(Assets.images5, Colors.red, Colors.purple, "5"), //
    BetNumbers(Assets.images6, Colors.red, Colors.red, "6"),
    BetNumbers(Assets.images7, Colors.green, Colors.green, "7"),
    BetNumbers(Assets.images8, Colors.red, Colors.red, "8"),
    BetNumbers(Assets.images9, Colors.green, Colors.green, "9"),
  ];

  int countdownSeconds = 60;
  int gameseconds = 60;
  String gametitle = 'Wingo';
  String subtitle = '1 Min';
  Timer? countdownTimer;

  Future<void> startCountdown() async {
    DateTime now = DateTime.now().toUtc();
    int minutes = now.minute;
    int minsec = minutes * 60;
    int initialSeconds = 60;
    setState(() {
      gameseconds = widget.type == 1 ? 60 : 120;
    });
    if (gameseconds == 60) {
      initialSeconds = gameseconds - now.second;
    } else if (gameseconds == 120) {
      for (var i = 0; i < 30; i++) {
        if (minsec >= 120) {
          minsec = minsec - 120;
        } else {
          initialSeconds = gameseconds - minsec - now.second;
        }
        print(initialSeconds);
      }
    }
    setState(() {
      countdownSeconds = initialSeconds;
    });
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      gameconcept(countdownSeconds);
      updateUI(timer);
    });
  }

  void updateUI(Timer timer) {
    setState(() {
      if (countdownSeconds == 5) {
      } else if (countdownSeconds == 0) {
        countdownSeconds = gameseconds;
        walletfetch();
        partelyRecord();
        Partelyrecords();
        BettingHistory();
      }
      countdownSeconds = (countdownSeconds - 1);
    });
  }

  int? responseStatuscode;

  @override
  void dispose() {
    countdownSeconds.toString();
    // TODO: implement dispose
    super.dispose();
  }
  void rebuild() {
    setState(() {});
    BettingHistory();
  }
  @override
  Widget build(BuildContext context) {
    final gameId = widget.type;
    return Scaffold(
        appBar: GradientAppBar(
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
            child: GestureDetector(
                onTap: () {
                  countdownTimer!.cancel();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BottomNavBar()));
                },
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 30,
                )),
          ),
          title: Text(
            widget.title,
            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 25),
          ),
          gradient: AppColors.primaryGradient,
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(Assets.imagesBgCut),
                            fit: BoxFit.fill)),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                // Navigator.push(context, MaterialPageRoute(builder: (context)=>const HowtoplayScreen()));
                              },
                              child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  height: 26,
                                  width: width * 0.35,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                          color:
                                              AppColors.ContainerBorderWhite)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        Assets.iconsHowtoplay,
                                        height: 16,
                                      ),
                                      const Text(
                                        ' How to Play',
                                        style: TextStyle(
                                            color: AppColors.primaryTextColor),
                                      ),
                                    ],
                                  )),
                            ),
                            Text(
                              gameId == 1 ? 'Wingo 1 Min' : 'Wingo 2 Min',
                              style: const TextStyle(
                                  color: AppColors.primaryTextColor),
                            ),
                            // _listdata.isEmpty
                            //     ? Container()
                            //     : Row(
                            //         mainAxisAlignment:
                            //             MainAxisAlignment.spaceEvenly,
                            //         children: List.generate(
                            //           5,
                            //           (index) => Padding(
                            //             padding: const EdgeInsets.all(2.0),
                            //             child: Image(
                            //               image: AssetImage(betNumbers[
                            //                       int.parse(
                            //                           _listdata[index].number)]
                            //                   .photo),
                            //               height: 25,
                            //             ),
                            //           ),
                            //         ))
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            const Text(
                              'Time Remaining',
                              style: TextStyle(
                                  color: AppColors.primaryTextColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            buildTime1(countdownSeconds),
                            Text(
                              period.toString(),
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryTextColor),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  create == false
                      ? Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(25),
                                                  topLeft:
                                                      Radius.circular(25))),
                                          context: (context),
                                          builder: (context) {
                                            return CommonBottomSheet(
                                                colors: const [
                                                  Colors.green,
                                                  Colors.green
                                                ],
                                                colorName: "Green",
                                                predictionType: "10",
                                                gameid: gameId);
                                          }).then((value) => rebuild());
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 80,
                                      width: width * 0.28,
                                      decoration: const BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10))),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          // const Image(image: AssetImage(Assets.iconsRocket),height: 40,color: Colors.green,),
                                          Image.asset(
                                            Assets.iconsRocket,
                                            height: 40,
                                          ),
                                          textWidget(
                                              text: 'Green',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  AppColors.primaryTextColor),
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(25),
                                                  topLeft:
                                                      Radius.circular(25))),
                                          context: (context),
                                          builder: (context) {
                                            return CommonBottomSheet(
                                              colors: const [
                                                Colors.purple,
                                                Colors.purple
                                              ],
                                              colorName: "Violet",
                                              predictionType: "20",
                                              gameid: gameId,
                                            );
                                          }).then((value) => rebuild());
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 80,
                                      width: width * 0.28,
                                      decoration: const BoxDecoration(
                                          color: Colors.purple,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Image.asset(
                                            Assets.iconsRocket,
                                            height: 40,
                                          ),
                                          textWidget(
                                              text: 'Violet',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  AppColors.primaryTextColor),
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(25),
                                                  topLeft:
                                                      Radius.circular(25))),
                                          context: (context),
                                          builder: (context) {
                                            return CommonBottomSheet(
                                              colors: const [
                                                Colors.red,
                                                Colors.red
                                              ],
                                              colorName: "Red",
                                              predictionType: "30",
                                              gameid: gameId,
                                            );
                                          }).then((value) => rebuild());
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 80,
                                      width: width * 0.28,
                                      decoration: const BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomRight:
                                                  Radius.circular(10))),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Image.asset(
                                            Assets.iconsRocket,
                                            height: 40,
                                          ),
                                          textWidget(
                                              text: 'Red',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  AppColors.primaryTextColor),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 10, right: 10),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 3),
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.2),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5,
                                    crossAxisSpacing: 8.0,
                                    mainAxisSpacing: 8.0,
                                  ),
                                  shrinkWrap: true,
                                  itemCount: 10,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(25),
                                                    topLeft:
                                                        Radius.circular(25))),
                                            context: (context),
                                            builder: (context) {
                                              return CommonBottomSheet(
                                                colors: [
                                                  betNumbers[index].colorone,
                                                  betNumbers[index].colortwo
                                                ],
                                                colorName: betNumbers[index]
                                                    .number
                                                    .toString(),
                                                predictionType:
                                                    betNumbers[index]
                                                        .number
                                                        .toString(),
                                                gameid: gameId,
                                              );
                                            }).then((value) => rebuild());
                                      },
                                      child: Image(
                                        image: AssetImage(
                                            betNumbers[index].photo.toString()),
                                        height: height / 15,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        )
                      : Stack(
                          children: [
                            const DummyGrid(),
                            Container(
                              height: 250,
                              color: Colors.black26,
                              child: buildTime5sec(countdownSeconds),
                            ),
                          ],
                        ),
                  const SizedBox(height: 15),
                  WinGoResult()
                ],
              ),
            ],
          ),
        ));
  }

  bool create = false;
  int period = 0;

  final List<pertRecord> _listdata = [];
  partelyRecord() async {
    final gameid = widget.type;

    print("${ApiUrl.colorresult}limit=5&gameid=$gameid");
    final response = await http
        .get(Uri.parse("${ApiUrl.colorresult}limit=1&gameid=$gameid"));
    print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      _listdata.clear();
      final jsonData = json.decode(response.body)['data'];
      setState(() {
        period = int.parse(jsonData[0]['gamesno'].toString()) + 1;
      });
      for (var i = 0; i < jsonData.length; i++) {
        var period = jsonData[i]['gamesno'];
        var number = jsonData[i]['number'];
        _listdata.add(pertRecord(period, number));
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  int pageNumber = 1;
  int selectedTabIndex = 0;

  Widget WinGoResult() {
    setState(() {});

    if (_listdataResult != []) {
      return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: width,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '  ${widget.title} Record',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 25,
                              color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MoreScreen(
                                        title: 'Fast-Parity Record',
                                        gameId: widget.type)));
                          },
                          child: const Text(
                            ' more > ',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        )
                      ],
                    )),
              ),
              Container(
                height: 2,
                width: 370,
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  height: height*0.25,
                  width: width,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child: _listdataResult.isEmpty?Center(child: const CircularProgressIndicator()):
                  GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 10,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _listdataResult.length,
                    itemBuilder: (context, index) {
                      List<String> dta = _listdataResult[index]
                          .period
                          .split('')
                          .reversed
                          .toList();
                      String periods = dta[2] + dta[1] + dta[0];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image(
                            image: AssetImage(betNumbers[int.parse(
                                    _listdataResult[index].number)]
                                .photo
                                .toString()),
                            height: 20,
                          ),
                          Text(
                            periods,
                            style: const TextStyle(fontSize: 8),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: width,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          ' My Order',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyOrderScreen(
                                          type: widget.type,
                                          title: 'My Order',
                                        )));
                          },
                          child: const Text(
                            ' more > ',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        )
                      ],
                    )),
              ),
              Container(
                height: 2,
                width: 370,
                color: Colors.black,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                height: 50,
                width: 400,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Period',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'Select',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'Result',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                    Text(
                      'Amount',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              Container(
                height: 1,
                width: 370,
                color: Colors.black,
              ),
              responseStatuscode == 400
                  ? const Center(child: Text('No Data Found'))
                  : items.isEmpty?Center(child: CircularProgressIndicator()):
              Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 8, 0),
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            List<Color> colors;

                            if (items[index].number == '0') {
                              colors = [
                                const Color(0xFFfd565c),
                                const Color(0xFFb659fe),
                              ];
                            } else if (items[index].number == '5') {
                              colors = [
                                const Color(0xFF40ad72),
                                const Color(0xFFb659fe),
                              ];
                            } else if (items[index].number == '10') {
                              colors = [
                                const Color(0xFF40ad72),
                                const Color(0xFF40ad72),
                              ];
                            } else if (items[index].number == '20') {
                              colors = [
                                const Color(0xFFb659fe),
                                const Color(0xFFb659fe),
                              ];
                            } else if (items[index].number == '30') {
                              colors = [
                                const Color(0xFFfd565c),
                                const Color(0xFFfd565c),
                              ];
                            } else if (items[index].number == '40') {
                              colors = [
                                const Color(0xFF40ad72),
                                const Color(0xFF40ad72),
                              ];
                            } else if (items[index].number == '50') {
                              colors = [
                                //blue
                                const Color(0xFF6da7f4),
                                const Color(0xFF6da7f4)
                              ];
                            } else {
                              int number =
                                  int.parse(items[index].number.toString());
                              colors = number.isOdd
                                  ? [
                                      const Color(0xFF40ad72),
                                      const Color(0xFF40ad72),
                                    ]
                                  : [
                                      const Color(0xFFfd565c),
                                      const Color(0xFFfd565c),
                                    ];
                            }
                            return Column(
                              children: [
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: width / 4.5,
                                      child: Text(
                                        items[index].gamesno.toString(),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 4.5,
                                      child: Center(
                                        child: GradientText(
                                          items[index].number == '10'
                                              ? 'G'
                                              : items[index].number == '20'
                                                  ? 'V'
                                                  : items[index].number == '30'
                                                      ? 'R'
                                                      : items[index]
                                                          .number
                                                          .toString(),
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w900),
                                          gradient: LinearGradient(
                                              colors: colors,
                                              stops: const [
                                                0.5,
                                                0.5,
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              tileMode: TileMode.mirror),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    items[index].result == null
                                        ? SizedBox(
                                            height: height / 20,
                                            width: width / 4.5,
                                          )
                                        : Container(
                                            padding: const EdgeInsets.all(2),
                                            alignment: Alignment.center,
                                            width: width / 4.5,
                                            child: items[index]
                                .result=="Pending"?const Text('Pending',style: TextStyle(color: Colors.yellow),):

                                            Image(
                                              image: AssetImage(betNumbers[
                                                      int.parse(items[index]
                                                          .result
                                                          .toString())]
                                                  .photo
                                                  .toString()),
                                              height: 32,
                                            ),
                                          ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      width: width / 4.5,
                                      child: Text(
                            items[index]
                                .result=="Pending"?'':
                                        items[index].win == null
                                            ? ' - '+ items[index].amount.toString()
                                            : ' + '+items[index].win.toString(),
                                        style:  TextStyle(
                                            fontSize: 18,
                                            color: items[index].win != null?Colors.green:Colors.red,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 0.2,
                                  width: 370,
                                  color: Colors.black,
                                ),
                              ],
                            );
                          }),
                    ),

            ],
          );
    } else {
      return Container();
    }
  }

  Widget buildTabContainer(
      String label, int index, double widths, Color selectedTextColor) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedTabIndex = index;
        });
      },
      child: Container(
        height: 40,
        width: widths / 3.3,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: selectedTabIndex == index
                ? Colors.red
                : Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8)),
        child: Text(
          label,
          style: TextStyle(
            fontSize: widths / 24,
            fontWeight:
                selectedTabIndex == index ? FontWeight.bold : FontWeight.w500,
            color: selectedTabIndex == index ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  UserViewProvider userProvider = UserViewProvider();

  List<BettingHistoryModel> items = [];

  Future<void> BettingHistory() async {
    var gameid = widget.type;
    UserModel user = await userProvider.getUser();
    String token = user.id.toString();
    final response = await http.get(
      Uri.parse('${ApiUrl.betHistory}$token&limit=10&gameid=$gameid'),
    );
    print('${ApiUrl.betHistory}$token&limit=10&gameid=1');
    print('betHistory+token');

    setState(() {
      responseStatuscode = response.statusCode;
    });

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];
      setState(() {
        items = responseData
            .map((item) => BettingHistoryModel.fromJson(item))
            .toList();
      });
    } else if (response.statusCode == 400) {
      if (kDebugMode) {
        print('Data not found');
      }
    } else {
      setState(() {
        items = [];
      });
      throw Exception('Failed to load data');
    }
  }

  BaseApiHelper baseApiHelper = BaseApiHelper();

  Future<void> walletfetch() async {
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

  gameconcept(int countdownSeconds) {
    if (countdownSeconds == 10) {
      setState(() {
        create = true;
      });
      print('5 sec left');
    } else if (countdownSeconds == 0) {
      setState(() {
        create = false;
      });

      print('0 sec left');
    } else {}
  }

  List<GameHistoryModel> _listdataResult = [];

  Partelyrecords() async {
    final gameid = widget.type;
    print("${ApiUrl.colorresult}limit=30&gameid=$gameid");
    final response = await http.get(Uri.parse(
      "${ApiUrl.colorresult}limit=30&gameid=$gameid",
    ));
    print('pankaj');
    print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      _listdataResult.clear();
      final jsonData = json.decode(response.body)['data'];
      for (var i = 0; i < jsonData.length; i++) {
        var period = jsonData[i]['gamesno'];
        var number = jsonData[i]['number'];
        print(period);
        _listdataResult.add(GameHistoryModel(
            period: period.toString(), number: number.toString()));
      }
      setState(() {});
      // return jsonData.map((item) => partlyrecord.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}

Widget buildTime1(int time) {
  Duration myDuration = Duration(seconds: time);
  String strDigits(int n) => n.toString().padLeft(2, '0');
  final minutes = strDigits(myDuration.inMinutes.remainder(11));
  final seconds = strDigits(myDuration.inSeconds.remainder(60));
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    buildTimeCard(time: minutes[0].toString(), header: 'MINUTES'),
    const SizedBox(
      width: 3,
    ),
    buildTimeCard(time: minutes[1].toString(), header: 'MINUTES'),
    const SizedBox(
      width: 3,
    ),
    buildTimeCard(time: ':', header: 'MINUTES'),
    const SizedBox(
      width: 3,
    ),
    buildTimeCard(time: seconds[0].toString(), header: 'SECONDS'),
    const SizedBox(
      width: 3,
    ),
    buildTimeCard(time: seconds[1].toString(), header: 'SECONDS'),
  ]);
}

Widget buildTimeCard({required String time, required String header}) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Text(
            time,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
          ),
        ),
      ],
    );

Widget buildTime5sec(int time) {
  Duration myDuration = Duration(seconds: time);
  String strDigits(int n) => n.toString().padLeft(2, '0');
  final seconds = strDigits(myDuration.inSeconds.remainder(60));
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    buildTimeCard5sec(time: seconds[0].toString(), header: 'SECONDS'),
    const SizedBox(
      width: 15,
    ),
    buildTimeCard5sec(time: seconds[1].toString(), header: 'SECONDS'),
  ]);
}

Widget buildTimeCard5sec({required String time, required String header}) =>
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
              color: Colors.red, borderRadius: BorderRadius.circular(10)),
          child: Text(
            time,
            style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 100),
          ),
        )
      ],
    );

class TimeDigit extends StatelessWidget {
  final int value;
  const TimeDigit({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(5),
      child: Text(
        value.toString(),
        style: const TextStyle(
          color: Colors.red,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class Winlist {
  int gameid;
  String title;
  String subtitle;
  int time;

  Winlist(this.gameid, this.title, this.subtitle, this.time);
}

class BetNumbers {
  String photo;
  final Color colorone;
  final Color colortwo;
  String number;
  BetNumbers(this.photo, this.colorone, this.colortwo, this.number);
}

class pertRecord {
  final String period;
  final String number;
  // final Color color;
  pertRecord(this.period, this.number);
}

class Notfounddata extends StatelessWidget {
  const Notfounddata({super.key});

  @override
  Widget build(BuildContext context) {
    final heights = MediaQuery.of(context).size.height;
    final widths = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: const AssetImage(Assets.imagesNoDataAvailable),
          height: heights / 3,
          width: widths / 2,
        ),
        SizedBox(height: heights * 0.07),
        const Text(
          "Data not found",
        )
      ],
    );
  }
}

List<Widget> generateNumberWidgets(int parse) {
  return List.generate(10, (index) {
    List<Color> colors = [
      const Color(0xFFFFFFFF),
      const Color(0xFFFFFFFF),
    ];

    if (index == parse) {
      if (parse == 0) {
        colors = [
          const Color(0xFFfd565c),
          const Color(0xFFb659fe),
        ];
      } else if (parse == 5) {
        colors = [
          const Color(0xFF40ad72),
          const Color(0xFFb659fe),
        ];
      } else {
        colors = parse % 2 == 0
            ? [
                const Color(0xFFfd565c),
                const Color(0xFFfd565c),
              ]
            : [
                const Color(0xFF40ad72),
                const Color(0xFF40ad72),
              ];
      }
    }

    return Container(
      height: 20,
      width: 20,
      margin: const EdgeInsets.all(2),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(),
        gradient: LinearGradient(
            colors: colors,
            stops: const [
              0.5,
              0.5,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            tileMode: TileMode.mirror),
      ),
      child: textWidget(
        text: '$index',
        fontWeight: FontWeight.w600,
        color: index == parse ? AppColors.primaryTextColor : Colors.black,
      ),
    );
  });
}
