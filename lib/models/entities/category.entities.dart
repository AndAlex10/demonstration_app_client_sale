

import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryData {
  String id;
  String name;
  String icon;
  String image;
  int order;

  CategoryData();
  CategoryData.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    name = document.data['name'];
    order = document.data['order'];
    icon = document.data['icon'];
    image = document.data['imgUrl'];
  }
}