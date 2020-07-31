import 'package:cloud_firestore/cloud_firestore.dart';

class EstablishmentData {
  String id;
  String name;
  String address;
  String number;
  String neighborhood;
  String complement;
  String city;
  String state;
  String phone;
  String cnpj;
  String codePostal;
  String instagram;
  String longitude;
  String latitude;
  String type;
  double rating;
  bool open;
  int sequence;
  String feeDelivery;
  bool fee = false;
  String imgUrl;

  EstablishmentData();

  EstablishmentData.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    name = document.data['name'];
    address = document.data['address'];
    number = document.data['number'];
    neighborhood = document.data['neighborhood'];
    complement = document.data['complement'];
    city = document.data['city'];
    state = document.data['state'];
    phone = document.data['phone'];
    cnpj = document.data['cnpj'];
    codePostal = document.data['codePostal'];
    instagram = document.data['instagram'];
    longitude = document.data['longitude'];
    latitude = document.data['latitude'];
    open = document.data['open'];
    imgUrl = document.data['imgUrl'];
    if(document.data['rating'] != null) {
      rating = double.parse(document.data['rating'].toString());
    } else {
      rating = 0.00;
    }
    type = document.data['type'];
    sequence = document.data['sequence'];

  }


  Map<String, dynamic> toMap(){
    return {
      "name": name,
      "address": address,
      "number": number,
      "neighborhood": neighborhood,
      "complement": complement,
      "state": state,
      "city": city,
      "phone": phone,
      "codePostal": codePostal,
      "instagram": instagram,
      "cnpj": cnpj,
      "open": open,
      "latitude": latitude,
      "longitude": longitude,
      "sequence": sequence,

    };
  }

  void setFee(double max, double value){
    if(value > 0){
      feeDelivery = "Taxa a partir de R\$${value.toStringAsFixed(2)}";
    } else {
      double km = max / 1000;
      feeDelivery = " até ${km.toStringAsFixed(1)} km";
      fee = true;
    }
  }

}
