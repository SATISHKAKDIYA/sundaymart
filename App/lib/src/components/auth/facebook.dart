import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';

class Facebook extends StatefulWidget {
  final Function(String, String, String, String)? onSubmit;
  Facebook({this.onSubmit});

  @override
  FacebookState createState() => FacebookState();
}

class FacebookState extends State<Facebook> {
  Future<void> logOut() async {
    await FacebookAuth.instance.logOut();
  }

  Future<UserCredential> signInWithFacebook() async {
    AccessToken? accessToken = await FacebookAuth.instance.accessToken;
    if (accessToken == null) {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();

        widget.onSubmit!(userData['id'], userData['name'], userData['email'],
            userData['picture']['data']['url']);
      }

      accessToken = loginResult.accessToken;
    } else {
      final userData = await FacebookAuth.instance.getUserData();

      widget.onSubmit!(userData['id'], userData['name'], userData['email'],
          userData['picture']['data']['url']);
    }

    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(accessToken!.token);

    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
          color: Get.isDarkMode ? Color.fromRGBO(37, 48, 63, 1) : Colors.white,
          borderRadius: BorderRadius.circular(20)),
      child: TextButton(
          onPressed: signInWithFacebook,
          child: Icon(
            const IconData(0xecbd, fontFamily: 'MIcon'),
            size: 24.sp,
            color: Get.isDarkMode
                ? Color.fromRGBO(130, 139, 150, 1)
                : Color.fromRGBO(136, 136, 126, 1),
          )),
    );
  }
}
