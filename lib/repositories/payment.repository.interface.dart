import 'package:venda_mais_client_buy/models/entities/payments.delivery.entities.dart';

abstract class IPaymentRepository {

  Future<PaymentDelivery> getId(String idPayment, String idEstablishment);

  Future<List<PaymentDelivery>> getAll(String id);
}