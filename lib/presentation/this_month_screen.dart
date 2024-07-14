import 'package:flutter/material.dart';

import '../core/app_export.dart';
import '../widgets/custom_text_form_field.dart'; // ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class ThisMonthScreen extends StatelessWidget {
  ThisMonthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildBulanColumn(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildBulanColumn(BuildContext context) {
    return Container(
      width: 348.h,
      margin: EdgeInsets.symmetric(horizontal: 21.h),
      padding: EdgeInsets.symmetric(
        horizontal: 23.h,
        vertical: 7.v,
      ),
      decoration: AppDecoration.outlineBlack900.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.v),
          Text(
            "Bulan",
            style: theme.textTheme.headlineSmall,
          )
        ],
      ),
    );
  }
}