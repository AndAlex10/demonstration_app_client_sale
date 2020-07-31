

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venda_mais_client_buy/utils/card.number.brand.dart';
import 'package:venda_mais_client_buy/utils/utils.dart';

class PaymentCard {
  String id;
  String cardNumber;
  String customerName;
  String expirationDate;
  String brand;
  String token;
  String securityCode;
  String docNumber;
  int order;
  String image;

  PaymentCard();

  PaymentCard.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    cardNumber = document.data['cardNumber'] != null ? document.data['cardNumber'] : '' ;
    docNumber = document.data['docNumber'];
    customerName = document.data['customerName'];
    expirationDate = document.data['expirationDate'];
    brand = document.data['brand'] != null ? document.data['brand'] : "";
    token = document.data['token'] != null ? document.data['token'] : '';
    order = document.data['order'];
    securityCode = Utils.decrypt(document.data['number']);
    if(brand != "") {
      image = CardBrand.getBrandImage(brand);
    }
  }

    populate(String cardNumber, docNumber, customerName, expirationDate, securityCode){
    this.cardNumber = cardNumber.replaceAll(" ", "");
    this.docNumber = docNumber;
    this.customerName = customerName;
    this.expirationDate = expirationDate;
    this.securityCode = securityCode;
  }

  Map<String, dynamic> toMap() {
    return {
      'cardNumber': cardNumber,
      "docNumber": docNumber,
      'customerName': customerName,
      'expirationDate': expirationDate,
      "number": securityCode,
      'token': token,
      "order": order,
      "brand": brand
    };
  }
}