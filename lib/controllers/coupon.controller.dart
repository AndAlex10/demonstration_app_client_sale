import 'package:venda_mais_client_buy/components/connect.component.dart';
import 'package:venda_mais_client_buy/constants/erros.messages.dart';
import 'package:venda_mais_client_buy/models/entities/coupon.entities.dart';
import 'package:venda_mais_client_buy/repositories/coupon.repository.dart';
import 'package:venda_mais_client_buy/repositories/coupon.repository.interface.dart';
import 'package:venda_mais_client_buy/models/response/validate.response.dart';
import 'package:venda_mais_client_buy/stores/cart.store.dart';

class CouponController {
  ICouponRepository repository;
  ConnectComponent connect;
  CouponController(){
    repository = new CouponRepository();
    connect = new ConnectComponent();
  }

  CouponController.tests(this.repository, this.connect);

  Future<ValidateResponse> get(String code, CartStore cartStore) async{
    ValidateResponse response = new ValidateResponse();
    if(await connect.checkConnect()) {
      Coupon coupon = await repository.get(
          code, cartStore.establishment.id);
      if (coupon != null) {
        response.success = true;
        cartStore.setCoupon(coupon);
      } else {
        response.message = ErroMessages.NOT_FOUND_COUPON;
      }
    } else {
      response.failConnect();
    }
    return response;
  }
}