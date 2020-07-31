
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venda_mais_client_buy/models/entities/payments.delivery.entities.dart';
import 'package:venda_mais_client_buy/repositories/payment.repository.interface.dart';

class PaymentRepository implements IPaymentRepository {

  @override
  Future<PaymentDelivery> getId(String idPayment, String idEstablishment) async{
    DocumentSnapshot doc = await Firestore.instance.collection("???").document(idEstablishment)
        .collection("???").document(idPayment).get();

    PaymentDelivery payments;
    if(doc != null) {
      payments = PaymentDelivery.fromDocument(doc);
    } else {
      payments = PaymentDelivery();
      payments.title = "Não encontrada";
    }
    return payments;
  }

  @override
  Future<List<PaymentDelivery>> getAll(String id) async {
    List<PaymentDelivery> list = [];

    QuerySnapshot snapshot;

    snapshot = await Firestore.instance
        .collection("???")
        .document(id)
        .collection("???")
        .where("active", isEqualTo: true)
        .getDocuments();

    for (DocumentSnapshot doc in snapshot.documents) {
      PaymentDelivery payments = PaymentDelivery.fromDocument(doc);
      list.add(payments);
    }

    list.sort((a, b) => a.order.compareTo(b.order));
    return list;
  }
}