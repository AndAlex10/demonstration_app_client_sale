import 'package:venda_mais_client_buy/models/entities/order.entities.dart';

abstract class IRatingOrderRepository {

  Future<Null> save(OrderData orderData);
}