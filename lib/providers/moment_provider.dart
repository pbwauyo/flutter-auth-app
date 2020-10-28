import 'package:auth_app/models/moment.dart';
import 'package:flutter/material.dart';

class MomentProvider with ChangeNotifier {
  Moment _moment;

  Moment get moment => _moment;

  set moment (Moment newMoment){
    _moment = newMoment;
    notifyListeners();
  }
}