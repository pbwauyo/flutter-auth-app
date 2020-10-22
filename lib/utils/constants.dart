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
  static const String LOCATION_SVG = "$_BASE_ASSET_DIR/location.svg";
  static const String HAPPY_SVG = "$_BASE_ASSET_DIR/happy.svg";
  static const String CALENDAR_SVG = "$_BASE_ASSET_DIR/calendar.svg";
  static const String CIRCLE_SVG = "$_BASE_ASSET_DIR/circle.svg";
  static const String HOME_SVG = "$_BASE_ASSET_DIR/home.svg";
  static const String ELLIPSE_SVG = "$_BASE_ASSET_DIR/ellipse.svg";
  static const String   BELL_SVG = "$_BASE_ASSET_DIR/bell.svg";
  static const String MENU_SVG = "$_BASE_ASSET_DIR/menu.svg";
}

class AppColors {
  static const Color ERROR_COLOR = Colors.red;
  static const Color PRIMARY_COLOR = Color(0xFFE3DB00);
  static const Color LIGHT_GREY = Color(0xFFF8F8F8);
}

class FontSizes {
  static const double APP_BAR_TITLE = 18;
}

class Navigations {
  static goToScreen(BuildContext context, Widget newScreen, {String routeName}){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => newScreen,
        settings: RouteSettings(
          name: routeName
        )
      )
    );
  }
}

class Constants {
  static final List<String> interestsCategories = [
    'Fashion',
    'Sports',
    'Lorem',
    'Ipsum',
    'Dolar',
    'Food',
    'Beach',
    'Animals',
    'Longer Name',
    'Music',
    'Movies',
    'Swimming',
    'Acting',
    'Dancing',
    'Gaming'
  ];
}
