
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venda_mais_client_buy/repositories/notification.repository.interface.dart';

class NotificationRepository implements INotificationRepository {

  @override
  Future<Null> create(int orderCode, String idEstablishment)async{
    await Firestore.instance.collection("???").add(
        {
          "name": "Aqui Tem Delivery Manager",
          "subject": "Pedido Novo na área! Número: $orderCode",
          "topic": idEstablishment,
        }
    );
  }
}