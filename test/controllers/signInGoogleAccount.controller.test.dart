import 'package:venda_mais_client_buy/controllers/signInGoogleAccount.controller.dart';
import 'package:venda_mais_client_buy/models/entities/address.entities.dart';
import 'package:venda_mais_client_buy/models/entities/user.entities.dart';
import 'package:venda_mais_client_buy/repositories/address.repository.dart';
import 'package:venda_mais_client_buy/repositories/address.repository.interface.dart';
import 'package:venda_mais_client_buy/repositories/signInGoogleAccount.repository.dart';
import 'package:venda_mais_client_buy/repositories/signInGoogleAccount.repository.interface.dart';
import 'package:venda_mais_client_buy/repositories/user.repository.dart';
import 'package:venda_mais_client_buy/repositories/user.repository.interface.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:venda_mais_client_buy/components/connect.component.dart';
import 'package:venda_mais_client_buy/models/response/validate.response.dart';


class SignInGoogleAccountRepositoryMock extends Mock implements SignInGoogleAccountRepository  {}
class AddressRepositoryMock extends Mock implements AddressRepository  {}
class UserRepositoryMock extends Mock implements UserRepository  {}
class MockConnect extends Mock implements ConnectComponent  {}
class MockAppStore extends Mock implements UserStore  {}

void main(){
  SignInGoogleAccountController controller;
  ConnectComponent connect;
  ISignInGoogleAccountRepository repository;
  IUserRepository userRepository;
  IAddressRepository addressRepository;
  MockAppStore userStore;

  setUp(() {
    repository = SignInGoogleAccountRepositoryMock();
    addressRepository = AddressRepositoryMock();
    userRepository = UserRepositoryMock();
    connect = MockConnect();
    controller = SignInGoogleAccountController.tests(repository, userRepository, addressRepository, connect);
    userStore = MockAppStore();
  });

  group('Sign In Goolge tests', ()
  {
    test("Test Sign In Goolge", () async {
      ValidateResponse validateResponse = new ValidateResponse();
      validateResponse.success = true;

      UserEntity userEntity = new UserEntity();
      userEntity.id = "1L";
      List<Address> addressList = [];
      userEntity.addressList = addressList;
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(userStore.configRabbitMQ()).thenAnswer((_) async => null);
      when(userStore.user).thenAnswer((_)  => userEntity);


      when(repository.signIn()).thenAnswer((_) async =>
          Future.value(userEntity));

      ValidateResponse response = await controller.signIn(userStore);
      expect(response != null, true);
      expect(response.success, true);
    });

    test("Test Sign In Goolge - Fail", () async {

      when(userStore.configRabbitMQ()).thenAnswer((_) async => null);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.signIn()).thenAnswer((_) async =>
          Future.value(null));
      ValidateResponse response = await controller.signIn(userStore);
      expect(response != null, true);
      expect(response.success, false);
    });

    test("Teste de falha de conexão", () async {

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      ValidateResponse response = await controller.signIn(userStore);
      expect(false, response.success);
    });
  });

  group('Sign Out Goolge tests', ()
  {
    test("sign out Goolge", () async {
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.signOutGoogle()).thenAnswer((_) async =>
          Future.value(null));

      ValidateResponse response = await controller.signOutGoogle(userStore);
      expect(response != null, true);
      expect(response.success, true);
    });

    test("Teste de falha de conexão", () async {
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));
      ValidateResponse response = await controller.signOutGoogle(userStore);
      expect(false, response.success);
    });
  });

}