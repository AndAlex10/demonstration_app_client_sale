import 'dart:async';
import 'package:google_maps_webservice/places.dart';
import 'package:venda_mais_client_buy/components/connect.component.dart';
import 'package:venda_mais_client_buy/models/entities/address.entities.dart';
import 'package:venda_mais_client_buy/models/entities/establishment.entities.dart';
import 'package:venda_mais_client_buy/models/response/validate.response.dart';
import 'package:venda_mais_client_buy/repositories/maps.repository.dart';
import 'package:venda_mais_client_buy/repositories/maps.repository.intefarce.dart';

class MapsComponent {

  GoogleMapsPlaces places;
  IMapsRepository repository;
  ConnectComponent connect;
  String key;

  MapsComponent(){
    repository = new MapsRepository();
    connect = new ConnectComponent();
  }

  MapsComponent.tests(this.repository, this.connect);

  Future<ValidateResponse> getKeyMap() async{
    ValidateResponse response = new ValidateResponse();
    if(await connect.checkConnect()) {
      key = await repository.getKeyMap();
      places = GoogleMapsPlaces(apiKey: key);
      response.success = true;
    } else {
      response.failConnect();
    }

    return response;
  }

  void dispose() {
    places.dispose();
  }

  Future<PlacesDetailsResponse> getPlaceDetail(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId);
      dispose();
      return detail;
    }
    return null;

  }

  Future<PlacesDetailsResponse> getPlace(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId);
      return detail;
    }

    return null;

  }

  Future<int> getMapDistance(EstablishmentData establishmentData, Address address) async {
    if(await connect.checkConnect()) {
      return await repository.getMapDistance(
          "${establishmentData.latitude},${establishmentData.longitude}",
          "${address.latitude},${address.longitude}");
    } else {
      return null;
    }
  }

  bool validateAddress(PlacesDetailsResponse response){
    if(response.result.types.contains("route") || response.result.types.contains("establishment")){
      return true;
    } else {
      return false;
    }

  }




}