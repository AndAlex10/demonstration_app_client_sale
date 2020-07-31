
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:venda_mais_client_buy/models/entities/payment.card.entities.dart';
import 'package:venda_mais_client_buy/models/entities/user.entities.dart';
import 'package:venda_mais_client_buy/repositories/payment.card.repository.interface.dart';

class PaymentCardRepository implements IPaymentCardRepository {

  @override
  Future<List<PaymentCard>> load(String idUser) async {
    List<PaymentCard> paymentList = [];

    QuerySnapshot snapshot = await Firestore.instance
        .collection("???")
        .document(idUser)
        .collection("???")
        .orderBy("order")
        .getDocuments();

    for (DocumentSnapshot doc in snapshot.documents) {
      PaymentCard paymentCard = PaymentCard.fromDocument(doc);
      paymentList.add(paymentCard);
    }

    return paymentList;
  }

  @override
  Future<Null> alter(UserEntity userEntity, PaymentCard paymentCard) async {
    Firestore.instance
        .collection("???")
        .document(userEntity.id)
        .updateData(userEntity.toMap());

    Firestore.instance
        .collection("???")
        .document(userEntity.id)
        .collection('???')
        .document(paymentCard.id)
        .updateData(paymentCard.toMap());
  }

  @override
  Future<Null> remove(UserEntity userEntity, PaymentCard paymentCard) async {
    Firestore.instance
        .collection("???")
        .document(userEntity.id)
        .collection('???')
        .document(paymentCard.id)
        .delete();
    userEntity.paymentList.remove(paymentCard);
  }

  @override
  Future<Null> add(UserEntity userEntity, PaymentCard paymentCard) async {
    Map data = paymentCard.toMap();
    await Firestore.instance
        .collection("???")
        .document(userEntity.id)
        .collection('???')
        .add(data);
  }

}