import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venda_mais_client_buy/models/entities/cielo.entities.dart';
import 'package:venda_mais_client_buy/repositories/cielo.repository.interface.dart';


class CieloRepository implements ICieloRepository {

  @override
  Future<CieloData> get() async{
    DocumentSnapshot snapshot = await Firestore.instance.collection("???").document("???").get();

    CieloData cieloData = CieloData.fromDocument(snapshot);
    return cieloData;
  }

}