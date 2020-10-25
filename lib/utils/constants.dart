import 'package:auth_app/models/category.dart';
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
  static const String BELL_SVG = "$_BASE_ASSET_DIR/bell.svg";
  static const String MENU_SVG = "$_BASE_ASSET_DIR/menu.svg";
  static const String CUSTOM_MOMENT = "$_BASE_ASSET_DIR/custom_moment.svg";
  static const String ONE_CLICK_MOMENT = "$_BASE_ASSET_DIR/one_click_moment.svg";
  static const String HAPPENING_NOW = "$_BASE_ASSET_DIR/happening_now.svg";
  static const String QR_CODE = "$_BASE_ASSET_DIR/qr_code.svg";
  static const String PEOPLE = "$_BASE_ASSET_DIR/people.png";
  static const String ANIMALS = "$_BASE_ASSET_DIR/animals.png";
  static const String BEACH = "$_BASE_ASSET_DIR/beach.png";
  static const String DINING = "$_BASE_ASSET_DIR/dining.png";
  static const String FAMILY = "$_BASE_ASSET_DIR/family.png";
  static const String FASHION = "$_BASE_ASSET_DIR/fashion.png";
  static const String FOOD = "$_BASE_ASSET_DIR/food.png";
  static const String MUSEUM = "$_BASE_ASSET_DIR/museum.png";
  static const String TRAVEL = "$_BASE_ASSET_DIR/travel.png";
  static const String PEOPLE_LARGE = "$_BASE_ASSET_DIR/people_large.jpeg";
  static const String ANIMALS_LARGE = "$_BASE_ASSET_DIR/animals_large.jpg";
  static const String BEACH_LARGE = "$_BASE_ASSET_DIR/beach_large.jpg";
  static const String DINING_LARGE = "$_BASE_ASSET_DIR/dining_large.jpg";
  static const String FAMILY_LARGE = "$_BASE_ASSET_DIR/family_large.jpg";
  static const String FASHION_LARGE = "$_BASE_ASSET_DIR/fashion_large.png";
  static const String FOOD_LARGE = "$_BASE_ASSET_DIR/food_large.jpg";
  static const String MUSEUM_LARGE = "$_BASE_ASSET_DIR/museum_large.jpg";
  static const String TRAVEL_LARGE = "$_BASE_ASSET_DIR/travel_large.jpg";

}

class AppColors {
  static const Color ERROR_COLOR = Colors.red;
  static const Color PRIMARY_COLOR = Color(0xFFE3DB00);
  static const Color LIGHT_GREY = Color(0xFFF8F8F8);
  static const Color LIGHT_GREY_SHADE2 = Color(0xFFF1F1F1);
  static const Color LIGHT_GREY_TEXT = Color(0xFFBEBEBE);
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
  static final List<String> interests = [
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

  static final List<Category> categories = [
    Category(name: "People", image: AssetNames.PEOPLE),
    Category(name: "Animals", image: AssetNames.ANIMALS),
    Category(name: "Beach", image: AssetNames.BEACH),
    Category(name: "Dining", image: AssetNames.DINING),
    Category(name: "Family", image: AssetNames.FAMILY),
    Category(name: "Fashion", image: AssetNames.FASHION),
    Category(name: "Food", image: AssetNames.FOOD),
    Category(name: "Museum", image: AssetNames.MUSEUM),
    Category(name: "Travel", image: AssetNames.TRAVEL),
  ];

  static final Map<String, String> momentImages = {
    "Food" : AssetNames.FOOD_LARGE,
    "Animals" : AssetNames.ANIMALS,
    "Beach" : AssetNames.BEACH_LARGE,
    "Dining" : AssetNames.DINING_LARGE,
    "Family" : AssetNames.FAMILY_LARGE,
    "Fashion" : AssetNames.FASHION_LARGE,
    "Museum" : AssetNames.MUSEUM_LARGE,
    "People" : AssetNames.PEOPLE_LARGE,
    "Travel" : AssetNames.TRAVEL_LARGE
  };
}
