import 'dart:convert';

import 'package:auth_app/getxcontrollers/logged_in_username.dart';
import 'package:auth_app/models/app_user.dart';
import 'package:auth_app/pages/code_verification.dart';
import 'package:auth_app/providers/file_path_provider.dart';
import 'package:auth_app/repos/user_repo.dart';
import 'package:auth_app/utils/constants.dart';
import 'package:auth_app/utils/methods.dart';
import 'package:auth_app/utils/pref_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:twitter_api/twitter_api.dart';


//Repository to handle login and signup
class AuthRepo {
  final _firestore = FirebaseFirestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;
  final _userRepo = UserRepo();

  final LoggedInUsernameController loggedInUsernameController = Get.put(LoggedInUsernameController());

  final TwitterLogin _twitterLogin = new TwitterLogin(
    consumerKey: 'a8VunpkaJEI8h6lkHt2fudB3c',
    consumerSecret:'jLQ9qnm5ViNu7x03wMbsqt19qurrlGk2sWxNa7p62JGNWnqEl5',
  );

  User getCurrentUser(){
    return _firebaseAuth.currentUser;
  }

  Future<AppUser> getCurrentUserDetails() async{
    final _querySnapshot = await _firestore.collection("users")
        .where("username", isEqualTo: await PrefManager.getLoginUsername()).get();
    final docData = _querySnapshot.docs[0].data();
    return AppUser.fromMap(docData);
  }

  bool isUserLoggedIn(){
    print("CRRENT USER: ${_firebaseAuth.currentUser}");
    return _firebaseAuth.currentUser != null;
  }

