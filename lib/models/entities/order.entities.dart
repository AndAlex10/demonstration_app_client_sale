import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venda_mais_client_buy/models/entities/additional.entities.dart';
import 'package:venda_mais_client_buy/models/entities/cart.entities.dart';
import 'package:venda_mais_client_buy/models/entities/establishment.entities.dart';
import 'package:venda_mais_client_buy/models/entities/payment.order.entities.dart';
import 'package:venda_mais_client_buy/models/entities/user.entities.dart';


class OrderData {

  String id;
  int orderCode;
  String idEstablishment;
  String nameEstablishment;
  String clientId;
  Timestamp dateCreate;
  Timestamp dateUpdate;
  int status;
  bool goGet;
  String address;
  String number;
  String neighborhood;
  String complement;
  String city;
  String state;
  String phone;
  String codePostal;
  String longitude;
  String latitude;
  String reason;
  String reasonBy;
  double amount;
  double productsPrice;
  double shipPrice;
  int distance;
  double commissionDelivery;
  double discount;
  double change;
  String delivery;
  List<Items> items = [];
  List historic = [];
  String historicText;
  String nameClient;
  String imgUrlEstableshiment;

  double rating;

  PaymentOrder payment;

  OrderData();



  OrderData.fromDocument(DocumentSnapshot snapshot){
    id = snapshot.documentID;
    orderCode = snapshot.data['orderCode'];
    idEstablishment = snapshot.data['idEstablishment'];
    nameEstablishment = snapshot.data['nameEstablishment'];
    clientId = snapshot.data['clientId'];
    dateCreate = snapshot.data['dateCreate'];
    dateUpdate = snapshot.data['dateUpdate'];
    goGet = snapshot.data['goGet'];
    status = snapshot.data['status'];
    address = snapshot.data['address'];
    number = snapshot.data['number'];
    neighborhood = snapshot.data['neighborhood'];
    complement = snapshot.data['complement'];
    city = snapshot.data['city'];
    state = snapshot.data['state'];
    phone = snapshot.data['phone'];
    codePostal = snapshot.data['codePostal'];
    longitude = snapshot.data['longitude'];
    latitude = snapshot.data['latitude'];
    reason = snapshot.data['reason'];
    reasonBy = snapshot.data['reasonBy'];
    amount = double.parse(snapshot.data['amount'].toString());
    productsPrice = double.parse(snapshot.data['productsPrice'].toString());
    shipPrice = double.parse(snapshot.data['shipPrice'].toString());
    discount = double.parse(snapshot.data['discount'].toString());
    change = double.parse(snapshot.data['change'].toString());
    payment = PaymentOrder.fromMap(snapshot.data['payment']);
    delivery = snapshot.data['delivery'];
    imgUrlEstableshiment = snapshot.data['imgUrlEstableshiment'];
    rating = snapshot.data['rating'];

    if(rating == null) {
      rating = 0.0;
    }

    if(reason == null) {
      reason = '';
    }

    if(reasonBy == null) {
      reasonBy = '';
    }

    historicText = "";
    if(snapshot.data['historic'] != null) {
      List list = snapshot.data['historic'];
      for(int i = 0; i < list.length; i++){
        historicText += "${list[i]} \n";
        historic.add(list[i]);
      }
    }


    for (var i = 0; i < snapshot.data["products"].length; i++) {
      Items item = Items.fromDocument(snapshot.data["products"][i]);
      items.add(item);
    }

  }

  OrderData.fromDocumentUser(DocumentSnapshot snapshot){
    id = snapshot.data['orderId'];
    orderCode = snapshot.data['orderCode'];
  }


