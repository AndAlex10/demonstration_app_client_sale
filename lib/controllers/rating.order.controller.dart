import 'package:venda_mais_client_buy/components/connect.component.dart';
import 'package:venda_mais_client_buy/models/entities/order.entities.dart';
import 'package:venda_mais_client_buy/models/response/validate.response.dart';
import 'package:venda_mais_client_buy/repositories/rating.order.repository.dart';
import 'package:venda_mais_client_buy/repositories/rating.order.repository.interface.dart';

class RatingOrderController {
  IRatingOrderRepository repository;
  ConnectComponent connect;

  RatingOrderController(){
    repository = new RatingOrderRepository();
    connect = new ConnectComponent();
  }

  RatingOrderController.tests(this.repository, this.connect);

  Future<ValidateResponse> save(OrderData orderData) async {
    ValidateResponse response = new ValidateResponse();
    if(await connect.checkConnect()) {
      await repository.save(orderData);
      response.success = true;
    } else {
      response.failConnect();
    }

    return response;
  }

}
