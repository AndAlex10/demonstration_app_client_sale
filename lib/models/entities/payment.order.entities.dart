import 'package:venda_mais_client_buy/models/entities/payment.card.entities.dart';
import 'package:venda_mais_client_buy/models/entities/payments.delivery.entities.dart';

class PaymentOrder{
  String title;
  String cardNumber;
  String method;
  String image;
  bool inDelivery;
  String customerName;
  String token;
  String brand;
  String securityCode;
  String paymentId;
  String authorizationCode;

  PaymentOrder();
  PaymentOrder.fromMap(Map data){
    title = data['title'];
    method = data['method'];
    cardNumber = data['cardNumber'];
    inDelivery = data['inDelivery'];
    paymentId = data['paymentId'];
    image = data['image'];
  }


  PaymentOrder.fromCard(PaymentCard data){
    title = "Crédito pelo Aqui Tem";
    method = "card";
    cardNumber = data.cardNumber;
    inDelivery = false;
    image = data.image;
    customerName = data.customerName;
    token = data.token;
    brand = data.brand;
    securityCode = data.securityCode;
  }

  PaymentOrder.fromDelivery(PaymentDelivery data){
    title = data.title;
    method = data.method;
    cardNumber = "";
    inDelivery = true;
    image = data.image;
  }

  Map<String, dynamic> toMap(){
    return {
      "title": title,
      "inDelivery": inDelivery,
      "method": method,
      "cardNumber": cardNumber,
      "image": image,
      "paymentId": paymentId,
      "authorizationCode": authorizationCode,
      "brand": brand
    };
  }
}