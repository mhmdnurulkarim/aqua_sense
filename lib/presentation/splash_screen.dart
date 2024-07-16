import 'package:flutter/material.dart';

import '../core/app_export.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration(seconds: 5),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: AppRoutes.routes["/app_navigation_screen"]!,
        ),
      ),
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.blue200,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                ImageConstant.imgSplash,
                height: 300,
                width: 300,
              ),
              SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Karamba Warn",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    TextSpan(
                      text: "!",
                      style: CustomTextStyles.headlineLargeRed800,
                    ),
                    TextSpan(
                      text: "ng",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
