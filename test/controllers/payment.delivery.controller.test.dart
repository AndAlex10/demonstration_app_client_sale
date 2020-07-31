import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:venda_mais_client_buy/components/connect.component.dart';
import 'package:venda_mais_client_buy/controllers/payment.delivery.controller.dart';
import 'package:venda_mais_client_buy/models/entities/payment.order.entities.dart';
import 'package:venda_mais_client_buy/models/entities/payments.delivery.entities.dart';
import 'package:venda_mais_client_buy/repositories/payment.repository.dart';
import 'package:venda_mais_client_buy/repositories/payment.repository.interface.dart';
import 'package:venda_mais_client_buy/view_model/payments.delivery.view.model.dart';

class PaymentRepositoryMock extends Mock implements PaymentRepository  {}
class MockConnect extends Mock implements ConnectComponent  {}

void main(){
  PaymentDeliveryController controller;
  ConnectComponent connect;
  IPaymentRepository repository;
  setUp(() {
    repository = PaymentRepositoryMock();
    connect = MockConnect();
    controller = PaymentDeliveryController.tests(repository, connect);
  });

  group('PaymentDeliveryController', ()
  {
    test("getAll", () async {
      List<PaymentDelivery> list = [];
      PaymentDelivery data = new PaymentDelivery();
      list.add(data);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.getAll(any)).thenAnswer((_) async =>
          Future.value(list));
      PaymentsDeliveryViewModel response = await controller.getAll("1l");
      expect(response.list.length == 1, true);
    });

    test("getAll -Teste de falha de conexão", () async {
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      PaymentsDeliveryViewModel response = await controller.getAll("1l");
      expect(response.list.length == 0, true);
    });

    test("setPaymentOrder", () async {
      PaymentDelivery paymentDelivery = new PaymentDelivery();
      paymentDelivery.title = "title";
      paymentDelivery.method = "method";
      paymentDelivery.image = "image";

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));
      PaymentOrder response = controller.setPaymentOrder(paymentDelivery);
      expect(response.title, paymentDelivery.title);
      expect(response.method, paymentDelivery.method);
      expect(response.image, paymentDelivery.image);
    });
  });

}