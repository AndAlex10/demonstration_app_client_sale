import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venda_mais_client_buy/models/entities/order.entities.dart';
import 'package:venda_mais_client_buy/repositories/rating.order.repository.interface.dart';

class RatingOrderRepository implements IRatingOrderRepository {

  @override
  Future<Null> save(OrderData orderData) async {
    await Firestore.instance
        .collection("???")
        .document(orderData.id)
        .updateData(orderData.toMap());
  }
}