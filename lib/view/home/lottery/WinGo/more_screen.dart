import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wingo/generated/assets.dart';
import 'package:wingo/main.dart';
import 'package:wingo/res/aap_colors.dart';
import 'package:wingo/res/api_urls.dart';
import 'package:wingo/res/components/app_bar.dart';
import 'package:wingo/view/home/lottery/WinGo/win_go_result.dart';
import 'package:wingo/view/home/lottery/WinGo/win_go_screen.dart';
import 'package:http/http.dart'as http;

class MoreScreen extends StatefulWidget {
  final String title;
  final int gameId;

  const MoreScreen( {super.key,required this.title, required this.gameId});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}


class _MoreScreenState extends State<MoreScreen> {

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
    Partelyrecords();
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
        gradient: AppColors.primaryGradient, centerTitle: false,
      ),
      body:_listdataResult.isEmpty?const Center(child: CircularProgressIndicator()):
      ListView(
        shrinkWrap: true,
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
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  'Price',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  'Result',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 8, 0),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: _listdataResult.length,
                itemBuilder: (context, index) {
                 final listt= _listdataResult[index].period.toString().split('').toList();

                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: width / 2.5,
                              child: Text(
                                _listdataResult[index].period.toString(),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w800),
                              ),
                            ),
                            Container(
                              width: width / 2.3,
                              child: Text(
                                listt[0]+listt[1]+listt[2]+listt[3]+_listdataResult[index].number,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w800),
                              ),
                            ),
                            Image(
                              image: AssetImage(betNumbers[int.parse(
                                  _listdataResult[index].number)]
                                  .photo
                                  .toString()),
                              height: 35,
                            ),
                          ],
                        ),
                        Container(
                          height: 0.2,
                          width: 370,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
  List<GameHistoryModel> _listdataResult = [];

  Partelyrecords() async {
    final gameid=widget.gameId;
    print(
        "${ApiUrl.colorresult}limit=500&gameid=$gameid");
    final response = await http.get(Uri.parse(
      "${ApiUrl.colorresult}limit=500&gameid=$gameid",
    ));

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
