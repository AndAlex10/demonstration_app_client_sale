import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_webservice/places.dart';

class Address {
  String id;
  String address;
  String number;
  String neighborhood;
  String complement;
  String city;
  String state;
  String codePostal;
  String longitude;
  String latitude;
  bool defaultAddress;
  int order;

  Address();

  Address.fromJson(PlacesDetailsResponse detail, double lat, double long, int order){
    this.order = order;
    latitude = lat.toString();
    longitude = long.toString();
    for (var i = 0; i < detail.result.addressComponents.length; i++) {
      AddressComponent addressComponent =  detail.result.addressComponents[i];
      for (var h = 0; h <
          addressComponent.types.length; h++) {
        if (addressComponent.types[h] == 'street_number')
          number = addressComponent.longName;

        if (addressComponent.types[h] == 'route')
          address = addressComponent.longName == null ? "" : addressComponent.longName;

        if (addressComponent.types[h] ==
            'sublocality_level_1')
          neighborhood = addressComponent.longName == null ? "" : addressComponent.longName;

        if (addressComponent.types[h] ==
            'administrative_area_level_2')
          city = addressComponent.longName == null ? "" : addressComponent.longName;

        if (addressComponent.types[h] ==
            'administrative_area_level_1')
          state = addressComponent.longName == null ? "" : addressComponent.longName;

        if (addressComponent.types[h] == 'postal_code')
          codePostal = addressComponent.longName == null ? "" : addressComponent.longName;
      }
    }
    this.number = this.number == null ? "" :  this.number;

    this.defaultAddress = false;
  }

  Address.fromDocument(DocumentSnapshot document){
    id = document.documentID;
    number = document.data['number'] != null ? document.data['number'] : '' ;
    address = document.data['address'];
    neighborhood = document.data['neighborhood'];
    city = document.data['city'];
    complement = document.data['complement'] != null ? document.data['complement'] : '';
    state = document.data['state'];
    codePostal = document.data['codePostal'];
    this.defaultAddress = document.data['defaultAddress'];
    longitude = document.data['longitude'];
    latitude = document.data['latitude'];
    order = document.data['order'];
    defaultAddress = document.data['defaultAddress'];
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'neighborhood': neighborhood,
      'number': number,
      'city': city,
      'state': state,
      'complement': complement,
      'codePostal': codePostal,
      'latitude': latitude,
      'longitude': longitude,
      'defaultAddress': defaultAddress,
      'order': order
    };
  }

}