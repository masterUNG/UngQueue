import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungqueue/screens/authen.dart';

class MyStyle {
  Color dartColor = Color(0xff6c6f00);
  Color primaryColor = Color(0xff9e9d24);
  Color lightColor = Color(0xffd2ce56);

  Column buildSignOut(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ListTile(
          onTap: () async {
            await Firebase.initializeApp().then((value) async {
              await FirebaseAuth.instance
                  .signOut()
                  .then((value) => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Authen(),
                      ),
                      (route) => false));
            });
          },
          leading: Icon(
            Icons.exit_to_app,
            color: Colors.white,
          ),
          title: Text(
            'Sing Out',
            style: TextStyle(color: Colors.white),
          ),
          tileColor: Colors.red.shade700,
        ),
      ],
    );
  }

  Widget showProgress() => Center(child: CircularProgressIndicator());

  Text buildTitleH1(String string) => Text(
        string,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: dartColor,
        ),
      );

      Text buildTitleH2(String string) => Text(
        string,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: dartColor,
        ),
      );

  Container buildLogo() {
    return Container(
      width: 120,
      child: Image.asset('images/logo.png'),
    );
  }

  MyStyle();
}
