import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungqueue/models/restaurant_model.dart';
import 'package:ungqueue/screens/detail_restaurant_user.dart';
import 'package:ungqueue/utility/my_style.dart';
import 'package:ungqueue/widget/detail_restaurant.dart';

class ListRestaurnat extends StatefulWidget {
  @override
  _ListRestaurnatState createState() => _ListRestaurnatState();
}

class _ListRestaurnatState extends State<ListRestaurnat> {
  List<RestaurantModel> restaurantModels = List();
  List<Widget> widgets = List();
  List<String> uidRests = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData();
  }

  Future<Null> readData() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('restaurant')
          .snapshots()
          .listen((event) {
        int index = 0;
        for (var item in event.docs) {
          String uidRest = item.id;
          uidRests.add(uidRest);

          RestaurantModel model = RestaurantModel.fromMap(item.data());
          restaurantModels.add(model);
          setState(() {
            widgets.add(createWidget(model, index));
          });
          index++;
        }
      });
    });
  }

  Widget createWidget(RestaurantModel model, int index) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailRestaurantUser(
                model: restaurantModels[index],uidRest: uidRests[index],
              ),
            ),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
            child: Text(model.name),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgets.length == 0
          ? MyStyle().showProgress()
          : GridView.extent(
              maxCrossAxisExtent: 160,
              children: widgets,
            ),
    );
  }
}