  OrderData.setData(EstablishmentData establishmentData, int codeOrder, UserEntity user, PaymentOrder payment, List<CartProduct> cartList,
     double amount, double productsPrice, double shipPrice, int distance, double commissionDelivery, double discount, double change){
    this.idEstablishment = establishmentData.id;
    this.nameEstablishment = establishmentData.name;
    this.imgUrlEstableshiment = establishmentData.imgUrl;
    orderCode = codeOrder;
    clientId = user.id;
    dateCreate = Timestamp.now();
    dateUpdate = Timestamp.now();
    goGet = false;
    status = 0;
    phone = user.phone;
    reason = "";
    reasonBy = "";
    this.amount = amount;
    this.productsPrice = productsPrice;
    this.shipPrice = shipPrice;
    this.distance = distance;
    this.commissionDelivery = commissionDelivery;
    this.discount = discount;
    this.change = change;
    this.payment = payment;
    delivery = "";

    for (var i = 0; i < user.addressList.length; i++) {
      if(user.addressList[i].defaultAddress) {
        address = user.addressList[i].address;
        number = user.addressList[i].number;
        neighborhood = user.addressList[i].neighborhood;
        complement = user.addressList[i].complement;
        city = user.addressList[i].city;
        state = user.addressList[i].state;
        codePostal = user.addressList[i].codePostal;
        longitude = user.addressList[i].longitude;
        latitude = user.addressList[i].latitude;
      }
    }

    historicText = "";


    for (var i = 0; i < cartList.length; i++) {
      Items item = Items.setData(cartList[i]);
      items.add(item);
    }

  }

  void setHistoricText(){
    historicText = "";
    for(int i = 0; i < historic.length; i++){
      historicText += "${historic[i]} \n";
    }
  }

  Map<String, dynamic> toMap(){
    return {
      "idEstablishment": idEstablishment,
      "nameEstablishment": nameEstablishment,
      "orderCode": orderCode,
      "clientId": clientId,
      "dateCreate": dateCreate,
      "dateUpdate": dateUpdate,
      "goGet": goGet,
      "address": address,
      "number": number,
      "neighborhood": neighborhood,
      "complement": complement,
      "city": city,
      "state": state,
      "phone": phone,
      "codePostal": codePostal,
      "longitude": longitude,
      "latitude": latitude,
      "reason": reason,
      "reasonBy": reasonBy,
      "amount": amount,
      "productsPrice": productsPrice,
      "shipPrice": shipPrice,
      "distance": distance,
      "commissionDelivery": commissionDelivery,
      "discount": discount,
      "change": change,
      "payment": payment.toMap(),
      "change": change,
      "historic": historic,
      "status": status,
      "rating": rating,
      "imgUrlEstableshiment": imgUrlEstableshiment,
      "products": toMapItems()
    };
  }


  List<Map<String, dynamic>> toMapItems(){
    List<Map<String, dynamic>> list = [];
    for (var i = 0; i < items.length; i++) {
      list.add(items[i].toMapProduct());
    }
    return list;
  }

}

class Items {
  String title;
  int quantity;
  double price;
  double amount;
  String obs;
  List<Additional> additionalList = [];

  Items();
  Items.setData(CartProduct item) {
    quantity = item.quantity;
    obs = item.obs;
    amount = item.amount;

    if (item.productData.options) {
      for (var i = 0; i < item.productData.optionsList.length; i++) {
        if(item.productData.optionsList[i].check){
          title = item.productData.optionsList[i].title;
          price = item.productData.optionsList[i].price;
        }
      }
    } else {
      title = item.productData.title;
      price = item.productData.price;

      if (item.productData.additionalList.length > 0) {
        additionalList =  item.productData.additionalList;
      }
    }

  }

  Items.fromDocument(Map document) {
    title = document['product']['title'];
    quantity = document['quantity'];
    price = double.parse(document['product']['price'].toString());
    amount = price;
    obs = document['obs'];

    if (document["additional"] != null) {
      for (var i = 0; i < document["additional"].length; i++) {
        Additional additional = Additional.fromMap(document["additional"][i]);
        amount += additional.price;
        additionalList.add(additional);
      }
    }
    amount = amount * quantity;
  }

  Map<String, dynamic> toMapProduct(){
    return {
      "product": {"title": title, "price": price},
      "obs": obs,
      "quantity": quantity,
      "additional": toMapAdditional()
    };
  }

  List<Map<String, dynamic>> toMapAdditional(){
    List<Map<String, dynamic>> list = [];
    for (var i = 0; i < additionalList.length; i++) {
      if(additionalList[i].check){
        Map<String, dynamic> data = {"title": additionalList[i].title, "price": additionalList[i].price};
        list.add(data);
      }
    }
    return list;
  }
}
