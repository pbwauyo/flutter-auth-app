import 'dart:convert';

import 'package:auth_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math' as math;


class Methods {

  static showGeneralErrorToast(dynamic error){
    Fluttertoast.showToast(
      msg: error.message,
      textColor: AppColors.ERROR_COLOR,
      toastLength: Toast.LENGTH_LONG
    );
  }

  static showFirebaseErrorToast(dynamic error){
    Fluttertoast.showToast(
      msg: error,
      textColor: AppColors.ERROR_COLOR,
      toastLength: Toast.LENGTH_LONG
    );
  }

  static showCustomToast(dynamic error){
    Fluttertoast.showToast(
      msg: error,
      textColor: Colors.white,
      backgroundColor: Colors.green,
      toastLength: Toast.LENGTH_SHORT
    );
  }

  static String generateOauthNonce(){
    math.Random rnd = new math.Random();

    List<int> values = new List<int>.generate(32, (i) => rnd.nextInt(256));
     return base64UrlEncode(values).replaceAll(new RegExp('[=/+]'), '');
  }

  static showCustomSnackbar({@required BuildContext context, 
  @required String message, String actionLabel="", VoidCallback actionOnTap}){
    Scaffold.of(context).showSnackBar(
      SnackBar(
        duration: actionLabel.isNotEmpty ? Duration(days: 2) : Duration(milliseconds: 4000),
        content: Text(message),
        action: SnackBarAction(
          label: actionLabel, 
          onPressed: actionOnTap ?? (){}
        ),
      )
    );
  }

}