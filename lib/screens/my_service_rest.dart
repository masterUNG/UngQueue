import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ungqueue/models/user_model.dart';
import 'package:ungqueue/utility/my_style.dart';
import 'package:ungqueue/utility/normal_dialog.dart';
import 'package:ungqueue/widget/detail_restaurant.dart';
import 'package:ungqueue/widget/grid_desk.dart';

class MyServiceRest extends StatefulWidget {
  @override
  _MyServiceRestState createState() => _MyServiceRestState();
}

class _MyServiceRestState extends State<MyServiceRest> {
  String nameLogin;
  UserModel userModel;
  Widget currentWidget = GridDesk();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readLogin();
    aboutNotification();
  }

  Future<Null> aboutNotification() async {
    FirebaseMessaging messaging = FirebaseMessaging();
    messaging.configure(
      onMessage: (message) {
        normalDialog(context, 'You Have Message');
      },
      onResume: (message) {
         normalDialog(context, 'onResume Workd');
        print('################# OnResume Work ###############');
      },
      onLaunch: (message) {
         normalDialog(context, 'onLaunch Work');
        print('################# OnLaunch Work ###############');
      },
    );
  }

  Future<Null> readLogin() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        String uid = event.uid;
        print('uid = $uid');
        await FirebaseFirestore.instance
            .collection('user')
            .doc(uid)
            .snapshots()
            .listen((event) {
          setState(() {
            userModel = UserModel.fromMap(event.data());
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyStyle().primaryColor,
        title: Text('Service for Restaurant'),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            Column(
              children: [
                buildUserAccountsDrawerHeader(),
                buildDesk(),
                buildDetail(),
              ],
            ),
            MyStyle().buildSignOut(context),
          ],
        ),
      ),
      body: currentWidget,
    );
  }

  ListTile buildDesk() => ListTile(
        leading: Icon(Icons.restaurant),
        title: Text('โต้ะของร้าน'),
        subtitle: Text('จำนวนโต้ะ ของร้าน'),
        onTap: () {
          setState(() {
            currentWidget = GridDesk();
          });
          Navigator.pop(context);
        },
      );

  ListTile buildDetail() => ListTile(
        leading: Icon(Icons.details_sharp),
        title: Text('รายละเอียดของร้าน'),
        subtitle: Text('เพิ่ม หรือ ปรับปรุ่ง รายละเอียด ของร้าน'),
        onTap: () {
          setState(() {
            currentWidget = DetailResaurnt();
          });

          Navigator.pop(context);
        },
      );

  UserAccountsDrawerHeader buildUserAccountsDrawerHeader() {
    return UserAccountsDrawerHeader(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/wall.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        currentAccountPicture: Image.asset('images/logo.png'),
        accountName: MyStyle()
            .buildTitleH2(userModel == null ? 'Name Rest' : userModel.name),
        accountEmail: MyStyle().buildTitleH2('Restaurant'));
  }
}
