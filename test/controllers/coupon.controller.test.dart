import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:venda_mais_client_buy/components/connect.component.dart';
import 'package:venda_mais_client_buy/constants/erros.messages.dart';
import 'package:venda_mais_client_buy/controllers/coupon.controller.dart';
import 'package:venda_mais_client_buy/models/entities/coupon.entities.dart';
import 'package:venda_mais_client_buy/models/entities/establishment.entities.dart';
import 'package:venda_mais_client_buy/models/response/validate.response.dart';
import 'package:venda_mais_client_buy/repositories/coupon.repository.dart';
import 'package:venda_mais_client_buy/repositories/coupon.repository.interface.dart';
import 'package:venda_mais_client_buy/stores/cart.store.dart';

class CouponRepositoryMock extends Mock implements CouponRepository  {}
class MockConnect extends Mock implements ConnectComponent  {}
class MockCartStore extends Mock implements CartStore  {}

void main(){
  CouponController controller;
  ConnectComponent connect;
  CartStore cartStore;
  ICouponRepository repository;
  setUp(() {
    repository = CouponRepositoryMock();
    connect = MockConnect();
    cartStore = MockCartStore();
    controller = CouponController.tests(repository, connect);
  });

  group('CouponController', ()
  {
    test("get", () async {
      Coupon data = new Coupon();

      EstablishmentData establishmentData = new EstablishmentData();
      establishmentData.id = "10l";
      when(cartStore.establishment).thenAnswer((_)  => establishmentData);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.get(any, any)).thenAnswer((_) async =>
          Future.value(data));
      ValidateResponse response = await controller.get("15151", cartStore);
      expect(response.success, true);
    });

    test("get - not found", () async {

      EstablishmentData establishmentData = new EstablishmentData();
      establishmentData.id = "10l";
      when(cartStore.establishment).thenAnswer((_)  => establishmentData);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.get(any, any)).thenAnswer((_) async =>
          Future.value(null));
      ValidateResponse response = await controller.get("15151", cartStore);
      expect(response.success, false);
      expect(response.message, ErroMessages.NOT_FOUND_COUPON);
    });

    test("Teste de falha de conexão", () async {
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      ValidateResponse response = await controller.get("15151", cartStore);
      expect(response.success, false);
    });
  });

}