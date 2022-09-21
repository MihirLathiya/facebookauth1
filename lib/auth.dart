import 'dart:developer';

import 'package:facebookauth/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class LoginFacebook extends StatefulWidget {
  const LoginFacebook({Key? key}) : super(key: key);

  @override
  State<LoginFacebook> createState() => _LoginFacebookState();
}

class _LoginFacebookState extends State<LoginFacebook> {
  bool isLogin = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: isLogin == true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isLogin = true;
                    });
                    facebookLogin();
                  },
                  child: Text('Login With Facebook'),
                ),
        ),
      ),
    );
  }

  facebookLogin() async {
    try {
      final result = await FacebookAuth.instance
          .login(permissions: ['public_profile', 'email']);

      if (result.status == LoginStatus.success) {
        log('RESPONSE');
        OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        log('RESPONSE1');

        await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);
        log('RESPONSE2');

        final userData = await FacebookAuth.instance.getUserData();
        print('facebook_login_data:- $userData');
        print('facebook_login_data:- $facebookAuthCredential');
        // await FirebaseFirestore.instance
        //     .collection('User')
        //     .doc(FirebaseAuth.instance.currentUser!.uid)
        //     .set({
        //   'image': userData['picture']['data']['url'],
        //   'name': userData['name'],
        //   'email': userData['email'],
        // });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              image: userData['picture']['data']['url'],
              name: userData['name'],
              email: userData['email'],
            ),
          ),
        );
        setState(() {
          isLogin = false;
        });
      }
    } catch (error) {
      print('ERRORRRRRR $error');
      setState(() {
        isLogin = false;
      });
    }
  }
}
