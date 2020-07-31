import 'package:cloud_firestore/cloud_firestore.dart';
class PaymentDelivery {
  String id;
  String title;
  String type;
  String method;
  bool active;
  String image;
  int order;

  PaymentDelivery();

  PaymentDelivery.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    title = document.data['title'];
    type = document.data['type'];
    method = document.data['method'];
    active = document.data['active'];
    order = document.data['order'];
    image = 'images/methodspayment/' + method + '.png';
  }

  PaymentDelivery.fromMap(Map data){
    id = data['id'];
    title = data['title'];
    type = data['type'];
    method = data['method'];
    active = data['active'];
    order = data['order'];
    image = 'images/methodspayment/' + method + '.png';
  }

  Map<String, dynamic> toMap(){
    return {
      "id": id,
      "title": title,
      "type": type,
      "method": method,
      "active": active,
    };
  }
}