  Future<bool> userExists({@required String username}) async{
    final _querySnapshot = await _firestore.collection("users")
        .where("username", isEqualTo: username).get();
    return _querySnapshot.docs.length > 0;
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

      case "APPLE":
      // await 
      await _firebaseAuth.signOut();
      break;

      default:
        await _firebaseAuth.signOut();
      
    }
    PrefManager.clearLoginUsername();
  }

  //signin with registered email and password
  Future<UserCredential> signInWithFirebase(String email, String password) async{
    await PrefManager.saveLoginUsername(email);
    loggedInUsernameController.loggedInUserEmail = email;
    return await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  //sign up with email and password
  Future<void> signUpWithFirebase(BuildContext context, AppUser appUser, String password) async{
    await _firebaseAuth.createUserWithEmailAndPassword(email: appUser.username, password: password);
    await _saveUserDetailsToFirestore(appUser: appUser, context: context);
    await PrefManager.saveLoginUsername(appUser.username);
    loggedInUsernameController.loggedInUserEmail = appUser.username;
  }

  Future<void> _saveUserDetailsToFirestore({@required BuildContext context, @required AppUser appUser}) async{
    final photoPath = Provider.of<FilePathProvider>(context, listen: false).filePath;
    if(photoPath.trim().length > 0 && !photoPath.trim().startsWith("http")){
      final downloadUrl = await _userRepo.uploadFile(filePath: photoPath, folderName: "profile_images");
      appUser.photoUrl = downloadUrl;
    }
    await _firestore.collection("users").doc(appUser.username).set(appUser.toMap());
    Provider.of<FilePathProvider>(context, listen: false).filePath = "";
  }

  Future<void> signUpWIthPhone(BuildContext context, {@required String verificationId, @required String smsCode}) async{
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
    await _saveUserDetailsToFirestore(appUser: appUser, context: context);
    await PrefManager.saveLoginUsername(appUser.username);
    loggedInUsernameController.loggedInUserEmail = appUser.username;
  }

  Future<void> signInWithPhone({@required String verificationId, @required String smsCode}) async{
    // Create a PhoneAuthCredential with the code
    final phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);

    // Sign the user in (or link) with the credential
    await _firebaseAuth.signInWithCredential(phoneAuthCredential);
    await PrefManager.saveLoginUsername(getCurrentUser().phoneNumber);
    loggedInUsernameController.loggedInUserEmail = getCurrentUser().phoneNumber;
  }

  Future<Map<String, String>> getProfileFromGoogle(BuildContext context) async{

    try{
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      
      if(googleUser == null){
        print("GOOGLE USER NULL");
        throw("Google signin cancelled");
      }

      Provider.of<FilePathProvider>(context, listen: false).filePath = googleUser.photoUrl;

      final Map<String, String> profile = {
        "email" : googleUser.email,
        "name" : googleUser.displayName,
      };
      await PrefManager.saveLoginType("GOOGLE");
      await PrefManager.saveLoginUsername(profile["email"]);
      return profile;
    }catch(error){
      print("GOOGEL SIGNIN ERROR: $error");
      throw("Error while signing in with Google");
    }
    
  }

  Future<Map<String, String>> getProfileFromTwitter(BuildContext context) async{

    try{
      // Trigger the sign-in flow
      print("Before Twitter Login");
      final TwitterLoginResult loginResult = await _twitterLogin.authorize();
      print("After Twitter Login");

      if(loginResult.status == TwitterLoginStatus.error){
        throw("Failed to Login. Please try again");
      }

      switch (loginResult.status) {
        case TwitterLoginStatus.loggedIn:
          print("Twitter logged in succesfully");
          break;
        case TwitterLoginStatus.cancelledByUser:
          throw("Twitter login cancelled");
          break;
        case TwitterLoginStatus.error:
          throw("Failed to Login. Please try again");
          break;
      }

      // Get the Logged In session
      final TwitterSession twitterSession = loginResult.session;

      final _twitterOauth = twitterApi(
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
      await PrefManager.saveLoginUsername(decodedResponse["email"]);
      final photoUrl = decodedResponse["profile_image_url_https"].toString().replaceFirst("_normal", "");
      Provider.of<FilePathProvider>(context, listen: false).filePath = photoUrl;

      return {
        "name" : decodedResponse["name"],
        "email" : decodedResponse["email"],
      };
    }catch(error){
      print("TWITTER LOGIN ERROR: $error");
      throw("Error while logging in with Twitter");
    }
  }

   Future<Map<String, String>> getProfileFromFacebook(BuildContext context) async{

    try{ 
      // Trigger the sign-in flow
      final AccessToken accessToken = await FacebookAuth.instance.login(); 

      if(accessToken == null){
        throw("Failed to Login. Please try again");
      }

      final token = accessToken.token;
      final graphResponse = await http.get(
                  'https://graph.facebook.com/v2.12/me?fields=name,email,id&access_token=$token');
      final profile = Map<String, dynamic>.from(json.decode(graphResponse.body)).cast<String, String>();
      await PrefManager.saveLoginType("FACEBOOK");
      await PrefManager.saveLoginUsername(profile["email"]);
      Provider.of<FilePathProvider>(context, listen: false).filePath = "https://graph.facebook.com/${profile["id"]}/picture?access_token=$token";
      
      return {
        "name" : profile["name"],
        "email" : profile["email"],
      };
    }catch(error){
      print("FACEBOOK LOGIN ERROR: $error");
      throw("Error while logging in with Facebook");
    }
  }

  Future<Map<String, String>> getProfileFromApple(BuildContext context) async{
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = Methods.generateNonce();
    final nonce = Methods.sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final Map<String, String> profile = {
      "email" : appleCredential.email,
      "name" : "${appleCredential.givenName ?? ""} ${appleCredential.familyName ?? ""}",
    };
    
    print("CREDENTIAL STATUS: ${appleCredential.state}");
    print("APPLE PROFILE: $profile");

    await PrefManager.saveLoginType("APPLE");
    await PrefManager.saveLoginUsername(profile["email"]);

    return profile;
  }

  Future<void> verifyUserPhoneNumber(String phoneNumber, BuildContext context, {bool isLogin=false, bool isUpdate = false}) async{
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber, 
      verificationCompleted: (PhoneAuthCredential authCredential){}, 
      verificationFailed: (FirebaseAuthException authException){}, 
      codeSent: (String verificationId, int resendToken){
        Navigations.goToScreen(
          context, 
          CodeVerification(verificationId: verificationId, isLogin: isLogin, phoneNumber: phoneNumber, isUpdate: isUpdate,)
        );
      }, 
      codeAutoRetrievalTimeout: (String verificationId){}
    );
  }
   

}