
import 'package:wingo/generated/assets.dart';
import 'package:wingo/res/aap_colors.dart';
import 'package:wingo/res/components/app_bar.dart';
import 'package:wingo/res/components/app_btn.dart';
import 'package:wingo/res/components/text_field.dart';
import 'package:wingo/res/components/text_widget.dart';
import 'package:wingo/res/provider/addacount_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AddBankAccount extends StatefulWidget {
  const AddBankAccount({super.key});

  @override
  State<AddBankAccount> createState() => _AddBankAccountState();
}

class _AddBankAccountState extends State<AddBankAccount> {
  TextEditingController accNumberCon = TextEditingController();
  TextEditingController nameCon = TextEditingController();
  TextEditingController ifscCon = TextEditingController();
  TextEditingController banknameCon = TextEditingController();
  TextEditingController branchnameCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AddacountProvider>(context);
    final heights = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: GradientAppBar(
          leading: const AppBackBtn(),
          title: textWidget(
              text: 'Add a bank account number',
              fontSize: heights * 0.025,
              color: AppColors.primaryTextColor),
          gradient: AppColors.primaryGradient, centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                  padding: const EdgeInsets.only(
                      left: 5, right: 5, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                      color: AppColors.primaryContColor,
                      borderRadius: BorderRadiusDirectional.circular(30)),
                  child: ListTile(
                    leading: Image.asset(Assets.iconsAttention),
                    title: textWidget(
                        text:
                            'Need to add beneficiary information to be able to withdraw money',
                        color: AppColors.gradientFirstColor,
                        fontWeight: FontWeight.w900),
                  )),
              const SizedBox(height: 15),
              titleWidget(Assets.iconsPeople, "Full recipient's name"),
              const SizedBox(height: 15),
              CustomTextField(
                controller: nameCon,
                cursorColor: AppColors.secondaryTextColor,
                hintText: "Please enter the recipient's name",
              ),
              const SizedBox(height: 15),
              titleWidget(Assets.iconsBank, 'Bank name'),
              const SizedBox(height: 15),
              CustomTextField(
                controller: banknameCon,
                cursorColor: AppColors.secondaryTextColor,
                hintText: 'Please enter your bank name ',
              ),
              const SizedBox(height: 15),
              titleWidget(Assets.iconsAccNumber, 'Bank account number'),
              const SizedBox(height: 15),
              CustomTextField(
                controller: accNumberCon,
                cursorColor: AppColors.secondaryTextColor,
                hintText: 'Please enter your bank account no.',
              ),
              const SizedBox(height: 15),
              titleWidget(Assets.iconsAccNumber, 'Bank branch'),
              const SizedBox(height: 15),
              CustomTextField(
                controller: branchnameCon,
                cursorColor: AppColors.secondaryTextColor,
                hintText: 'Please enter your branch name ',
              ),
              const SizedBox(height: 15),
              titleWidget(Assets.iconsIfscCode, 'IFSC code'),
              const SizedBox(height: 15),
              CustomTextField(
                controller: ifscCon,
                cursorColor: AppColors.secondaryTextColor,
                hintText: 'Please enterIFSC code',
              ),
              const SizedBox(height: 15),
              AppBtn(
                onTap: () async {
                  authProvider.Addacount(
                      context,
                      nameCon.text,
                      banknameCon.text,
                      accNumberCon.text,
                      branchnameCon.text,
                      ifscCon.text);
                },
                title: 'S a v e',
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget titleWidget(String image, String title) {
    return Row(
      children: [
        Image.asset(image),
        const SizedBox(width: 10),
        textWidget(
            text: title,
            fontSize: 20,
            color: Colors.black.withOpacity(0.7),
            fontWeight: FontWeight.w600),
      ],
    );
  }
}
