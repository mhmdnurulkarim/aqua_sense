import 'package:flutter/material.dart';
import '../../core/app_export.dart'; // ignore_for_file: must_be_immutable

class AlarmDialog extends StatelessWidget {
  const AlarmDialog({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 340.h,
          padding: EdgeInsets.symmetric(
            horizontal: 15.h,
            vertical: 103.v,
          ),
          decoration: AppDecoration.fillWhiteA.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Spacer(),
              CustomImageView(
                imagePath: ImageConstant.imgVector,
                height: 187.v,
                width: 177.h,
              ),
              SizedBox(height: 33.v),
              SizedBox(
                width: 307.h,
                child: Text(
                  "Karamba dalam bahaya, air danau dalam keadaan asam. Segera Evakuasi Ikan",
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: CustomTextStyles.headlineSmallInterBlack900,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
