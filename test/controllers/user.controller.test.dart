import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:venda_mais_client_buy/components/connect.component.dart';
import 'package:venda_mais_client_buy/constants/erros.messages.dart';
import 'package:venda_mais_client_buy/controllers/user.controller.dart';
import 'package:venda_mais_client_buy/models/entities/address.entities.dart';
import 'package:venda_mais_client_buy/models/entities/payment.card.entities.dart';
import 'package:venda_mais_client_buy/models/entities/segments.entities.dart';
import 'package:venda_mais_client_buy/models/entities/user.entities.dart';
import 'package:venda_mais_client_buy/models/response/validate.response.dart';
import 'package:venda_mais_client_buy/repositories/address.repository.dart';
import 'package:venda_mais_client_buy/repositories/address.repository.interface.dart';
import 'package:venda_mais_client_buy/repositories/payment.card.repository.dart';
import 'package:venda_mais_client_buy/repositories/payment.card.repository.interface.dart';
import 'package:venda_mais_client_buy/repositories/user.repository.dart';
import 'package:venda_mais_client_buy/repositories/user.repository.interface.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';
import 'package:venda_mais_client_buy/view_model/segment.view.model.dart';

class UserRepositoryMock extends Mock implements UserRepository {}
class AddressRepositoryMock extends Mock implements AddressRepository {}
class PaymentCardRepositoryMock extends Mock implements PaymentCardRepository {}
class MockConnect extends Mock implements ConnectComponent  {}
class UserStoreMock extends Mock implements UserStore  {}

void main(){
  UserController controller;
  ConnectComponent connect;
  IUserRepository repository;
  IAddressRepository addressRepository;
  IPaymentCardRepository paymentCardRepository;
  UserStore userStore;
  setUp(() {
    userStore = UserStoreMock();
    repository = UserRepositoryMock();
    addressRepository = AddressRepositoryMock();
    paymentCardRepository = PaymentCardRepositoryMock();
    connect = MockConnect();
    controller = UserController.tests(repository, addressRepository, paymentCardRepository, connect);
  });

  group('UserController', ()
  {
    test("save", () async {
      when(userStore.user).thenAnswer((_) => new UserEntity());
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.save(any)).thenAnswer((_) async =>
          Future.value(true));
      ValidateResponse response = await controller.save(userStore);
      expect(response.success, true);
    });

    test("save - fail", () async {
      when(userStore.user).thenAnswer((_) => new UserEntity());
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.save(any)).thenAnswer((_) async =>
          Future.value(false));
      ValidateResponse response = await controller.save(userStore);
      expect(response.success, false);
      expect(response.message, ErroMessages.FAIL_UPDATE_USER);
    });

    test("save - fTeste de falha de conexão", () async {
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      ValidateResponse response = await controller.save(userStore);
      expect(response.success, false);
    });


    test("load", () async {
      UserEntity userEntity = new UserEntity();
      userEntity.id = "1l";

      List<Address> addressList = [];
      Address address = new Address();
      addressList.add(address);

      List<PaymentCard> paymentList = [];
      PaymentCard paymentCard = new PaymentCard();
      paymentList.add(paymentCard);

      when(userStore.user).thenAnswer((_) => new UserEntity());
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.load()).thenAnswer((_) async =>
          Future.value(userEntity));

      when(addressRepository.load(any)).thenAnswer((_) async =>
          Future.value(addressList));

      when(paymentCardRepository.load(any)).thenAnswer((_) async =>
          Future.value(paymentList));

      UserEntity response = await controller.load();
      expect(response != null, true);
      expect(response.addressList.length == 1, true);
      expect(response.paymentList.length == 1, true);
    });

    test("load - not found", () async {

      when(userStore.user).thenAnswer((_) => new UserEntity());
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.load()).thenAnswer((_) async =>
          Future.value(null));

      UserEntity response = await controller.load();
      expect(response == null, true);
    });

    test("load - Teste de falha de conexão", () async {
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      UserEntity response = await controller.load();
      expect(response == null, true);
    });


    test("getTitleAddressDefault", () async {
      List<Address> addressList = [];
      Address address = new Address();
      address.defaultAddress = true;
      address.address = "test";
      address.number = "test";
      address.neighborhood = "test";
      addressList.add(address);
      Address address2 = new Address();
      address2.defaultAddress = false;
      addressList.add(address2);
      String response = controller.getTitleAddressDefault(addressList);
      expect(response != "", true);
    });

    test("getTitleAddressDefault - not default", () async {
      List<Address> addressList = [];
      Address address = new Address();
      address.defaultAddress = false;
      address.address = "test";
      address.number = "test";
      address.neighborhood = "test";
      addressList.add(address);
      Address address2 = new Address();
      address2.defaultAddress = false;
      addressList.add(address2);
      String response = controller.getTitleAddressDefault(addressList);
      expect(response, 'Não tem endereço definido!');
    });
  });

}