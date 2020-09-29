import 'package:auth_app/models/app_user.dart';
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

//Repository to handle login and signup
class AuthRepo {
  static final _firestore = FirebaseFirestore.instance;
  static final _firebaseAuth = FirebaseAuth.instance;

  static final TwitterLogin _twitterLogin = new TwitterLogin(
    consumerKey: 'a8VunpkaJEI8h6lkHt2fudB3c',
    consumerSecret:'jLQ9qnm5ViNu7x03wMbsqt19qurrlGk2sWxNa7p62JGNWnqEl5',
  );

  static User getCurrentUser(){
    return _firebaseAuth.currentUser;
  }

  static Future<AppUser> getCurrentUserDetails() async{
    final _querySnapshot = await _firestore.collection("users").where("email", isEqualTo: getCurrentUser().email).get();
    final docData = _querySnapshot.docs[0].data();
    return AppUser.fromMap(docData);
  }

  static bool isUserLoggedIn(){
    return _firebaseAuth.currentUser != null;
  }

  static Future<void> logoutUser() async{
    switch (await PrefManager.getLoginType()) {
      case "EMAIL":  
        await _firebaseAuth.signOut();
        break;

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
      
    }
  }

  // signin methods
  static Future<void> signInWithgoogle() async{
    final googleAuthCredential = await _getGoogleAuthCredentials();
    final userCredential = await _firebaseAuth.signInWithCredential(googleAuthCredential);

    final user = userCredential.user; 

    //check if user details are saved in firestore
    if( !(await _userDetailsExist(user.email))){   
      final appUser = AppUser(
        email: user.email,
        username: user.displayName,
        phoneNumber: user.phoneNumber,
        photoUrl: user.photoURL
      );   
      //save user dtails to firestore
      await _saveUserDetailsToFirestore(appUser: appUser);
    }
  }

  static Future<void> signInWithTwitter() async{
    final twitterAuthCredential = await _getTwitterAuthCredentials();
    final userCredential = await _firebaseAuth.signInWithCredential(twitterAuthCredential);

    final user = userCredential.user;

    //check if user details are saved in firestore
    if( !(await _userDetailsExist(user.email))){      
      final appUser = AppUser(
        email: user.email,
        username: user.displayName,
        phoneNumber: user.phoneNumber,
        photoUrl: user.photoURL
      );
      //save user details to firestore
      await _saveUserDetailsToFirestore(appUser: appUser);
    }
  }

//signin with registered email and password
  static Future<UserCredential> signInWithFirebase(String email, String password) async{
    return await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  //sign up with email and password
  static Future<void> signUpWithFirebase(AppUser appUser, String password) async{
    await _firebaseAuth.createUserWithEmailAndPassword(email: appUser.email, password: password);
    await _saveUserDetailsToFirestore(appUser: appUser);
  }

  static Future<void> signInWithFacebook() async{
    final facebookAuthCredential = await _getFacebookAuthCredentials();
    final userCredential = await _firebaseAuth.signInWithCredential(facebookAuthCredential);

    final user = userCredential.user;

    //check if user details are saved in firestore
    if( !(await _userDetailsExist(user.email))){   
      final appUser = AppUser(
        email: user.email,
        username: user.displayName,
        phoneNumber: user.phoneNumber,
        photoUrl: user.photoURL
      );
      //save user details to firestore
      await _saveUserDetailsToFirestore(appUser: appUser);
    }

  }

  static Future<void> _saveUserDetailsToFirestore({@required AppUser appUser}) async{
    await _firestore.collection("users").doc(appUser.email).set(appUser.toMap());
  }

  static Future<GoogleAuthCredential> _getGoogleAuthCredentials() async{
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

      // Once signed in, return the UserCredential
    return credential;
  }

  static Future<TwitterAuthCredential> _getTwitterAuthCredentials() async{
    

    // Trigger the sign-in flow
    final TwitterLoginResult loginResult = await _twitterLogin.authorize();

    // Get the Logged In session
    final TwitterSession twitterSession = loginResult.session;

    // Create a credential from the access token
    final AuthCredential twitterAuthCredential =
      TwitterAuthProvider.credential(accessToken: twitterSession.token, secret: twitterSession.secret);

    // Once signed in, return the UserCredential
    return twitterAuthCredential;
  }

  static Future<FacebookAuthCredential> _getFacebookAuthCredentials() async{
    // Trigger the sign-in flow
  final LoginResult result = await FacebookAuth.instance.login(); 

  // Create a credential from the access token
  final FacebookAuthCredential facebookAuthCredential =
    FacebookAuthProvider.credential(result.accessToken.token);

  // Once signed in, return the UserCredential
  return facebookAuthCredential;
  }

  static Future<bool> _userDetailsExist(String email) async{
    final querySnapshot = await _firestore.collection("users")
                                          .where("email", isEqualTo: email).get();

    return querySnapshot.docs.length > 0;
  }
   

}