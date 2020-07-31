import 'package:venda_mais_client_buy/models/entities/coupon.entities.dart';

abstract class ICouponRepository {

  Future<Coupon> get(String code, String idEstablishment);
}