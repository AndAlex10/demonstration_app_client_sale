
import 'package:cloud_firestore/cloud_firestore.dart';

class DeliverySettings{
  double valueKm;
  double valueFixed;

  DeliverySettings.fromDocument(DocumentSnapshot document){
    valueKm = double.parse(document.data['valueKm'].toString());
    valueFixed = double.parse(document.data['valueFixed'].toString());
  }
}