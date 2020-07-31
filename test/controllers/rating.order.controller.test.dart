import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:venda_mais_client_buy/components/connect.component.dart';
import 'package:venda_mais_client_buy/controllers/rating.order.controller.dart';
import 'package:venda_mais_client_buy/models/entities/order.entities.dart';
import 'package:venda_mais_client_buy/models/response/validate.response.dart';
import 'package:venda_mais_client_buy/repositories/rating.order.repository.dart';
import 'package:venda_mais_client_buy/repositories/rating.order.repository.interface.dart';

class RatingOrderRepositoryMock extends Mock implements RatingOrderRepository  {}
class MockConnect extends Mock implements ConnectComponent  {}

void main(){
  RatingOrderController controller;
  ConnectComponent connect;
  IRatingOrderRepository repository;

  setUp(() {
    repository = RatingOrderRepositoryMock();
    connect = MockConnect();
    controller = RatingOrderController.tests(repository, connect);
  });

  group('RatingOrderController', ()
  {
    test("save", () async {
      OrderData data = new OrderData();
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.save(any)).thenAnswer((_) async =>
          Future.value(null));
      ValidateResponse response = await controller.save(data);
      expect(response.success, true);
    });

    test("Teste de falha de conexão", () async {
      OrderData data = new OrderData();
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      ValidateResponse response = await controller.save(data);
      expect(response.success, false);
    });
  });

}