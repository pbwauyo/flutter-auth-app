import 'package:auth_app/models/category.dart';
import 'package:auth_app/models/memory.dart';
import 'package:auth_app/models/moment.dart';
import 'package:auth_app/pages/congratulations.dart';
import 'package:auth_app/pages/home.dart';
import 'package:auth_app/pages/test_invitation_success.dart';
import 'package:flutter/material.dart';

//take picture types
const MOMENT_IMAGE_ADD = "MOMENT_IMAGE_ADD";
const MOMENT_IMAGE_EDIT = "MOMENT_IMAGE_EDIT";
const MOMENT_IMAGE_HAPPENING_NOW = "MOMENT_IMAGE_HAPPENING_NOW";
const MEMORY_IMAGE_ADD = "MEMORY_IMAGE_ADD";
const CHANGE_PROFILE_PIC = "CHANGE_PROFILE_PIC";

//moment types
const MOMENT_TYPE_ONE_CLICK = "MOMENT_TYPE_ONE_CLICK";
const MOMENT_TYPE_CUSTOM = "MOMENT_TYPE_CUSTOM";
const MOMENT_TYPE_HAPPENING_NOW = "MOMENT_TYPE_HAPPENING_NOW";

const ARTIFACT_TYPE_MEMORY = "MEMORY";
const ARTIFACT_TYPE_MOMENT = "MOMENT";

const double VIDEO_HEIGHT = 250;

class AssetNames {
  static const _BASE_ASSET_DIR = "assets/images";

  static const String FACEBOOK_LOGO_SVG = "$_BASE_ASSET_DIR/facebook_logo.svg";
  static const String TWITTER_LOGO_SVG = "$_BASE_ASSET_DIR/twitter_logo.svg";
  static const String GOOGLE_LOGO_SVG = "$_BASE_ASSET_DIR/google_logo.svg";
  static const String FACEBOOK_LOGO_NEW_SVG = "$_BASE_ASSET_DIR/facebook_logo_new.svg";
  static const String TWITTER_LOGO_NEW_SVG = "$_BASE_ASSET_DIR/twitter_logo_new.svg";
  static const String GOOGLE_LOGO_NEW_SVG = "$_BASE_ASSET_DIR/google_logo_new.svg";
  static const String FACEBOOK_LOGO_NEW_PNG = "$_BASE_ASSET_DIR/facebook_logo_new_png.png";
  static const String TWITTER_LOGO_NEW_PNG = "$_BASE_ASSET_DIR/twitter_logo_new_png.png";
  static const String GOOGLE_LOGO_NEW_PNG = "$_BASE_ASSET_DIR/google_logo_new_png.png";
  static const String APPLE_LOGO_NEW_PNG = "$_BASE_ASSET_DIR/apple_logo_new_png.png";

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
  static const String STACKED_IMAGES = "$_BASE_ASSET_DIR/stacked_images.png";
  static const String DEFAULT_USER = "$_BASE_ASSET_DIR/default_user.png";
  static const String YUMMY = "$_BASE_ASSET_DIR/yummy.jpg";
  static const String BEEF_STEAK = "$_BASE_ASSET_DIR/beef_steak.jpg";
  static const String SALADS = "$_BASE_ASSET_DIR/salads.jpg";
  static const String PIZZA = "$_BASE_ASSET_DIR/pizza.jpg";
  static const String CHICKEN = "$_BASE_ASSET_DIR/chicken.jpg";
  static const String COLOR_PALLETE_SVG = "$_BASE_ASSET_DIR/color_pallete_svg.svg";

