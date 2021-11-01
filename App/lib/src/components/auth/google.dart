// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Google extends StatefulWidget {
  final Function(String, String, String, String)? onSubmit;

  Google({this.onSubmit});

  @override
  GoogleState createState() => GoogleState();
}

class GoogleState extends State<Google> {
  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  @override
  void initState() {
    super.initState();
    googleSignIn.signInSilently();
  }

  Future<void> handleSignOut() => googleSignIn.disconnect();

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    widget.onSubmit!(googleUser.id, googleUser.displayName!, googleUser.email,
        googleUser.photoUrl!);

    return await FirebaseAuth.instance.signInWithCredential(credential);
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
          onPressed: signInWithGoogle,
          child: Icon(
            const IconData(0xedd5, fontFamily: 'MIcon'),
            size: 24.sp,
            color: Get.isDarkMode
                ? Color.fromRGBO(130, 139, 150, 1)
                : Color.fromRGBO(136, 136, 126, 1),
          )),
    );
  }
}
