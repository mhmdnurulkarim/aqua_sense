import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_text_form_field.dart';
import 'widgets/viewhierarchylist_item_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

// ignore_for_file: must_be_immutable
class TampilanTodayScreen extends StatelessWidget {
  TampilanTodayScreen({Key? key})
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
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              children: [
                SizedBox(height: 14.v),
                _buildViewHierarchyList(context),
                SizedBox(height: 20,),
                 Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Row(
                    children: [
                      Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(3), ),
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('DO')
                      ],
                        ),
                      ),
                      SizedBox(width: 10,),
                      Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(3), ),
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('pH', style: TextStyle(color: Colors.white),)
                      ],
                        ),
                      ),
                    ],
                  ),
                ),
                BarChartSample2(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text('Jam'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildViewHierarchyList(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 19.h,
        right: 23.h,
      ),
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 18.v,
          );
        },
        itemCount: 1,
        itemBuilder: (context, index) {
          return ViewhierarchylistItemWidget();
        },
      ),
    );
  }
  /// Section Widget
  // Widget _buildViewOksigenHierarchyList(BuildContext context) {
  //   return Padding(
  //     padding: EdgeInsets.only(
  //       left: 19.h,
  //       right: 23.h,
  //     ),
  //     child: ListView.separated(
  //       physics: NeverScrollableScrollPhysics(),
  //       shrinkWrap: true,
  //       separatorBuilder: (context, index) {
  //         return SizedBox(
  //           height: 18.v,
  //         );
  //       },
  //       itemCount: 1,
  //       itemBuilder: (context, index) {
  //         return ViewOksigen();
  //       },
  //     ),
  //   );
  // }

}



