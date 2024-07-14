import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_text_form_field.dart'; // ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class TampilanThisMonthScreen extends StatelessWidget {
  TampilanThisMonthScreen({Key? key})
      : super(
          key: key,
        );

  TextEditingController vectornineteenController = TextEditingController();

  TextEditingController vectorController = TextEditingController();

  TextEditingController vector1Controller = TextEditingController();

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
  Widget _buildKarambawaColumn(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 39.h,
        vertical: 6.v,
      ),
      decoration: AppDecoration.fillBlueGray,
      child: Column(
        children: [
          SizedBox(height: 29.v),
          SizedBox(
            width: 78.h,
            child: Text(
              "Karamba Warning",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
          ),
          SizedBox(height: 30.v),
          Padding(
            padding: EdgeInsets.only(right: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Today",
                  style: CustomTextStyles.bodySmallInder,
                ),
                Spacer(
                  flex: 57,
                ),
                Text(
                  "Weekly",
                  style: theme.textTheme.bodySmall,
                ),
                Spacer(
                  flex: 42,
                ),
                Container(
                  decoration: AppDecoration.outlineBlack,
                  child: Text(
                    "this month",
                    style: theme.textTheme.bodySmall,
                  ),
                )
              ],
            ),
          )
        ],
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

  /// Section Widget
  Widget _buildChartStack(BuildContext context) {
    return Container(
      height: 241.v,
      width: 312.h,
      padding: EdgeInsets.symmetric(horizontal: 2.h),
      decoration: AppDecoration.fillTeal,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgGroup,
            height: 190.v,
            width: 279.h,
            alignment: Alignment.topRight,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              height: 62.v,
              width: 10.h,
              margin: EdgeInsets.only(
                left: 58.h,
                bottom: 42.v,
              ),
              decoration: BoxDecoration(
                color: appTheme.gray400,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              height: 117.v,
              width: 10.h,
              margin: EdgeInsets.only(
                left: 86.h,
                bottom: 42.v,
              ),
              decoration: BoxDecoration(
                color: appTheme.gray400,
              ),
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgGroupGray400,
            height: 15.v,
            width: 10.h,
            alignment: Alignment.bottomLeft,
            margin: EdgeInsets.only(
              left: 114.h,
              bottom: 42.v,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 82.v,
              width: 10.h,
              margin: EdgeInsets.only(bottom: 42.v),
              decoration: BoxDecoration(
                color: appTheme.gray400,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 121.v,
              width: 10.h,
              margin: EdgeInsets.only(
                right: 126.h,
                bottom: 42.v,
              ),
              decoration: BoxDecoration(
                color: appTheme.gray400,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 60.v,
              width: 10.h,
              margin: EdgeInsets.only(
                right: 98.h,
                bottom: 42.v,
              ),
              decoration: BoxDecoration(
                color: appTheme.gray400,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 97.v,
              width: 10.h,
              margin: EdgeInsets.only(
                right: 70.h,
                bottom: 42.v,
              ),
              decoration: BoxDecoration(
                color: appTheme.gray400,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              height: 164.v,
              width: 10.h,
              margin: EdgeInsets.only(
                top: 33.v,
                right: 42.h,
              ),
              decoration: BoxDecoration(
                color: appTheme.gray400,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              height: 191.v,
              width: 10.h,
              margin: EdgeInsets.only(
                top: 7.v,
                right: 14.h,
              ),
              decoration: BoxDecoration(
                color: appTheme.gray400,
              ),
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgGroupBlueGray900,
            height: 39.v,
            width: 10.h,
            alignment: Alignment.bottomLeft,
            margin: EdgeInsets.only(
              left: 42.h,
              bottom: 42.v,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              height: 76.v,
              width: 10.h,
              margin: EdgeInsets.only(
                left: 70.h,
                bottom: 42.v,
              ),
              decoration: BoxDecoration(
                color: appTheme.blueGray900,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 98.h,
              bottom: 42.v,
            ),
            child: CustomTextFormField(
              width: 10.h,
              controller: vectornineteenController,
              alignment: Alignment.bottomLeft,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: 163.v,
              width: 10.h,
              margin: EdgeInsets.only(left: 126.h),
              decoration: BoxDecoration(
                color: appTheme.blueGray900,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: 114.h,
              bottom: 42.v,
            ),
            child: CustomTextFormField(
              width: 10.h,
              controller: vectorController,
              alignment: Alignment.bottomRight,
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgGroupBlueGray900,
            height: 22.v,
            width: 10.h,
            alignment: Alignment.bottomRight,
            margin: EdgeInsets.only(
              right: 86.h,
              bottom: 42.v,
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgGroupBlueGray900,
            height: 10.adaptSize,
            width: 10.adaptSize,
            alignment: Alignment.bottomRight,
            margin: EdgeInsets.only(
              right: 58.h,
              bottom: 42.v,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: 30.h,
              bottom: 42.v,
            ),
            child: CustomTextFormField(
              width: 10.h,
              controller: vector1Controller,
              textInputAction: TextInputAction.done,
              alignment: Alignment.bottomRight,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 82.v,
              width: 10.h,
              margin: EdgeInsets.only(
                right: 2.h,
                bottom: 42.v,
              ),
              decoration: BoxDecoration(
                color: appTheme.blueGray900,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 27.h),
              child: SizedBox(
                height: 198.v,
                child: VerticalDivider(
                  width: 1.h,
                  thickness: 1.v,
                  indent: 6.h,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.only(
                left: 16.h,
                bottom: 36.v,
              ),
              child: Text(
                "0",
                style: theme.textTheme.bodySmall,
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                left: 9.h,
                top: 1.v,
                right: 279.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 13.h,
                        child: Text(
                          "1000",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      Container(
                        height: 1.v,
                        width: 2.h,
                        margin: EdgeInsets.only(
                          left: 2.h,
                          top: 4.v,
                          bottom: 38.v,
                        ),
                        decoration: BoxDecoration(
                          color: appTheme.black900,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 7.h,
                        child: Text(
                          "750",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      Container(
                        height: 1.v,
                        width: 2.h,
                        margin: EdgeInsets.only(
                          left: 2.h,
                          top: 8.v,
                          bottom: 34.v,
                        ),
                        decoration: BoxDecoration(
                          color: appTheme.black900,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 3.v),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 7.h,
                        child: Text(
                          "500",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      Container(
                        height: 1.v,
                        width: 2.h,
                        margin: EdgeInsets.only(
                          left: 2.h,
                          top: 9.v,
                          bottom: 34.v,
                        ),
                        decoration: BoxDecoration(
                          color: appTheme.black900,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 3.v),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 7.h,
                        child: Text(
                          "250",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      Container(
                        height: 1.v,
                        width: 2.h,
                        margin: EdgeInsets.only(
                          left: 2.h,
                          top: 9.v,
                          bottom: 34.v,
                        ),
                        decoration: BoxDecoration(
                          color: appTheme.black900,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(
                left: 25.h,
                bottom: 9.v,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 1.v,
                        width: 2.h,
                        margin: EdgeInsets.only(
                          top: 1.v,
                          bottom: 6.v,
                        ),
                        decoration: BoxDecoration(
                          color: appTheme.black900,
                        ),
                      ),
                      SizedBox(
                        height: 9.v,
                        width: 279.h,
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: EdgeInsets.only(top: 1.v),
                                child: SizedBox(
                                  width: 279.h,
                                  child: Divider(),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                height: 7.v,
                                width: 1.h,
                                margin: EdgeInsets.only(left: 13.h),
                                decoration: BoxDecoration(
                                  color: appTheme.black900,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                height: 7.v,
                                width: 1.h,
                                margin: EdgeInsets.only(left: 41.h),
                                decoration: BoxDecoration(
                                  color: appTheme.black900,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                height: 7.v,
                                width: 1.h,
                                margin: EdgeInsets.only(left: 69.h),
                                decoration: BoxDecoration(
                                  color: appTheme.black900,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                height: 7.v,
                                width: 1.h,
                                margin: EdgeInsets.only(left: 97.h),
                                decoration: BoxDecoration(
                                  color: appTheme.black900,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                height: 7.v,
                                width: 1.h,
                                margin: EdgeInsets.only(left: 125.h),
                                decoration: BoxDecoration(
                                  color: appTheme.black900,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                height: 7.v,
                                width: 1.h,
                                margin: EdgeInsets.only(right: 124.h),
                                decoration: BoxDecoration(
                                  color: appTheme.black900,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                height: 7.v,
                                width: 1.h,
                                margin: EdgeInsets.only(right: 96.h),
                                decoration: BoxDecoration(
                                  color: appTheme.black900,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                height: 7.v,
                                width: 1.h,
                                margin: EdgeInsets.only(right: 68.h),
                                decoration: BoxDecoration(
                                  color: appTheme.black900,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                height: 7.v,
                                width: 1.h,
                                margin: EdgeInsets.only(right: 40.h),
                                decoration: BoxDecoration(
                                  color: appTheme.black900,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                height: 7.v,
                                width: 1.h,
                                margin: EdgeInsets.only(right: 12.h),
                                decoration: BoxDecoration(
                                  color: appTheme.black900,
                                ),
                              ),
                            ),
                            CustomImageView(
                              imagePath: ImageConstant.imgGroupGray400,
                              height: 1.v,
                              width: 10.h,
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(left: 2.h),
                            ),
                            CustomImageView(
                              imagePath: ImageConstant.imgGroupBlueGray900,
                              height: 1.v,
                              width: 10.h,
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(left: 126.h),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10.v),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 13.h,
                      right: 11.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "0",
                          style: theme.textTheme.bodySmall,
                        ),
                        Text(
                          "1",
                          style: theme.textTheme.bodySmall,
                        ),
                        Text(
                          "2",
                          style: theme.textTheme.bodySmall,
                        ),
                        Text(
                          "3",
                          style: theme.textTheme.bodySmall,
                        ),
                        Text(
                          "4",
                          style: theme.textTheme.bodySmall,
                        ),
                        Text(
                          "5",
                          style: theme.textTheme.bodySmall,
                        ),
                        Text(
                          "6",
                          style: theme.textTheme.bodySmall,
                        ),
                        Text(
                          "7",
                          style: theme.textTheme.bodySmall,
                        ),
                        Text(
                          "8",
                          style: theme.textTheme.bodySmall,
                        ),
                        Text(
                          "9",
                          style: theme.textTheme.bodySmall,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
