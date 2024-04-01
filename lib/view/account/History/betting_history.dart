import 'dart:convert';

import 'package:wingo/model/bettingHistory_Model.dart';
import 'package:wingo/model/user_model.dart';
import 'package:wingo/res/aap_colors.dart';
import 'package:wingo/res/components/app_bar.dart';
import 'package:wingo/res/components/app_btn.dart';
import 'package:wingo/res/components/clipboard.dart';
import 'package:wingo/res/components/text_widget.dart';
import 'package:wingo/res/provider/user_view_provider.dart';
import 'package:wingo/view/home/lottery/WinGo/win_go_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../generated/assets.dart';
import '../../../res/api_urls.dart';
import 'package:http/http.dart' as http;


class BetHistory extends StatefulWidget {
  const BetHistory({super.key});

  @override
  State<BetHistory> createState() => _BetHistoryState();
}

class _BetHistoryState extends State<BetHistory> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    BettingHistory();
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    selectedCatIndex = 0;
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);
  }

  int ?responseStatuscode;


  Future<void> _toggleBottomSheet() async {
    if (_controller.status == AnimationStatus.completed) {
      await _controller.reverse();
    } else {
      await _controller.forward();
    }
  }

  List<BetIconModel> betIconList = [
    BetIconModel(title: 'Lottery', image: Assets.imagesLotteryIcon),
    BetIconModel(title: 'Casino', image: Assets.imagesCasinoIcon),
    // BetIconModel(title: 'PVC', image: Assets.imagesPvcIcon),
    // BetIconModel(title: 'Original', image: Assets.imagesOriginalIcon),
    // BetIconModel(title: 'Slots', image: Assets.imagesSlotsIcon),
  ];
  late int selectedCatIndex;



  @override
  Widget build(BuildContext context) {
    final heights = MediaQuery.of(context).size.height;
    final widths = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: GradientAppBar(
          leading: AppBackBtn(),
          title: textWidget(
              text: 'Bet History',
              fontSize: 25,
              color: AppColors.primaryTextColor),
          gradient: AppColors.primaryGradient, centerTitle: true,),
      body: ListView(
        shrinkWrap: true,
        children: [


          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            height: 70,
            width: widths * 0.93,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: betIconList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCatIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      height: 35,
                      width: 115,
                      decoration: BoxDecoration(
                        gradient: selectedCatIndex == index
                            ? AppColors.containerTopToBottomGradient
                            : AppColors.secondaryGradient,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey, width: 0.1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 0.2,
                            blurRadius: 2,
                            offset: const Offset(2, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage('${betIconList[index].image}'),
                            height: 25,
                            color: selectedCatIndex == index
                                ? AppColors.primaryContColor
                                : AppColors.iconColor,
                          ),
                          textWidget(
                            text: betIconList[index].title,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: selectedCatIndex == index
                                ? AppColors.primaryContColor
                                : AppColors.secondaryTextColor,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
          const SizedBox(height: 5,),


          responseStatuscode== 400 ?
          const Notfounddata(): items.isEmpty? const Center(child: CircularProgressIndicator()):Container(),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: ListView.builder(
          //       itemCount: items.length,
          //       shrinkWrap: true,
          //       physics: const NeverScrollableScrollPhysics(),
          //       itemBuilder: (context , index){
          //         List<Color> colors;
          //
          //         if (items[index].number == '0') {
          //           colors = [
          //             const Color(0xFFfd565c),
          //             const Color(0xFFb659fe),
          //           ];
          //         } else if (items[index].number == '5') {
          //           colors = [
          //             const Color(0xFF40ad72),
          //             const Color(0xFFb659fe),
          //           ];
          //         }  else if (items[index].number == '10') {
          //           colors = [
          //             const Color(0xFF40ad72),
          //             const Color(0xFF40ad72),
          //
          //           ];
          //         }  else if (items[index].number == '20') {
          //           colors = [
          //
          //             const Color(0xFFb659fe),
          //             const Color(0xFFb659fe),
          //           ];
          //         }  else if (items[index].number == '30') {
          //           colors = [
          //             const Color(0xFFfd565c),
          //             const Color(0xFFfd565c),
          //           ];
          //         }  else if (items[index].number == '40') {
          //           colors = [
          //             const Color(0xFF40ad72),
          //             const Color(0xFF40ad72),
          //
          //           ];
          //         }  else if (items[index].number == '50') {
          //           colors = [
          //             //blue
          //             Color(0xFF6da7f4),
          //             Color(0xFF6da7f4)
          //           ];
          //         } else {
          //           int number = int.parse(items[index].number.toString());
          //           colors = number.isOdd
          //               ? [
          //             const Color(0xFF40ad72),
          //             const Color(0xFF40ad72),
          //           ]
          //               : [
          //             const Color(0xFFfd565c),
          //             const Color(0xFFfd565c),
          //           ];
          //         }
          //
          //         return Card(
          //           elevation: 3,
          //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          //           child: Column(
          //             children: [
          //               Padding(
          //                 padding: const EdgeInsets.all(8.0),
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                   children: [
          //                     InkWell(
          //                       onTap: () {},
          //                       child: Container(
          //                         alignment: Alignment.center,
          //                         height: 35,
          //                         width: widths * 0.40,
          //                         decoration:  BoxDecoration(
          //                             color:  Colors.red,
          //                             borderRadius: BorderRadius.circular(10)
          //                         ),
          //                         child: textWidget(
          //                             text: 'Bet',
          //                             fontSize: 18,
          //                             fontWeight: FontWeight.w600,
          //                             color: AppColors.primaryTextColor),
          //                       ),
          //                     ),
          //                     textWidget(text:  items[index].status=="0"?"Pending":items[index].status=="1"?"Win":"Loss",
          //                         fontSize: widths*0.05,
          //                         fontWeight: FontWeight.w600,
          //                         color: AppColors.methodblue
          //
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //               const SizedBox(height: 4,),
          //               Padding(
          //                 padding: const EdgeInsets.all(8.0),
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                   children: [
          //                     textWidget(text: "Balance",
          //                         fontSize: widths*0.04,
          //                         fontWeight: FontWeight.w600,
          //                         color: AppColors.secondaryTextColor
          //
          //                     ),
          //                     textWidget(text: "₹${items[index].amount}",
          //                         fontSize: 14,
          //                         fontWeight: FontWeight.w600,
          //                         color: AppColors.secondaryTextColor
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //               Padding(
          //                 padding: const EdgeInsets.all(8.0),
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                   children: [
          //                     textWidget(text: "Bet-Type",
          //                         fontSize: widths*0.04,
          //                         fontWeight: FontWeight.w600,
          //                         color: AppColors.secondaryTextColor
          //                     ),
          //                     int.parse(items[index].number.toString())<=9?
          //                     Container(
          //                       alignment: Alignment.centerRight,
          //                       width: widths*0.20,
          //                       child: GradientText(
          //                         items[index].number.toString(),
          //                         style: const TextStyle(
          //                             fontSize: 40,
          //                             fontWeight: FontWeight.w900),
          //                         gradient: LinearGradient(
          //                             colors: colors,
          //                             stops: const [
          //                               0.5,
          //                               0.5,
          //                             ],
          //                             begin: Alignment.topCenter,
          //                             end: Alignment.bottomCenter,
          //                             tileMode: TileMode.mirror),
          //                       ),
          //                     ):GradientText(
          //                       items[index].number.toString()=='10'?'Green':items[index].number.toString()=='20'?'Voilet':items[index].number.toString()=='30'?'Red':items[index].number.toString()=='40'?'Big':items[index].number.toString()=='50'?'Small':'',
          //                       style: const TextStyle(
          //                           fontSize: 20,
          //                           fontWeight: FontWeight.w900),
          //                       gradient: LinearGradient(
          //                           colors: colors,
          //                           stops: const [
          //                             0.5,
          //                             0.5,
          //                           ],
          //                           begin: Alignment.topCenter,
          //                           end: Alignment.bottomCenter,
          //                           tileMode: TileMode.mirror),
          //                     ),
          //
          //
          //
          //                     // Text(),
          //
          //
          //                   ],
          //                 ),
          //               ),
          //               Padding(
          //                 padding: const EdgeInsets.all(8.0),
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                   children: [
          //                     textWidget(text: "Type",
          //                         fontSize: widths*0.04,
          //                         fontWeight: FontWeight.w600,
          //                         color: AppColors.secondaryTextColor
          //                     ),
          //                     textWidget(text: items[index].gameid=="1"?"1 min":items[index].gameid=="2"?"3 min":items[index].gameid=="4"?"5 min":"10 min",
          //                         fontSize: 14,
          //                         fontWeight: FontWeight.w600,
          //                         color: AppColors.secondaryTextColor
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //               Padding(
          //                 padding: const EdgeInsets.all(8.0),
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                   children: [
          //                     textWidget(text: "Win Amount",
          //                         fontSize: widths*0.04,
          //                         fontWeight: FontWeight.w600,
          //                         color: AppColors.secondaryTextColor
          //                     ),
          //                     textWidget(text: items[index].win==null?'₹ 0.0':'₹ ${items[index].win}',
          //                         fontSize: 14,
          //                         fontWeight: FontWeight.w600,
          //                         color: AppColors.secondaryTextColor
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //               Padding(
          //                 padding: const EdgeInsets.all(8.0),
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                   children: [
          //                     textWidget(text: "Time",
          //                         fontSize: widths*0.04,
          //                         fontWeight: FontWeight.w600,
          //                         color: AppColors.secondaryTextColor
          //                     ),
          //                     textWidget(
          //                         text: DateFormat("dd-MMM-yyyy, hh:mm a").format(
          //                             DateTime.parse(items[index].datetime.toString())),
          //                         fontSize: 14,
          //                         fontWeight: FontWeight.w600,
          //                         color: AppColors.secondaryTextColor
          //
          //                     )
          //                   ],
          //                 ),
          //               ),
          //               Padding(
          //                 padding: const EdgeInsets.all(8.0),
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                   children: [
          //                     textWidget(text: "Order number",
          //                         fontSize: widths*0.04,
          //                         fontWeight: FontWeight.w600,
          //                         color: AppColors.secondaryTextColor
          //                     ),
          //                     Row(
          //                       children: [
          //                         textWidget(text: items[index].gamesno.toString(),
          //                             fontSize: 14,
          //                             fontWeight: FontWeight.w600,
          //                             color: AppColors.secondaryTextColor
          //                         ),
          //                         SizedBox(width: widths*0.01,),
          //                         InkWell(
          //                             onTap: (){
          //                               copyToClipboard(items[index].gamesno.toString(),context);
          //                             },
          //                             child: Image.asset(Assets.iconsCopy,color: Colors.grey,height: heights*0.03,)),
          //
          //                       ],
          //                     ),
          //
          //                   ],
          //                 ),
          //               ),
          //
          //             ],
          //           ),
          //         );
          //
          //       }),
          // ),
          // textWidget(text: "No more",
          //     fontSize: 15,
          //     textAlign: TextAlign.center,
          //     fontWeight: FontWeight.w600,
          //     color: AppColors.secondaryTextColor
          // ),
          // Image(
          //   image: const AssetImage(Assets.imagesNoDataAvailable),
          //   height: heights / 3,
          //   width: widths / 2,
          // )
        ],
      ),
      bottomSheet: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return _buildBottomSheet();
        },
      ),
    );
  }


  UserViewProvider userProvider = UserViewProvider();

  List<BettingHistoryModel> items = [];

  Future<void> BettingHistory() async {
    UserModel user = await userProvider.getUser();
    String token = user.id.toString();

    final response = await http.get(Uri.parse(ApiUrl.betHistory+token),);
    print(ApiUrl.betHistory+token);
    print('betHistory+token');

    setState(() {
      responseStatuscode = response.statusCode;
    });

    if (response.statusCode==200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];
      setState(() {
        items = responseData.map((item) => BettingHistoryModel.fromJson(item)).toList();
      });

    }
    else if(response.statusCode==400){
      if (kDebugMode) {
        print('Data not found');
      }
    }
    else {
      setState(() {
        items = [];
      });
      throw Exception('Failed to load data');
    }
  }




  Widget _buildBottomSheet() {
    return Container(
      height: _animation.value * 300,
      width: 400,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            _buildBottomSheetHeader(),
            SizedBox(height: 200, child: _buildMonthPicker()),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(onPressed: (){}, child: const Text('Cancel',style: TextStyle(color: AppColors.secondaryTextColor,fontSize: 14),),),
        TextButton(onPressed: (){}, child: const Text('Choose a date',style: TextStyle(color: Colors.black,fontSize: 14),),),
        TextButton(onPressed: (){}, child:  const Text('Confirm',style: TextStyle(color: AppColors.secondaryTextColor,fontSize: 14),),),
      ],
    );
  }

  static const kButtonTextStyle =
  TextStyle(fontSize: 12, color: AppColors.secondaryTextColor);
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildMonthPicker() {
    return Row(
      children: [
        Expanded(
          child: CupertinoPicker(
            scrollController: FixedExtentScrollController(
              initialItem: _selectedDate.day - 1,
            ),
            itemExtent: 35,
            onSelectedItemChanged: (dayIndex) {
              setState(() {
                _selectedDate = DateTime(
                    _selectedDate.year, _selectedDate.month, dayIndex + 1);
              });
            },
            children: List.generate(
              _getMaxDaysInMonth(_selectedDate.year, _selectedDate.month),
                  (dayIndex) {
                return Center(
                  child: Text(
                    (dayIndex + 1).toString(),
                    style: const TextStyle(fontSize: 18),
                  ),
                );
              },
            ),
          ),
        ),
        Expanded(
          child: CupertinoPicker(
            scrollController: FixedExtentScrollController(
              initialItem: _selectedDate.month - 1,
            ),
            itemExtent: 40,
            onSelectedItemChanged: (monthIndex) {
              setState(() {
                _selectedDate = DateTime(_selectedDate.year, monthIndex + 1, 1);
              });
            },
            children: List.generate(12, (monthIndex) {
              return Center(
                child: Text(
                  DateFormat('M')
                      .format(DateTime(_selectedDate.year, monthIndex + 1, 1)),
                  style: const TextStyle(fontSize: 18),
                ),
              );
            }),
          ),
        ),
        Expanded(
          child: CupertinoPicker(
            scrollController: FixedExtentScrollController(
              initialItem: _selectedDate.year - 2003, // Adjust the initial year
            ),
            itemExtent: 40,
            onSelectedItemChanged: (yearIndex) {
              setState(() {
                _selectedDate = DateTime(
                    2023 + yearIndex, _selectedDate.month, _selectedDate.day);
              });
            },
            children: List.generate(2024 + 1 - 2003, (yearIndex) {
              final year = 2003 + yearIndex;
              return Center(
                child: Text(
                  year.toString(),
                  style: const TextStyle(fontSize: 18),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  int _getMaxDaysInMonth(int year, int month) {
    if (month == 2) {
      // February
      return DateTime(year, month + 1, 0).day;
    } else {
      // Other months
      const List<int> daysInMonth = [
        0,
        31,
        28,
        31,
        30,
        31,
        30,
        31,
        31,
        30,
        31,
        30,
        31
      ];
      return daysInMonth[month];
    }
  }
}

class Notfounddata extends StatelessWidget {
  const Notfounddata({super.key});

  @override
  Widget build(BuildContext context){
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
        SizedBox(height: heights*0.07),
        const Text("Data not found",)
      ],
    );
  }

}


class BetIconModel {
  final String title;
  final String? image;
  BetIconModel({required this.title, this.image});
}

class History{
  String method;
  String balance;
  String type;
  String orderno;
  History(this.method,this.balance,this.type,this.orderno);
}