
import 'package:wingo/generated/assets.dart';
import 'package:wingo/res/aap_colors.dart';
import 'package:wingo/res/components/app_bar.dart';
import 'package:wingo/res/components/app_btn.dart';
import 'package:wingo/res/components/text_widget.dart';
import 'package:flutter/material.dart';



class LevelScreen extends StatefulWidget {
  String?Name;
  final data;
   LevelScreen({ this.Name, this.data});

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {

  @override
  void initState() {
    level();
    // TODO: implement initState
    super.initState();
  }
  List<LevelModel> levelList = [];
  level(){
    print(widget.data[widget.Name]);
    if(widget.Name!=null){
    if(widget.data!=null) {
      for (var data in widget.data[widget.Name]) {
        levelList.add(LevelModel(level: data['username'].toString(),
            user: data['turnover'].toString(),
            commission: data['commission'].toStringAsFixed(2)));
      }
    }
    }
  }

  @override
  Widget build(BuildContext context) {
    final heights = MediaQuery.of(context).size.height;
    final widths = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: GradientAppBar(
          leading:const AppBackBtn(),
          title: textWidget(
              text: widget.Name.toString(), fontSize: 25, color: AppColors.primaryTextColor),
          gradient: AppColors.primaryGradient, centerTitle: false,),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          height: heights * 0.55,
          width: widths,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: heights * 0.3,
                  width: widths,
                  decoration: const BoxDecoration(
                      color: AppColors.containerBgColor,
                      image: DecorationImage(
                          image: AssetImage(Assets.imagesContainerBg),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      )),
                  child:
                  Column(
                    children: [
                      const SizedBox(height: 50,),
                      textWidget(
                          text: 'Subscriber and Commission',
                          fontSize: 20,
                          color: AppColors.primaryTextColor
                      ),
                    ],
                  ),
                ),

                Positioned(
                    top: 100,
                    child: Container(
                      height: heights * 0.70,
                      width: widths * 0.94,
                      decoration: BoxDecoration(
                          color: AppColors.primaryTextColor,
                          borderRadius:
                          BorderRadiusDirectional.circular(15)),
                      child: Column(
                        children: [
                          SizedBox(height: heights*0.02,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              textWidget(text: 'Username',fontWeight: FontWeight.w800,
                                fontSize: 14,),
                              textWidget(text: 'Turnover',fontWeight: FontWeight.w800,
                                fontSize: 14,),
                              textWidget(text: 'Commission',fontWeight: FontWeight.w800,
                                fontSize: 14,),
                            ],
                          ),
                          SizedBox(height: heights*0.01,),
                          levelList.isEmpty?Container():  ListView.builder(
                              shrinkWrap: true,
                              itemCount: levelList.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 45,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primaryContColor,
                                  ),
                                  child: Card(
                                    elevation: 1,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: 80,
                                          child: textWidget(
                                            text: levelList[index].level,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 80,
                                          child: textWidget(
                                            text: levelList[index].user,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          width: 80,
                                          child: textWidget(
                                            text: levelList[index].commission,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

}

class LevelModel {
  final String level;
  final String user;
  final String commission;

  LevelModel({
    required this.level,
    required this.user,
    required this.commission,
  });
}