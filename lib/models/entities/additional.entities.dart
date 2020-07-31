import 'package:cloud_firestore/cloud_firestore.dart';

class Additional {
  String category;
  String id;
  String title;
  double price;
  bool check;

  Additional();
  Additional.fromDocument(DocumentSnapshot snapshot){
    id = snapshot.documentID;
    title = snapshot.data["title"];
    price = snapshot.data["price"] + 0.0;
    check = false;
  }

  Additional.fromMap(Map data){
    title = data["title"];
    price = data["price"] + 0.0;
    check = false;
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "price": price,
    };
  }
}