  static const String FLIRTY_SMILEY_EMOJI = "$_BASE_ASSET_DIR/flirty_smiley_emoji.png";
  static const String THUMB_DOUBLE_EMOJI = "$_BASE_ASSET_DIR/thumb_double_emoji.png";
  static const String SMILEY_KISS_EMOJI = "$_BASE_ASSET_DIR/smiley_kiss_emoji.png";
  static const String SMILEY = "$_BASE_ASSET_DIR/smiley.png";
  static const String THOUGHT_WORLD_EMOJI = "$_BASE_ASSET_DIR/thought_world_emoji.png";
  static const String FIRE_EMOJI = "$_BASE_ASSET_DIR/fire_emoji.png";
  static const String SMILEY_IMAGE = "$_BASE_ASSET_DIR/smiley_image.png";
  static const String LOUDLY_CRYING_EMOJI = "$_BASE_ASSET_DIR/loudly_crying_emoji.png";
  static const String TONGUE_OUT_EMOJI = "$_BASE_ASSET_DIR/tongue_out_emoji.png";
  static const String HONDA_UP_AMAZE_EMOJI = "$_BASE_ASSET_DIR/honda_up_amaze.png";
  static const String FEARFUL_EMOJI = "$_BASE_ASSET_DIR/fearful_emoji.png";
  static const String CRYING_EMOJI = "$_BASE_ASSET_DIR/crying_emoji.png";
  static const String ANGEL_BLUSHING_EMOJI = "$_BASE_ASSET_DIR/angel_blushing_emoji.png";
  static const String TEARS_OF_JOY_EMOJI = "$_BASE_ASSET_DIR/tears_of_joy_emoji.png";
  static const String SUNGLASSES_COOL_EMOJI = "$_BASE_ASSET_DIR/sunglasses_cool_emoji.png";
  static const String WINK_EMOJI = "$_BASE_ASSET_DIR/wink_emoji.png";
  static const String HEARTS_EYES_EMOJI = "$_BASE_ASSET_DIR/hearts_eyes_emoji.png";
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
  static goToScreen(BuildContext context, Widget newScreen, {String routeName, bool withReplacement = false}){
    var route = MaterialPageRoute(
      builder: (context) => newScreen,
      settings: RouteSettings(
        name: routeName
      )
    );

    if(newScreen is Home){
      routeName = "HOME";
      route = MaterialPageRoute(
        builder: (context) => newScreen,
        settings: RouteSettings(
          name: routeName
        )
      );
      Navigator.popUntil(context, (route) => route.settings.name == "HOME");
      Navigator.push(context, route);
      
    }
    else if(newScreen is Congratulations){
      routeName = "CONGRATULATIONS";
      route = MaterialPageRoute(
        builder: (context) => newScreen,
        settings: RouteSettings(
          name: routeName
        )
      );
      Navigator.popUntil(context, (route) => route.settings.name == "CONGRATULATIONS");
      Navigator.push(context, route); 
    }
    else if(newScreen is TestInvitationSuccess){
      routeName = "TestInvitationSuccess";
      route = MaterialPageRoute(
        builder: (context) => newScreen,
        settings: RouteSettings(
          name: routeName
        )
      );
      Navigator.popUntil(context, (route) => route.settings.name == "TestInvitationSuccess");
      Navigator.push(context, route); 
    }
    else{
      if(withReplacement){
        Navigator.pushReplacement(context, route);
      }
      else {
        Navigator.push(context, route);
      }
    }
  }

  static goToTransparentScreen({@required BuildContext context, @required Widget nextScreen}){
    final route = PageRouteBuilder(
      opaque: false,
      pageBuilder: (context, _, __){
        return nextScreen;
      }
    );
    Navigator.of(context).push(route);
  }

