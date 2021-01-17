import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungqueue/models/restaurant_model.dart';
import 'package:ungqueue/screens/detail_desk.dart';
import 'package:ungqueue/utility/my_style.dart';

class DetailRestaurantUser extends StatefulWidget {
  final RestaurantModel model;
  final String uidRest;
  DetailRestaurantUser({Key key, this.model, this.uidRest}) : super(key: key);
  @override
  _DetailRestaurantUserState createState() => _DetailRestaurantUserState();
}

class _DetailRestaurantUserState extends State<DetailRestaurantUser> {
  RestaurantModel model;
  List<Widget> widgets = List();
  String uidRest;
  
  Map<String, int> mapAmount = Map();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    model = widget.model;
    uidRest = widget.uidRest;
    readDetailDesk();
  }

  Future<Null> readDetailDesk() async {
    await Firebase.initializeApp().then((value) async {
      for (var i = 1; i <= model.amountdesk; i++) {
        int amount = 0;
        await FirebaseFirestore.instance
            .collection('restaurant')
            .doc(uidRest)
            .collection('deskposition$i')
            .snapshots()
            .listen((event) {
          if (event.docs.length != 0) {
            for (var item in event.docs) {
              if (item.data() != null) {
                amount++;
              } else {}
            }           
            mapAmount[i.toString().trim()] = amount;
          }

          if (i == model.amountdesk) {
            print('############ mapAmount = $mapAmount');
            createWidgets();
          }
        });
      }
    });
  }

  void createWidgets() {
    for (var i = 1; i <= model.amountdesk; i++) {
      setState(() {
        widgets.add(buildCardWidget(i));
      });
    }
  }

  Center buildCardWidget(int i) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        child: GestureDetector(
          onTap: () {
            print('You Click i= $i');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailDesk(
                  model: model,
                  deskPosition: i,
                  uidRest: uidRest,
                ),
              ),
            );
          },
          child: Card(
            child: Column(
              children: [
                Text('โต้ะ $i'),
                mapAmount['$i'] == null
                    ? Text('No Receive')
                    : Text('Have Receive'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyStyle().dartColor,
        title: Text(model == null ? 'Detail Restaurant' : model.name),
      ),
      body: widgets.length == 0
          ? MyStyle().showProgress()
          : GridView.extent(
              maxCrossAxisExtent: 160,
              children: widgets,
            ),
    );
  }
}
