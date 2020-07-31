
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venda_mais_client_buy/repositories/maps.repository.intefarce.dart';

const URL_DISTANCE_MATRIX = 'https://maps.googleapis.com/maps/api/distancematrix/json?';

class MapsRepository implements IMapsRepository {

  @override
  Future<String> getKeyMap() async{
    DocumentSnapshot snapshot = await Firestore.instance.collection("???").document("???").get();
    return snapshot.data["???"];
  }

  @override
  Future<int> getMapDistance(String origin, String destiny) async {
    String key = "&key=" + await getKeyMap();
    http.Response response;
    try {
      response = await http.get(
          URL_DISTANCE_MATRIX + 'origins=${origin}&destinations=$destiny' +
              key);
    } catch(e){
      print(e);
      return null;
    }
    Map data = json.decode(response.body);
    return data['rows'][0]['elements'][0]['distance']['value'];
  }
}