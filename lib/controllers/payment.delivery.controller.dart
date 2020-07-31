import 'package:venda_mais_client_buy/components/connect.component.dart';
import 'package:venda_mais_client_buy/models/entities/payment.order.entities.dart';
import 'package:venda_mais_client_buy/models/entities/payments.delivery.entities.dart';
import 'package:venda_mais_client_buy/repositories/payment.repository.dart';
import 'package:venda_mais_client_buy/repositories/payment.repository.interface.dart';
import 'package:venda_mais_client_buy/view_model/payments.delivery.view.model.dart';

class PaymentDeliveryController {
  IPaymentRepository repository;
  ConnectComponent connect;

  PaymentDeliveryController(){
    repository = new PaymentRepository();
    connect = new ConnectComponent();
  }

  PaymentDeliveryController.tests(this.repository, this.connect);

  Future<PaymentsDeliveryViewModel> getAll(String id) async {
    PaymentsDeliveryViewModel viewModel = new PaymentsDeliveryViewModel();
    viewModel.checkConnect = await connect.checkConnect();
    if(viewModel.checkConnect) {
      viewModel.list = await repository.getAll(id);
    }

    return viewModel;
  }

  PaymentOrder setPaymentOrder(PaymentDelivery paymentDelivery){
    PaymentOrder paymentOrder = PaymentOrder.fromDelivery(paymentDelivery);
    return paymentOrder;
  }
}