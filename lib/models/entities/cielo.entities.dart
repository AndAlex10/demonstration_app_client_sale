
import 'package:cloud_firestore/cloud_firestore.dart';

class CieloData {
  String id;
  String merchantId;
  String merchantKey;

  CieloData();
  CieloData.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    merchantId = document.data['merchantId'];
    merchantKey = document.data['merchantKey'];
  }
}