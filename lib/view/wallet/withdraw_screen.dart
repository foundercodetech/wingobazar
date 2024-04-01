// ignore_for_file: deprecated_member_use, non_constant_identifier_names, use_build_context_synchronously, unnecessary_null_comparison, depend_on_referenced_packages

import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wingo/generated/assets.dart';
import 'package:wingo/main.dart';
import 'package:wingo/model/addaccount_view_model.dart';
import 'package:wingo/model/user_model.dart';
import 'package:wingo/res/aap_colors.dart';
import 'package:wingo/res/api_urls.dart';
import 'package:wingo/res/components/app_bar.dart';
import 'package:wingo/res/components/app_btn.dart';
import 'package:wingo/res/components/rich_text.dart';
import 'package:wingo/res/components/text_field.dart';
import 'package:wingo/res/components/text_widget.dart';
import 'package:wingo/res/helper/api_helper.dart';
import 'package:wingo/res/provider/user_view_provider.dart';
import 'package:wingo/res/provider/wallet_provider.dart';
import 'package:wingo/utils/routes/routes_name.dart';
import 'package:wingo/utils/utils.dart';
import 'package:wingo/view/wallet/account_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class WithdrawScreen extends StatefulWidget {

  const WithdrawScreen({super.key});

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {

  bool isExpanded = false;
  bool rememberPass = false;


  @override
  void initState() {
    addAccountView();
    walletfetch();
    super.initState();
  }
  TextEditingController withdrawCon=TextEditingController();

  BaseApiHelper baseApiHelper = BaseApiHelper();


  int ?responseStatuscode;

  int selectedIndex = 0;





  @override
  Widget build(BuildContext context) {


    final walletdetails = Provider.of<WalletProvider>(context).walletlist;
    // final addaccountview = Provider.of<AddacountViewProvider>(context).viewlist;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GradientAppBar(
          leading: const AppBackBtn(),
          title: textWidget(
              text: 'Withdraw',
              fontSize: 25,
              color: AppColors.primaryTextColor),
          gradient: AppColors.primaryGradient, centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                height: height * 0.25,
                width: width,
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(Assets.imagesCardImage),
                        fit: BoxFit.fill)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Image.asset(Assets.iconsDepoWallet,
                                height: 30),
                            const SizedBox(width: 15),
                            textWidget(
                                text: 'Available balance',
                                fontSize: 20,
                                color: AppColors.primaryTextColor),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const SizedBox(width: 15),
                            const Icon(Icons.currency_rupee,color: AppColors.iconSecondColor),
                            textWidget(
                                text:walletdetails!.winning_wallet==null?"0.0":walletdetails.winning_wallet.toString(),
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primaryTextColor),
                            const SizedBox(width: 15),
                            InkWell(
                                onTap: (){
                                  walletfetch();
                                  addAccountView();

                                },
                                child: Image.asset(Assets.iconsTotalBal, height: 30, color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                    Image.asset(Assets.iconsChip),
                  ],
                ),
              ),
              const SizedBox(height: 20),


              responseStatuscode== 400 ?
              const Notfounddata(): items.isEmpty? Container():
              ListView.builder(
                  itemCount: items.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext, int index){
                    final currentId = int.parse(items[index].id.toString());
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = currentId;
                              withdrawacid=items[index].id.toString();
                              print(selectedIndex);
                              print(currentId);
                              print("zxcfvgbhn");

                            });
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            alignment: Alignment.center,
                            decoration: selectedIndex == currentId?BoxDecoration(
                              image: const DecorationImage(
                                  image: AssetImage(
                                      Assets.iconsCorrect)),
                              border: Border.all(
                                  color: Colors.transparent
                              ),
                              borderRadius: BorderRadiusDirectional.circular(50),
                            ):BoxDecoration(
                              border: Border.all(
                                  color: Colors.red),
                              borderRadius: BorderRadiusDirectional.circular(50),
                            ),
                          ),
                        ),


                        title: textWidget(text: items[index].name.toString(),fontSize: width*0.04),
                        subtitle: textWidget(text:items[index].account_no.toString(),fontSize: width*0.034),
                        trailing: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountView(data:items[index])));
                          },
                            child: textWidget(text: "View All >",fontSize: width*0.04)
                        ),
                      ),
                    );
                  }),

              SizedBox(height: height*0.02,),
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, RoutesName.addBankAccount);
                },
                child: Card(
                  elevation: 4,
                  child: Container(
                    width: width,
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                    decoration: BoxDecoration(color: AppColors.primaryContColor, borderRadius: BorderRadiusDirectional.circular(15)),
                    child: Column(
                      children: [
                        const SizedBox(width: 15),
                        Image.asset(Assets.iconsAddBank,height: 60,),
                        const SizedBox(width: 15),
                        textWidget(
                            text: 'Add a bank account number',
                            color: AppColors.secondaryTextColor.withOpacity(0.5),
                            fontSize: 16,
                            fontWeight: FontWeight.w900),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: width,
                padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                decoration: BoxDecoration(
                    color: AppColors.primaryContColor,
                    borderRadius: BorderRadiusDirectional.circular(15)),
                child: Column(
                  children: [
                    const SizedBox(width: 15),
                    textWidget(
                        text: 'Need to add beneficiary information to be able to withdraw money',
                        color: AppColors.gradientFirstColor,
                        fontWeight: FontWeight.w900),
                    const SizedBox(height: 10),
                    CustomTextField(
                      hintText: '500 - 100000',
                      fieldRadius: BorderRadius.circular(30),
                      textColor: AppColors.gradientFirstColor,
                      fontWeight: FontWeight.w600,
                      controller: withdrawCon,
                      prefixIcon: SizedBox(
                        width: 70,
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            const Icon(Icons.currency_rupee,
                                color: AppColors.gradientFirstColor),
                            const SizedBox(width: 10),
                            Container(height: 30, color: Colors.white, width: 2)
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        textWidget(
                            text: 'Withdrawal amount received',
                            fontSize: 14,
                            color: AppColors.secondaryTextColor),
                        Row(
                          children: [
                            const Icon(Icons.currency_rupee,
                                size: 14, color: AppColors.gradientFirstColor),
                            textWidget(
                                text: withdrawCon.text==''?'0.0':(int.parse(withdrawCon.text)*0.96).toString(),
                                fontSize: 20,
                                color: AppColors.gradientFirstColor),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    AppBtn(
                        loading: loading,
                      onTap: () {
                        Withdrawalmoney(withdrawCon.text);
                      },
                      hideBorder: true,
                      title: 'W i t h d r a w',
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: width,
                padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                decoration: BoxDecoration(
                    color: AppColors.primaryContColor,
                    borderRadius: BorderRadiusDirectional.circular(15)),
                child: Column(
                  children: [
                    instruction(
                        'Need to bet ',
                        '₹0.00',
                        ' to be able to withdraw',
                        AppColors.secondaryTextColor,
                        AppColors.gradientFirstColor,
                        AppColors.secondaryTextColor),
                    instruction(
                        'Withdraw ',
                        ' time ',
                        ' 00:00-23:59',
                        AppColors.secondaryTextColor,
                        AppColors.secondaryTextColor,
                        AppColors.gradientFirstColor),
                    instruction(
                        'Inday Remaining Withdrawal ',
                        ' Times ',
                        ' 3',
                        AppColors.secondaryTextColor,
                        AppColors.secondaryTextColor,
                        AppColors.gradientFirstColor),
                    instruction(
                        'Withdrawal amount ',
                        ' range ',
                        ' ₹500.00-₹10,000,000.00',
                        AppColors.secondaryTextColor,
                        AppColors.secondaryTextColor,
                        AppColors.gradientFirstColor),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      )
    );
  }
bool loading = false;
  ///wallet fetch data
  Future<void> walletfetch() async {
    try {
      if (kDebugMode) {
        print("qwerfghj");
      }
      final wallet_data = await baseApiHelper.fetchWalletData();
      if (kDebugMode) {
        print(wallet_data);
        print("wallet_data");
      }
      Provider.of<WalletProvider>(context, listen: false).setWalletList(wallet_data!);
    } catch (error) {
      // Handle error here
      if (kDebugMode) {
        print("hiiii $error");
      }
    }
  }


  ///withdraw api
 String withdrawacid='';
  UserViewProvider userProvider = UserViewProvider();

  Withdrawalmoney(String money) async {
    if (kDebugMode) {
      print("fuydftd");
    }
    setState(() {
      loading = true;
    });
    UserModel user = await userProvider.getUser();
    String token = user.id.toString();
    print(token);
    final response = await http.post(Uri.parse(ApiUrl.withdrawl),
        body: jsonEncode(<String, String>{
          "user_id":token,
          "accountid": withdrawacid,
          "amount": money.toString()
        })
    );
    try{
    var data = jsonDecode(response.body);
    print(response.body);
    print(data);
    print("data");
    if(data["status"]=="200"){
      setState(() {
        loading= false;
      });
      Fluttertoast.showToast(msg: data['msg']);
    }else{
      setState(() {
        loading= false;
      });
      Fluttertoast.showToast(msg: data['msg']);
    }
  }catch(e){
      setState(() {
        loading= false;
      });
      print(e);
      Fluttertoast.showToast(msg: "something went wrong\n   try again");
    }
  }


  ///view account
  List<AddacountViewModel> items = [];

  Future<void> addAccountView() async {
    UserModel user = await userProvider.getUser();
    String token = user.id.toString();

    final response = await http.get(Uri.parse(ApiUrl.addAccount_View+token),);
    print(ApiUrl.addAccount_View+token);
    print('addAccount_View+token');

    setState(() {
      responseStatuscode = response.statusCode;
    });

    if (response.statusCode==200) {
      final List<dynamic> responseData = json.decode(response.body)['data'];
      setState(() {
        items = responseData.map((item) => AddacountViewModel.fromJson(item)).toList();
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



  Widget instruction(String titleFirst, String titleSecond, String titleThird, Color? firstColor, Color? secondColor, Color? thirdColor,) {
    return ListTile(
        leading: Transform.rotate(
          angle: 45 * 3.1415927 / 180,
          child: Container(
            height: 10,
            width: 10,
            color: AppColors.gradientFirstColor,
          ),
        ),
        title: CustomRichText(
          textSpans: [
            CustomTextSpan(
                text: titleFirst, textColor: firstColor, fontSize: 14),
            CustomTextSpan(
                text: titleSecond, textColor: secondColor, fontSize: 14),
            CustomTextSpan(
                text: titleThird, textColor: thirdColor, fontSize: 14)
          ],
        ));
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
        SizedBox(height: heights*0.04),
        const Text("Data not found",)
      ],
    );
  }

}




