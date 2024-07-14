import 'package:aini_s_application1/presentation/tampilan_today_screen/tampilan_today_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';

class TampilanAwalScreen extends StatelessWidget {
  const TampilanAwalScreen({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    Future.delayed(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: AppRoutes.routes["/tampilan_today_screen"]!),
            ));

    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.blue200,
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 26.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 16.v),
              _buildKarambawaColumn(context)
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildKarambawaColumn(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 109.h,
        vertical: 29.v,
      ),
      decoration: AppDecoration.fillTeal.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder20,
      ),
      child: SizedBox(
        width: 118.h,
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Karamba Warn",
                style: theme.textTheme.headlineLarge,
              ),
              TextSpan(
                text: "!ng",
                style: CustomTextStyles.headlineLargeRed800,
              )
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
