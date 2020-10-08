import 'package:flutter/material.dart';

class AssetNames {
  static const _BASE_ASSET_DIR = "assets/images";

  static const String FACEBOOK_LOGO_SVG = "$_BASE_ASSET_DIR/facebook_logo.svg";
  static const String TWITTER_LOGO_SVG = "$_BASE_ASSET_DIR/twitter_logo.svg";
  static const String GOOGLE_LOGO_SVG = "$_BASE_ASSET_DIR/google_logo.svg";
  static const String APP_LOGO_SVG = "$_BASE_ASSET_DIR/happr_logo.svg";
  static const String PERSON_SVG = "$_BASE_ASSET_DIR/person.svg";
  static const String PERSON_PNG = "$_BASE_ASSET_DIR/person.png";
  static const String CONGS_SVG = "$_BASE_ASSET_DIR/congs.svg";


}

class AppColors {
  static const Color ERROR_COLOR = Colors.red;
  static const Color PRIMARY_COLOR = Color(0xFFE3DB00);
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
