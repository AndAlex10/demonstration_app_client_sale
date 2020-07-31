import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Coupon {
  String id;
  String code;
  Timestamp dateExpiration;
  String dateExpirationFormat;
  double value;

  Coupon();

  Coupon.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    code = document.data['code'];
    dateExpiration = document.data['dateExpiration'];

    if (document.data['dateExpiration'] != null){
     var formatter = new DateFormat('dd/MM/yyyy');
      dateExpirationFormat = formatter.format(dateExpiration.toDate());
    }

    value = double.parse(document.data['value'].toString());
  }

  Map<String, dynamic> toMap(){
    return {
      "code": code,
      "dateExpiration": dateExpiration,
      "value": value,
    };
  }
}