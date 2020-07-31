import 'package:venda_mais_client_buy/constants/erros.messages.dart';
import 'package:venda_mais_client_buy/models/entities/address.entities.dart';
import 'package:venda_mais_client_buy/models/entities/user.entities.dart';
import 'package:venda_mais_client_buy/repositories/address.repository.dart';
import 'package:venda_mais_client_buy/repositories/address.repository.interface.dart';
import 'package:venda_mais_client_buy/repositories/user.repository.dart';
import 'package:venda_mais_client_buy/repositories/user.repository.interface.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:venda_mais_client_buy/components/connect.component.dart';
import 'package:venda_mais_client_buy/controllers/signInEmailAccount.controller.dart';
import 'package:venda_mais_client_buy/models/response/validate.response.dart';
import 'package:venda_mais_client_buy/repositories/signInEmailAccount.repository.dart';
import 'package:venda_mais_client_buy/repositories/signInEmailAccount.repository.interface.dart';


class SignInEmailAccountRepositoryMock extends Mock implements SignInEmailAccountRepository  {}
class AddressRepositoryMock extends Mock implements AddressRepository  {}
class UserRepositoryMock extends Mock implements UserRepository  {}
class MockConnect extends Mock implements ConnectComponent  {}
class MockAppStore extends Mock implements UserStore  {}

void main(){
  SignInEmailAccountController controller;
  ConnectComponent connect;
  ISignInEmailAccountRepository repository;
  IUserRepository userRepository;
  IAddressRepository addressRepository;
  MockAppStore appStore;

  setUp(() {
    repository = SignInEmailAccountRepositoryMock();
    addressRepository = AddressRepositoryMock();
    userRepository = UserRepositoryMock();
    connect = MockConnect();
    controller = SignInEmailAccountController.tests(repository, userRepository, addressRepository, connect);
    appStore = MockAppStore();
  });

  group('Sign In tests', ()
  {
    test("Test Sign In", () async {
      String email = "test@gmail.com";
      String pass = "123456";
      UserEntity userEntity = new UserEntity();
      userEntity.id = "1L";
      List<Address> addressList = [];

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.signIn(email: email, pass: pass)).thenAnswer((_) async =>
          Future.value(userEntity));

      when(addressRepository.load(any)).thenAnswer((_) async =>
          Future.value(addressList));


      when(appStore.user).thenAnswer((_) =>userEntity);

      ValidateResponse response = await controller.signIn(appStore, email, pass);
      expect(response != null, true);
      expect(response.success, true);
    });

    test("Test Sign In - Fail", () async {
      String email = "test@gmail.com";
      String pass = "123456";
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.signIn(email:email, pass:pass)).thenAnswer((_) async =>
          Future.value(null));
      ValidateResponse response = await controller.signIn(appStore, email, pass);
      expect(response != null, true);
      expect(response.success, false);
      expect(response.message, ErroMessages.FAIL_LOGIN);
    });

    test("Teste de falha de conexão", () async {
      String email = "test@gmail.com";
      String pass = "123456";
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      ValidateResponse response = await controller.signIn(appStore, email, pass);
      expect(false, response.success);
    });
  });

  group('Sign Out tests', ()
  {
    test("sign out", () async {
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.signOut()).thenAnswer((_) async =>
          Future.value(null));

      ValidateResponse response = await controller.signOut(appStore);
      expect(response != null, true);
      expect(response.success, true);
    });

    test("Teste de falha de conexão", () async {
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));
      ValidateResponse response = await controller.signOut(appStore);
      expect(false, response.success);
    });
  });
}