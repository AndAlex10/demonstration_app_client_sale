import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:venda_mais_client_buy/components/cielo.component.dart';
import 'package:venda_mais_client_buy/components/connect.component.dart';
import 'package:venda_mais_client_buy/constants/erros.messages.dart';
import 'package:venda_mais_client_buy/controllers/payment.card.controller.dart';
import 'package:venda_mais_client_buy/models/entities/payment.card.entities.dart';
import 'package:venda_mais_client_buy/models/entities/payment.order.entities.dart';
import 'package:venda_mais_client_buy/models/entities/user.entities.dart';
import 'package:venda_mais_client_buy/models/response/validate.response.dart';
import 'package:venda_mais_client_buy/repositories/payment.card.repository.dart';
import 'package:venda_mais_client_buy/repositories/payment.card.repository.interface.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';

class PaymentCardRepositoryMock extends Mock implements PaymentCardRepository  {}
class MockConnect extends Mock implements ConnectComponent  {}
class UserStoreMock extends Mock implements UserStore  {}
class CieloComponentMock extends Mock implements CieloComponent  {}

void main(){
  PaymentCardController controller;
  ConnectComponent connect;
  IPaymentCardRepository repository;
  UserStore userStore;
  CieloComponent cieloComponent;
  setUp(() {
    repository = PaymentCardRepositoryMock();
    connect = MockConnect();
    userStore = UserStoreMock();
    cieloComponent = CieloComponentMock();
    controller = PaymentCardController.tests(repository, cieloComponent, connect);
  });

  group('PaymentCardController - alter', ()
  {
    test("alter", () async {
      PaymentCard paymentCard = new PaymentCard();
      UserEntity userEntity = new UserEntity();
      when(userStore.user).thenAnswer((_) =>userEntity);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.alter(any, any)).thenAnswer((_) async =>
          Future.value(null));
      ValidateResponse response = await controller.alter(userStore, paymentCard);
      expect(response.success, true);
    });


    test("Teste de falha de conexão", () async {
      PaymentCard paymentCard = new PaymentCard();
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      ValidateResponse response = await controller.alter(userStore, paymentCard);
      expect(response.success, false);
    });
  });

  group('PaymentCardController - remove', ()
  {
    test("remove", () async {
      PaymentCard paymentCard = new PaymentCard();
      UserEntity userEntity = new UserEntity();
      userEntity.id = "1l";
      when(userStore.user).thenAnswer((_) =>userEntity);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.remove(any, any)).thenAnswer((_) async =>
          Future.value(null));

      when(repository.load(any)).thenAnswer((_) async =>
          Future.value([]));
      ValidateResponse response = await controller.remove(userStore, paymentCard);
      expect(response.success, true);
    });


    test("Teste de falha de conexão", () async {
      PaymentCard paymentCard = new PaymentCard();
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      ValidateResponse response = await controller.remove(userStore, paymentCard);
      expect(response.success, false);
    });
  });


  group('PaymentCardController - addCard', ()
  {
    test("addCard", () async {
      PaymentCard paymentCard = new PaymentCard();
      paymentCard.cardNumber = "4929145634524261";
      paymentCard.order = 1;
      paymentCard.securityCode = "123";
      paymentCard.expirationDate = "20/2020";
      UserEntity userEntity = new UserEntity();
      userEntity.id = "1l";
      when(userStore.user).thenAnswer((_) =>userEntity);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(cieloComponent.createToken(any, any)).thenAnswer((_) async =>
          Future.value("123"));

      when(repository.add(any, any)).thenAnswer((_) async =>
          Future.value(null));

      when(repository.load(any)).thenAnswer((_) async =>
          Future.value([]));
      ValidateResponse response = await controller.addCard(userStore, paymentCard);
      expect(response.success, true);
    });

    test("addCard - error token", () async {
      PaymentCard paymentCard = new PaymentCard();
      paymentCard.cardNumber = "4929145634524261";
      paymentCard.order = 1;
      paymentCard.securityCode = "123";
      paymentCard.expirationDate = "20/2020";
      UserEntity userEntity = new UserEntity();
      userEntity.id = "1l";
      when(userStore.user).thenAnswer((_) =>userEntity);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(cieloComponent.createToken(any, any)).thenAnswer((_) async =>
          Future.value(null));

      ValidateResponse response = await controller.addCard(userStore, paymentCard);
      expect(response.success, false);
      expect(response.message, ErroMessages.NOT_FOUND_COUPON);
    });

    test("addCard - not found brand", () async {
      PaymentCard paymentCard = new PaymentCard();
      paymentCard.cardNumber = "5151545454545";
      paymentCard.order = 1;
      paymentCard.securityCode = "123";
      paymentCard.expirationDate = "20/2020";
      UserEntity userEntity = new UserEntity();
      userEntity.id = "1l";
      when(userStore.user).thenAnswer((_) =>userEntity);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(cieloComponent.createToken(any, any)).thenAnswer((_) async =>
          Future.value(null));

      ValidateResponse response = await controller.addCard(userStore, paymentCard);
      expect(response.success, false);
    });

    test("addCard - error securityCode", () async {
      PaymentCard paymentCard = new PaymentCard();
      paymentCard.cardNumber = "4929145634524261";
      paymentCard.order = 1;
      paymentCard.securityCode = "12355";
      paymentCard.expirationDate = "20/2020";
      UserEntity userEntity = new UserEntity();
      userEntity.id = "1l";
      when(userStore.user).thenAnswer((_) =>userEntity);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(cieloComponent.createToken(any, any)).thenAnswer((_) async =>
          Future.value(null));

      ValidateResponse response = await controller.addCard(userStore, paymentCard);
      expect(response.success, false);
    });

    test("addCard - error expirationDate", () async {
      PaymentCard paymentCard = new PaymentCard();
      paymentCard.cardNumber = "4929145634524261";
      paymentCard.order = 1;
      paymentCard.securityCode = "12355";
      paymentCard.expirationDate = "20/202";
      UserEntity userEntity = new UserEntity();
      userEntity.id = "1l";
      when(userStore.user).thenAnswer((_) =>userEntity);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(cieloComponent.createToken(any, any)).thenAnswer((_) async =>
          Future.value(null));

      ValidateResponse response = await controller.addCard(userStore, paymentCard);
      expect(response.success, false);
    });

    test("Teste de falha de conexão", () async {
      PaymentCard paymentCard = new PaymentCard();
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      ValidateResponse response = await controller.addCard(userStore, paymentCard);
      expect(response.success, false);
    });
  });


  group('PaymentCardController - setPaymentOrder', ()
  {
    test("setPaymentOrder", () {
      PaymentCard paymentCard = new PaymentCard();
      paymentCard.cardNumber = "5151545454545";
      paymentCard.order = 1;
      paymentCard.securityCode = "123";
      paymentCard.expirationDate = "20/2020";
      paymentCard.token = "123";
      paymentCard.brand = "Visa";
      paymentCard.customerName = "Name test";
      PaymentOrder response = controller.setPaymentOrder(paymentCard);
      expect(response != null, true);
      expect(response.cardNumber, paymentCard.cardNumber);
      expect(response.cardNumber, paymentCard.cardNumber);
      expect(response.cardNumber, paymentCard.cardNumber);
      expect(response.customerName, paymentCard.customerName);
      expect(response.brand, paymentCard.brand);
      expect(response.securityCode, paymentCard.securityCode);
      expect(response.token, paymentCard.token);
      expect(response.inDelivery, false);
    });
  });
}