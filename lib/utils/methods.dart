import 'package:auth_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Methods {

  static showGeneralErrorToast(dynamic error){
    Fluttertoast.showToast(
      msg: error.message,
      textColor: AppColors.errorColor,
      toastLength: Toast.LENGTH_LONG
    );
  }

  static showFirebaseErrorToast(dynamic error){
    Fluttertoast.showToast(
      msg: error,
      textColor: AppColors.errorColor,
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

}