  static showTransparentDialog({@required BuildContext context, @required Widget screen}){
    showDialog(
      context: context,
      builder: (_) => Material(
        type: MaterialType.transparency,
        child: screen,
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

  static final List<String> months = [
    "January", "February", "March", "April", "May", "June", 
    "July", "August", "September", "October", "November", "December"
  ];

  static final List<Moment> randomMoments = [
    Moment(
      title: "Tasty food",
      location: "Karachi",
      attendees: [],
      startDateTime: "1 PM, 21 October 2020",
      endDateTime: "1 PM, 22 October 2020",
      realStartDateTime: DateTime(2020, 10, 21, 13, 0),
      realEndDateTime: DateTime(2020, 10, 21, 13, 0).add(Duration(days: 1)),
      imageUrl: "",
      category: "Food",
      id: "",
      notes: ""
    ),

     Moment(
      title: "Family Outing",
      location: "Islamabad",
      attendees: [],
      startDateTime: "3 PM, 23 July 2020",
      endDateTime: "3 PM, 24 July 2020",
      realStartDateTime: DateTime(2020, 7, 23, 15, 0),
      realEndDateTime: DateTime(2020, 7, 23, 15, 0).add(Duration(days: 1)),
      imageUrl: "",
      category: "People",
      id: "",
      notes: ""
    ),

     Moment(
      title: "Hang out with friends",
      location: "Lahore",
      attendees: [],
      startDateTime: "4 PM, 25 June 2020",
      endDateTime: "4 PM, 26 June 2020",
      realStartDateTime: DateTime(2020, 6, 25, 16, 0),
      realEndDateTime: DateTime(2020, 6, 25, 16, 0).add(Duration(days: 1)),
      imageUrl: "",
      category: "Beach",
      id: "",
      notes: ""
    ),

    Moment(
      title: "Go for a fashion night",
      location: "Swat",
      attendees: [],
      startDateTime: "2 PM, 25 May 2020",
      endDateTime: "2 PM, 26 May 2020",
      realStartDateTime: DateTime(2020, 5, 25, 14, 0),
      realEndDateTime: DateTime(2020, 5, 25, 14, 0).add(Duration(days: 1)),
      imageUrl: "",
      category: "Fashion",
      id: "",
      notes: ""
    ),

    Moment(
      title: "Visit ancient sites",
      location: "Mohenjo Daro",
      attendees: [],
      startDateTime: "8 AM, 25 May 2020",
      endDateTime: "9 AM, 26 May 2020",
      realStartDateTime: DateTime(2020, 5, 25, 8, 0),
      realEndDateTime: DateTime(2020, 5, 25, 8, 0).add(Duration(days: 1)),
      imageUrl: "",
      category: "Travel",
      id: "",
      notes: ""
    ),
  ];

  static final Map<String, String> memoryImages = {
    "Yummy" : AssetNames.YUMMY,
    "Salads" : AssetNames.SALADS,
    "Chicken" : AssetNames.CHICKEN,
    "Beef Steak" : AssetNames.BEEF_STEAK,
    "Pizza" : AssetNames.PIZZA
  };

  static final List<Memory> testMemoryMocks = [
    Memory(
      title: "Yummy",
      image: "Yummy",
    ),

    Memory(
      title: "I am hungry",
      image: "Salads",
    ),

    Memory(
      title: "Very tasty chicken",
      image: "Chicken",
    ),

    Memory(
      title: "The beef steak is really tasty.",
      image: "Beef Steak",
    ),

    Memory(
      title: "Really enjoyed the Pizza",
      image: "Pizza",
    ),
  ];

  static final Map<double, dynamic> SLIDER_LABELS = {
    0.0 : null,
    1.0 : "Happy",
    2.0 : "Very Happy",
    3.0 : "Blissful"
  };

  static final Map<double, Color> SLIDER_LABEL_COLORS = {
    0.0 : Colors.grey,
    1.0 : Colors.green,
    2.0 : Colors.blue,
    3.0 : Colors.yellow
  };

  static final emojiList = [
    AssetNames.FIRE_EMOJI, AssetNames.SMILEY,
    AssetNames.LOUDLY_CRYING_EMOJI, AssetNames.TONGUE_OUT_EMOJI, AssetNames.HONDA_UP_AMAZE_EMOJI,
    AssetNames.FEARFUL_EMOJI, AssetNames.CRYING_EMOJI, AssetNames.ANGEL_BLUSHING_EMOJI, AssetNames.TEARS_OF_JOY_EMOJI,
    AssetNames.SUNGLASSES_COOL_EMOJI, AssetNames.WINK_EMOJI, AssetNames.HEARTS_EYES_EMOJI
  ];

}

class TakePictureType {
  static const MOMENT_IMAGE = "MOMENT_IMAGE";
  static const PROFILE_PICTURE = "PROFILE_PICTURE";
}
