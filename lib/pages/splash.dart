import 'package:auth_app/main.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/widgets/ring.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Splash extends StatefulWidget {

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2), 
    (){
      Navigations.goToScreen(context, MyHomePage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Ring(
          width: 10,
          size: 180,
        ),
      ),
    );
  }
}