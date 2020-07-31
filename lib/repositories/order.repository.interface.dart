import 'package:venda_mais_client_buy/models/entities/order.entities.dart';

abstract class IOrderRepository {

  Future<List<OrderData>> getOrdersUser(String idUser);

  Future<OrderData> getOrderId(String id);

  Future<Null> cancel(OrderData orderData);

  Future<OrderData> refreshOrder(String id);

  Future<String> create(OrderData orderData);
}