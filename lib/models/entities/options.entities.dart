import 'package:cloud_firestore/cloud_firestore.dart';

class OptionsData {
  String id;
  String title;
  double price;
  bool check;

  OptionsData();
  OptionsData.fromDocument(DocumentSnapshot snapshot){
    id = snapshot.documentID;
    title = snapshot.data["title"];
    price = snapshot.data["price"] + 0.0;
    check = false;
  }
}