import 'package:venda_mais_client_buy/models/entities/payment.card.entities.dart';
import 'package:venda_mais_client_buy/models/entities/user.entities.dart';

abstract class IPaymentCardRepository {

  Future<List<PaymentCard>> load(String idUser);

  Future<Null> alter(UserEntity userEntity, PaymentCard paymentCard);

  Future<Null> remove(UserEntity userEntity, PaymentCard paymentCard);

  Future<Null> add(UserEntity userEntity, PaymentCard paymentCard);

}