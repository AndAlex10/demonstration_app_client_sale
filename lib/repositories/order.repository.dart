
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venda_mais_client_buy/models/entities/order.entities.dart';
import 'package:venda_mais_client_buy/enums/status.order.enum.dart';
import 'package:venda_mais_client_buy/repositories/order.repository.interface.dart';

class OrderRepository implements IOrderRepository {

  @override
  Future<List<OrderData>> getOrdersUser(String idUser) async {
    List<OrderData> list = [];

    QuerySnapshot snapshot = await Firestore.instance.collection("???")
        .where("clientId", isEqualTo: idUser).getDocuments();

    for (DocumentSnapshot doc in snapshot.documents) {
      OrderData order = OrderData.fromDocument(doc);
      list.add(order);
    }

    list.sort((a, b) => b.orderCode.compareTo(a.orderCode));
    return list;
  }

  @override
  Future<OrderData> getOrderId(String id) async {
    OrderData order;

    DocumentSnapshot doc = await Firestore.instance.collection("???").document(id).get();
    if(doc != null) {
      order = OrderData.fromDocument(doc);
    }

    return order;
  }

  @override
  Future<Null> cancel(OrderData orderData) async {
    orderData.status = StatusOrder.CANCELED.index;
    orderData.rating = null;

    await Firestore.instance
        .collection("???")
        .document(orderData.id)
        .updateData({"status": StatusOrder.CANCELED.index});
  }

  @override
  Future<OrderData> refreshOrder(String id) async {
    DocumentSnapshot doc = await Firestore.instance
        .collection("???")
        .document(id)
        .get();

    OrderData orderData = OrderData.fromDocument(doc);
    return orderData;
  }

  @override
  Future<String> create(OrderData orderData) async{
    DocumentReference refOrder = await Firestore.instance.collection("orders").add(orderData.toMap());
    return refOrder.documentID;
  }
}