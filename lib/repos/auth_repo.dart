import 'dart:convert';

import 'package:auth_app/models/app_user.dart';
import 'package:auth_app/pages/code_verification.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/utils/methods.dart';
import 'package:auth_app/utils/pref_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:twitter_api/twitter_api.dart';


//Repository to handle login and signup
class AuthRepo {
  final _firestore = FirebaseFirestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;

  final TwitterLogin _twitterLogin = new TwitterLogin(
    consumerKey: 'a8VunpkaJEI8h6lkHt2fudB3c',
    consumerSecret:'jLQ9qnm5ViNu7x03wMbsqt19qurrlGk2sWxNa7p62JGNWnqEl5',
  );

  User getCurrentUser(){
    return _firebaseAuth.currentUser;
  }

  Future<AppUser> getCurrentUserDetails() async{
    final _querySnapshot = await _firestore.collection("users").where("email", isEqualTo: getCurrentUser().email).get();
    final docData = _querySnapshot.docs[0].data();
    return AppUser.fromMap(docData);
  }

  bool isUserLoggedIn(){
    return _firebaseAuth.currentUser != null;
  }

  Future<void> logoutUser() async{
    switch (await PrefManager.getLoginType()) {

      case "FACEBOOK":
        await FacebookAuth.instance.logOut();
        await _firebaseAuth.signOut();
        break;

      case "TWITTER":
        await _twitterLogin.logOut();
        await _firebaseAuth.signOut();
        break;

      case "GOOGLE":
        await GoogleSignIn().signOut();
        await _firebaseAuth.signOut();
        break;

      default:
        await _firebaseAuth.signOut();
      
    }
  }

  //signin with registered email and password
  Future<UserCredential> signInWithFirebase(String email, String password) async{
    return await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  //sign up with email and password
  Future<void> signUpWithFirebase(AppUser appUser, String password) async{
    await _firebaseAuth.createUserWithEmailAndPassword(email: appUser.username, password: password);
    await _saveUserDetailsToFirestore(appUser: appUser);
  }

  Future<void> _saveUserDetailsToFirestore({@required AppUser appUser}) async{
    await _firestore.collection("users").doc(appUser.username).set(appUser.toMap());
  }

  Future<void> signUpWIthPhone({@required String verificationId, @required String smsCode}) async{
    // Create a PhoneAuthCredential with the code
      final phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);

      // Sign the user in (or link) with the credential
      await _firebaseAuth.signInWithCredential(phoneAuthCredential);
      
      //save user details
      final Map<String, String> userDetails = await PrefManager.getTemporaryUserDetails();

      final appUser = AppUser(
        username: userDetails["username"],
        name: userDetails["name"],
        photoUrl: userDetails["photoUrl"],
      );
      _saveUserDetailsToFirestore(appUser: appUser);
  }

  Future<Map<String, String>> getProfileFromGoogle() async{

    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn()
    .catchError((error){
      print('GOOGLE SIGN IN ERROR');
      throw("Failed to Login. Please try again");
    });

    final Map<String, String> profile = {
      "email" : googleUser.email,
      "name" : googleUser.displayName,
      "photoUrl" : googleUser.photoUrl
    };
    await PrefManager.saveLoginType("GOOGLE");
    return profile;
  }

  Future<Map<String, String>> getProfileFromTwitter() async{
    // Trigger the sign-in flow
    final TwitterLoginResult loginResult = await _twitterLogin.authorize();

    if(loginResult.status == TwitterLoginStatus.error){
      throw("Failed to Login. Please try again");
    }

    // Get the Logged In session
    final TwitterSession twitterSession = loginResult.session;

    final _twitterOauth = new twitterApi(
      consumerKey: "a8VunpkaJEI8h6lkHt2fudB3c",
      consumerSecret: "jLQ9qnm5ViNu7x03wMbsqt19qurrlGk2sWxNa7p62JGNWnqEl5",
      token: twitterSession.token,
      tokenSecret: twitterSession.secret
    );

    Future twitterRequest = _twitterOauth.getTwitterRequest(
      // Http Method
      "GET", 
      // Endpoint you are trying to reach
      "account/verify_credentials.json", 
      // The options for the request
      options: {
        "include_email": "true",
        "skip_status" : "true"
      },
    );

    // Wait for the future to finish
    var res = await twitterRequest;
    
    final decodedResponse = Map<String, dynamic>.from(json.decode(res.body));

    await PrefManager.saveLoginType("TWITTER");

    return {
      "name" : decodedResponse["name"],
      "email" : decodedResponse["email"],
      "photoUrl" : decodedResponse["profile_image_url_https"].toString().replaceFirst("_normal", "") //get fullsize image
    };
  }

   Future<Map<String, String>> getProfileFromFacebook() async{
    // Trigger the sign-in flow
    final LoginResult result = await FacebookAuth.instance.login(); 

    if(result.status != 200){
      throw("Failed to Login. Please try again");
    }

    final token = result.accessToken.token;
    final graphResponse = await http.get(
                'https://graph.facebook.com/v2.12/me?fields=name,email,id&access_token=$token');
    final profile = Map<String, dynamic>.from(json.decode(graphResponse.body)).cast<String, String>();
    await PrefManager.saveLoginType("FACEBOOK");
    return {
      "name" : profile["name"],
      "email" : profile["email"],
      "photoUrl" : "https://graph.facebook.com/${profile["id"]}/picture?access_token=$token"
    };
  }

  Future<void> verifyUserPhoneNumber(String phoneNumber, BuildContext context) async{
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber, 
      verificationCompleted: (PhoneAuthCredential authCredential){}, 
      verificationFailed: (FirebaseAuthException authException){}, 
      codeSent: (String verificationId, int resendToken){
        Navigations.goToScreen(context, CodeVerification(verificationId: verificationId));
      }, 
      codeAutoRetrievalTimeout: (String verificationId){}
    );
  }
   

}