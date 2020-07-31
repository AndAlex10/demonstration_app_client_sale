import 'package:venda_mais_client_buy/models/entities/fee.delivery.entities.dart';

abstract class IDeliveryRepository {

  Future<List<FeeDelivery>> getAll(String id);

  Future<FeeDelivery> getFirst(String id);

  Future<double> getCommissionDelivery(int distance);
}