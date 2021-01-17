import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ungqueue/models/restaurant_model.dart';
import 'package:ungqueue/utility/normal_dialog.dart';

class DetailResaurnt extends StatefulWidget {
  @override
  _DetailResaurntState createState() => _DetailResaurntState();
}

class _DetailResaurntState extends State<DetailResaurnt> {
  String token;
  String uidLogin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    findToken();
    findUidLogin();
  }

  Future<Null> findUidLogin() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) {
        uidLogin = event.uid;
        print('uidLogin = $uidLogin');
      });
    });
  }

  Future<Null> findToken() async {
    FirebaseMessaging messaging = FirebaseMessaging();
    await messaging.getToken().then((value) {
      setState(() {
        token = value;
      });
      print('token = $token');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(token == null ? 'Find Token' : 'Token = $token'),
          ElevatedButton(
              onPressed: () {
                updateTokenToFirebase();
              },
              child: Text('Update Token To Firebase'))
        ],
      ),
    );
  }

  Future<Null> updateTokenToFirebase() async {
    // RestaurantModel model = RestaurantModel(token: token);
    Map<String, dynamic> data = Map();
    data['token'] = token;
    print('########### data ===>> ${data.toString()}');

    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('restaurant')
          .doc(uidLogin)
          .update(data)
          .then((value) => normalDialog(context, 'Update Token Success'));
    });
  }
}
