import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venda_mais_client_buy/models/entities/menu.entities.dart';
import 'package:venda_mais_client_buy/repositories/menu.repository.interface.dart';

class MenuRepository implements IMenuRepository{

  @override
  Future<List<MenuData>> getAll(String idEstablishment) async {
    List<MenuData> list = [];
    QuerySnapshot snapshot = await Firestore.instance
        .collection("???")
        .document(idEstablishment)
        .collection("???")
        .where("additional", isEqualTo: false)
        .where("active", isEqualTo: true)
        .getDocuments();

    MenuData data;
    for (DocumentSnapshot doc in snapshot.documents) {
      data = MenuData.fromDocument(doc);

      list.add(data);
    }

    list.sort((a, b) => a.order.compareTo(b.order));
    return list;
  }


}