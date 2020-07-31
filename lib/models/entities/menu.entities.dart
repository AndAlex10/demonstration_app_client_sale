import 'package:cloud_firestore/cloud_firestore.dart';
class MenuData {
  String id;
  String name;
  int order;
  String idCategoryAdditional;

  MenuData();
  MenuData.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    name = document.data['name'];
    order = document.data['order'];
    idCategoryAdditional = document.data["idCategoryAdditional"];
  }
}