
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venda_mais_client_buy/models/entities/delivery.settings.entities.dart';
import 'package:venda_mais_client_buy/models/entities/fee.delivery.entities.dart';
import 'package:venda_mais_client_buy/repositories/fee.delivery.repository.interface.dart';

class DeliveryRepository implements IDeliveryRepository {

  @override
  Future<List<FeeDelivery>> getAll(String id) async{
    List<FeeDelivery> list = [];
    QuerySnapshot snapshot = await Firestore.instance
        .collection("???")
        .document(id)
        .collection("???")
        .getDocuments();

    FeeDelivery feeDelivery;
    if (snapshot.documents.length > 0){
      for (DocumentSnapshot doc in snapshot.documents) {
        feeDelivery = FeeDelivery.fromDocument(doc);
        list.add(feeDelivery);
      }


    }

    return list;
  }

  @override
  Future<FeeDelivery> getFirst(String id) async{
    FeeDelivery feeDelivery;
    QuerySnapshot snapshot = await Firestore.instance
        .collection("???")
        .document(id)
        .collection("???")
        .orderBy("min")
        .getDocuments();
    if (snapshot.documents.length > 0){
      feeDelivery = FeeDelivery.fromDocument(snapshot.documents[0]);
    }

    return feeDelivery;
  }

  @override
  Future<double> getCommissionDelivery(int distance) async{
    try {
      DocumentSnapshot doc = await Firestore.instance.collection("???")
          .document("???")
          .get();
      DeliverySettings deliverySettings = DeliverySettings.fromDocument(doc);

      double value = deliverySettings.valueFixed +
          (deliverySettings.valueKm * (distance / 1000));

      return value;
    }catch(e){
      return 0.00;
    }
  }
}