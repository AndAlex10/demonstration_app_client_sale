import 'package:flutter_cielo/flutter_cielo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:venda_mais_client_buy/components/cielo.component.dart';
import 'package:venda_mais_client_buy/components/connect.component.dart';
import 'package:venda_mais_client_buy/controllers/order.controller.dart';
import 'package:venda_mais_client_buy/enums/status.order.enum.dart';
import 'package:venda_mais_client_buy/models/entities/order.entities.dart';
import 'package:venda_mais_client_buy/models/entities/payment.order.entities.dart';
import 'package:venda_mais_client_buy/models/entities/segments.entities.dart';
import 'package:venda_mais_client_buy/repositories/order.repository.interface.dart';
import 'package:venda_mais_client_buy/repositories/establishment.repository.dart';
import 'package:venda_mais_client_buy/repositories/establishment.repository.interface.dart';
import 'package:venda_mais_client_buy/repositories/order.repository.dart';
import 'package:venda_mais_client_buy/repositories/payment.repository.dart';
import 'package:venda_mais_client_buy/repositories/payment.repository.interface.dart';
import 'package:venda_mais_client_buy/models/response/validate.response.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';
import 'package:venda_mais_client_buy/view_model/order.view.model.dart';

class OrderRepositoryMock extends Mock implements OrderRepository {}
class EstablishmentRepositoryMock extends Mock implements EstablishmentRepository {}
class PaymentRepositoryMock extends Mock implements PaymentRepository {}
class CieloComponentMock extends Mock implements CieloComponent {}
class MockConnect extends Mock implements ConnectComponent  {}
class UserStoreMock extends Mock implements UserStore  {}

void main(){
  OrderController controller;
  ConnectComponent connect;
  IOrderRepository repository;
  IEstablishmentRepository establishmentRepository;
  IPaymentRepository paymentRepository;
  CieloComponent cieloComponent;
  UserStore userStore;
  setUp(() {
    repository = OrderRepositoryMock();
    establishmentRepository = EstablishmentRepositoryMock();
    paymentRepository = PaymentRepositoryMock();
    cieloComponent = CieloComponentMock();
    connect = MockConnect();
    userStore = UserStoreMock();
    controller = OrderController.tests(repository, establishmentRepository, paymentRepository, cieloComponent, connect);
  });

  group('OrderController', ()
  {
    test("getAllUser - tab 0", () async {
      List<OrderData> list = [];
      OrderData data = new OrderData();
      data.status = StatusOrder.IN_PRODUCTION.index;
      list.add(data);

      OrderData data2 = new OrderData();
      data2.status = StatusOrder.CONCLUDED.index;
      list.add(data2);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.getOrdersUser(any)).thenAnswer((_) async =>
          Future.value(list));
      OrderViewModel response = await controller.getAllUser("1l", 0);
      expect(response.list.length == 1, true);
    });

    test("getAllUser - tab 1", () async {
      List<OrderData> list = [];
      OrderData data = new OrderData();
      data.status = StatusOrder.IN_PRODUCTION.index;
      list.add(data);

      OrderData data2 = new OrderData();
      data2.status = StatusOrder.CONCLUDED.index;
      list.add(data2);

      OrderData data3 = new OrderData();
      data3.status = StatusOrder.CANCELED.index;
      list.add(data3);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.getOrdersUser(any)).thenAnswer((_) async =>
          Future.value(list));
      OrderViewModel response = await controller.getAllUser("1l", 1);
      expect(response.list.length == 2, true);
    });


    test("getAllUser - Teste de falha de conexão", () async {
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      OrderViewModel response = await controller.getAllUser("1l", 0);
      expect(response.list.length == 0, true);
    });

    test("cancel - in delivery", () async {
      List<OrderData> list = [];
      OrderData data = new OrderData();
      data.id = "2l";
      data.status = StatusOrder.PENDING.index;
      data.payment = new PaymentOrder();
      data.payment.inDelivery = true;
      list.add(data);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.refreshOrder(any)).thenAnswer((_) async =>
          Future.value(data));

      when(repository.cancel(any)).thenAnswer((_) async =>
          Future.value(null));
      ValidateResponse response = await controller.cancel(userStore, data);
      expect(response.success, true);
    });

    test("cancel - status approved", () async {
      List<OrderData> list = [];
      OrderData data = new OrderData();
      data.id = "2l";
      data.status = StatusOrder.IN_PRODUCTION.index;
      data.payment = new PaymentOrder();
      data.payment.inDelivery = true;
      list.add(data);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.refreshOrder(any)).thenAnswer((_) async =>
          Future.value(data));

      when(repository.cancel(any)).thenAnswer((_) async =>
          Future.value(null));
      ValidateResponse response = await controller.cancel(userStore, data);
      expect(response.success, false);
    });

    test("cancel - status canceled", () async {
      List<OrderData> list = [];
      OrderData data = new OrderData();
      data.id = "2l";
      data.status = StatusOrder.CANCELED.index;
      data.payment = new PaymentOrder();
      data.payment.inDelivery = true;
      list.add(data);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.refreshOrder(any)).thenAnswer((_) async =>
          Future.value(data));

      when(repository.cancel(any)).thenAnswer((_) async =>
          Future.value(null));
      ValidateResponse response = await controller.cancel(userStore, data);
      expect(response.success, false);
    });

    test("cancel - payment auto", () async {
      List<OrderData> list = [];
      OrderData data = new OrderData();
      data.id = "2l";
      data.amount = 100;
      data.status = StatusOrder.PENDING.index;
      data.payment = new PaymentOrder();
      data.payment.paymentId = "1l";
      data.payment.inDelivery = false;
      list.add(data);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.refreshOrder(any)).thenAnswer((_) async =>
          Future.value(data));

      ValidateResponse validateResponse = new ValidateResponse();
      validateResponse.success = true;
      when(cieloComponent.cancelSale(any, any, any)).thenAnswer((_) async =>
          Future.value(validateResponse));

      when(repository.cancel(any)).thenAnswer((_) async =>
          Future.value(null));
      ValidateResponse response = await controller.cancel(userStore, data);
      expect(response.success, true);
    });

    test("cancel - payment auto fail", () async {
      List<OrderData> list = [];
      OrderData data = new OrderData();
      data.id = "2l";
      data.amount = 100;
      data.status = StatusOrder.PENDING.index;
      data.payment = new PaymentOrder();
      data.payment.paymentId = "1l";
      data.payment.inDelivery = false;
      list.add(data);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.refreshOrder(any)).thenAnswer((_) async =>
          Future.value(data));

      ValidateResponse validateResponse = new ValidateResponse();
      validateResponse.success = false;
      when(cieloComponent.cancelSale(any, any, any)).thenAnswer((_) async =>
          Future.value(validateResponse));

      when(repository.cancel(any)).thenAnswer((_) async =>
          Future.value(null));
      ValidateResponse response = await controller.cancel(userStore, data);
      expect(response.success, false);
    });
  });

}