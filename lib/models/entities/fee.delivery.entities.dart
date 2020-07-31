

import 'package:cloud_firestore/cloud_firestore.dart';

class FeeDelivery {
  String id;
  double min;
  double max;
  double value;

  FeeDelivery();
  FeeDelivery.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    min = double.parse(document.data['min'].toString());
    max = double.parse(document.data['max'].toString());

    value = double.parse(document.data['value'].toString());
  }
}