import 'package:wingo/res/aap_colors.dart';
import 'package:wingo/res/components/text_widget.dart';
import 'package:flutter/material.dart';


class AppDisableBtn extends StatefulWidget {
  final String? title;
  final Color? titleColor;
  final Function()? onTap;
  final double? width;
  final double? height;
  final double? fontSize;
  final bool? loading;
  final Gradient? gradient;
  final bool hideBorder;
  final Widget? child;
  final FontWeight? fontWeight;
  final BorderRadiusGeometry? borderRadius;


  const AppDisableBtn({
    super.key,
    this.title,
    this.titleColor,
    this.onTap,
    this.width,
    this.height,
    this.fontSize,
    this.loading = false,
    this.gradient,
    this.hideBorder = false,
    this.child,
    this.fontWeight,
    this.borderRadius,
  });

  @override
  State<AppDisableBtn> createState() => _AppDisableBtnState();
}

class _AppDisableBtnState extends State<AppDisableBtn> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(microseconds: 200));
    _scaleAnimation = Tween<double>(begin: 1, end: 0.3).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeOutQuart));
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTapDown: (_) {
      //   _animationController.forward();
      // },
      // onTapUp: (_) {
      //   _animationController.reverse();
      // },
      // onTapCancel: () {
      //   _animationController.reverse();
      // },
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.loading == false
                ? Container(
                height: widget.height ?? 52,
                width: widget.width ?? MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                    gradient: widget.gradient ?? AppColors.disableGradient,
                    borderRadius:BorderRadius.circular(10.0),
                    border: Border.all(
                        color: widget.hideBorder == false
                            ? AppColors.dividerColor
                            : Colors.transparent,
                        width: 0.5)),
                child: widget.child ??
                    textWidget(
                        text: widget.title ?? 'Press me',
                        fontSize: widget.fontSize ?? 16,
                        color:
                        widget.titleColor ?? AppColors.primaryTextColor,
                        fontWeight: widget.fontWeight ?? FontWeight.w600))
                : Center(
              child: Container(
                height: 45,
                width: 43,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.dividerColor,
                        AppColors.dividerColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30.0)),
                padding: const EdgeInsets.all(12),
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 4,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class AppBackBtn extends StatelessWidget {
  const AppBackBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
      child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child:const Icon(Icons.arrow_back_ios,size: 28)),
    );
  }
}
