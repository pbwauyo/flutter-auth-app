import 'package:flutter/material.dart';

class AssetNames {
  static const _BASE_ASSET_DIR = "assets/images";

  static const String FACEBOOK_LOGO_SVG = "$_BASE_ASSET_DIR/facebook_logo.svg";
  static const String TWITTER_LOGO_SVG = "$_BASE_ASSET_DIR/twitter_logo.svg";
  static const String GOOGLE_LOGO_SVG = "$_BASE_ASSET_DIR/google_logo.svg";

}

class AppColors {
  static Color errorColor = Colors.red;
}

class Navigations {
  static goToScreen(BuildContext context, Widget newScreen){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => newScreen
      )
    );
  }
}
