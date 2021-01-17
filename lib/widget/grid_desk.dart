import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungqueue/models/restaurant_model.dart';
import 'package:ungqueue/models/user_model.dart';
import 'package:ungqueue/utility/my_style.dart';
import 'package:ungqueue/utility/normal_dialog.dart';

class GridDesk extends StatefulWidget {
  @override
  _GridDeskState createState() => _GridDeskState();
}

class _GridDeskState extends State<GridDesk> {
  int amountDesk;
  String amountString;
  String uid, nameRestaurant;
  bool statusLoad = true;
  bool statusNoData = true;
  RestaurantModel restaurantModel;
  List<Widget> widgets = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findDesk();
  }

  Future<Null> findDesk() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        uid = event.uid;

        await FirebaseFirestore.instance
            .collection('user')
            .doc(uid)
            .snapshots()
            .listen((event) {
          UserModel model = UserModel.fromMap(event.data());
          nameRestaurant = model.name;
        });

        await FirebaseFirestore.instance
            .collection('restaurant')
            .doc(uid)
            .snapshots()
            .listen((event) {
          if (event.data() != null) {
            print('Restaurant Have data');
            setState(() {
              restaurantModel = RestaurantModel.fromMap(event.data());
              statusNoData = false;
              for (var i = 1; i <= restaurantModel.amountdesk; i++) {
                widgets.add(createWidget(i));
              }
            });
          } else {
            print('Restaurant No data');
          }
          setState(() {
            statusLoad = false;
          });
        });
      });
    });
  }

  Widget createWidget(int deskNumber) => Card(
        child: Text('โต้ะ $deskNumber'),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          statusNoData ? buildFloatingActionButton() : SizedBox(),
      body: statusLoad
          ? MyStyle().showProgress()
          : statusNoData
              ? Center(child: MyStyle().buildTitleH1('ยังไม่มี ข้อมูล โต้ะ'))
              : buildGridViewDesk(),
    );
  }

  Widget buildGridViewDesk() => GridView.extent(
        maxCrossAxisExtent: 160,
        children: widgets,
      );

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: MyStyle().dartColor,
      onPressed: () => addDeskDialog(),
      child: Icon(Icons.settings),
    );
  }

  Future<Null> addDeskDialog() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          leading: Image.asset('images/logo.png'),
          title: Text('โปรดกรอก จำนวนโต้ะ'),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: TextField(
              onChanged: (value) => amountString = value.trim(),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (amountString?.isEmpty ?? true) {
                    normalDialog(context, 'กรุณากรอก จำนวนโต้ะด้วย คะ');
                  } else {
                    amountDesk = int.parse(amountString);
                    addDeskThread();
                  }
                },
                child: Text('Add Desk'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<Null> addDeskThread() async {
    RestaurantModel model = RestaurantModel(amountdesk: amountDesk, name: nameRestaurant);

    Map<String, dynamic> data = model.toMap();

    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('restaurant')
          .doc(uid)
          .set(data)
          .then((value) {
        statusNoData = true;
        findDesk();
      });
    });
  }
}
