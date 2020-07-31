
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:venda_mais_client_buy/models/entities/establishment.entities.dart';
import 'package:venda_mais_client_buy/models/entities/fee.delivery.entities.dart';
import 'package:venda_mais_client_buy/repositories/establishment.repository.interface.dart';
import 'package:venda_mais_client_buy/repositories/fee.delivery.repository.dart';

class EstablishmentRepository implements IEstablishmentRepository {

  DeliveryRepository feeRepository;

  EstablishmentRepository(){
    feeRepository = new DeliveryRepository();
  }

  @override
  Future<List<EstablishmentData>> getWithFilterName(String idSegment, String text, String city, String state) async {
    List<EstablishmentData> list = await getAll(idSegment, "", city, state);
    if (text != '') {
      list = list.where((i) => i.name.toLowerCase().contains(text.toLowerCase())).toList();

      list.sort((a, b) {
        var r = a.open.hashCode.compareTo(b.open.hashCode);
        if (r != 0) return r;
        return b.rating.compareTo(a.rating);
      });
    }
    return list;
  }

  @override
  Future<EstablishmentData> getId(String idEstablishment) async{
    DocumentSnapshot establishmentDoc = await Firestore.instance.collection("???").document(idEstablishment).get();
    EstablishmentData establishmentData = EstablishmentData.fromDocument(establishmentDoc);
    return establishmentData;
  }

  @override
  Future<List<EstablishmentData>> getAll(String idSegment, String idCategory, String city, String state) async {
    List<EstablishmentData> list = [];
    QuerySnapshot snapshot;

    if (idCategory == "") {
      snapshot = await Firestore.instance
          .collection("???")
          .where("idSegment", isEqualTo: idSegment)
          .where("city", isEqualTo: city)
          .where("state", isEqualTo: state)
          .getDocuments();
    } else {
      snapshot = await Firestore.instance
          .collection("???")
          .where("idSegment", isEqualTo: idSegment)
          .where("idCategory", isEqualTo: idCategory)
          .where("city", isEqualTo: city)
          .where("state", isEqualTo: state)
          .getDocuments();
    }

    for (DocumentSnapshot doc in snapshot.documents) {
      EstablishmentData establishmentData = EstablishmentData.fromDocument(doc);

      FeeDelivery data =  await feeRepository.getFirst(establishmentData.id);
      if(data != null) {
        establishmentData.setFee(data.max, data.value);
      }
      list.add(establishmentData);
    }

    list.sort((a, b) {
      var r = a.open.hashCode.compareTo(b.open.hashCode);
      if (r != 0) return r;
      return b.rating.compareTo(a.rating);
    });
    return list;
  }

  @override
  Future<Null> updateSequence(String idEstablishment, int seq) async{
    await Firestore.instance.collection("???").document(idEstablishment).updateData({"seq": seq});
  }
}