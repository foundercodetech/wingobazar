

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wingo/generated/assets.dart';
import 'package:wingo/main.dart';
import 'package:wingo/model/bettingHistory_Model.dart';
import 'package:wingo/model/user_model.dart';
import 'package:wingo/res/aap_colors.dart';
import 'package:wingo/res/api_urls.dart';
import 'package:wingo/res/components/app_bar.dart';
import 'package:wingo/res/provider/user_view_provider.dart';
import 'package:wingo/view/home/lottery/WinGo/win_go_result.dart';
import 'package:http/http.dart'as http;

class MyOrderScreen extends StatefulWidget {
  final String title;
  final int type;

  const MyOrderScreen( {super.key,required this.title, required this.type});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();

}



int? responseStatuscode;
class _MyOrderScreenState extends State<MyOrderScreen> {
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

  @override
  void initState() {

    BettingHistory();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
          child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
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
        centerTitle: true,
      ),
      body: responseStatuscode==400
          ?const Center(child: Text('No Data Found'))
          :items.isEmpty?const Center(child: CircularProgressIndicator()):
      ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
           height: 50,
            width: 400,
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Period',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  'Select',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  'Result',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  'Amount',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 8, 0),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount:items.length,
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
                  }  else if (items[index].number == '10') {
                    colors = [
                      const Color(0xFF40ad72),
                      const Color(0xFF40ad72),

                    ];
                  }  else if (items[index].number == '20') {
                    colors = [

                      const Color(0xFFb659fe),
                      const Color(0xFFb659fe),
                    ];
                  }  else if (items[index].number == '30') {
                    colors = [
                      const Color(0xFFfd565c),
                      const Color(0xFFfd565c),
                    ];
                  }  else if (items[index].number == '40') {
                    colors = [
                      const Color(0xFF40ad72),
                      const Color(0xFF40ad72),

                    ];
                  }  else if (items[index].number == '50') {
                    colors = [
                      //blue
                      const Color(0xFF6da7f4),
                      const Color(0xFF6da7f4)
                    ];
                  } else {
                    int number = int.parse(items[index].number.toString());
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
                            width: width / 4.3,
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
      ),
    );
  }

  UserViewProvider userProvider = UserViewProvider();

  List<BettingHistoryModel> items = [];

  Future<void> BettingHistory() async {
    var gameid= widget.type;
    UserModel user = await userProvider.getUser();
    String token = user.id.toString();
    final response = await http.get(
      Uri.parse('${ApiUrl.betHistory}$token&limit=500&gameid=$gameid'),
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
}


class BetNumbers {
  String photo;
  final Color colorone;
  final Color colortwo;
  String number;
  BetNumbers(this.photo, this.colorone, this.colortwo, this.number);
}