import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:venda_mais_client_buy/components/connect.component.dart';
import 'package:venda_mais_client_buy/controllers/address.controller.dart';
import 'package:venda_mais_client_buy/models/entities/address.entities.dart';
import 'package:venda_mais_client_buy/models/entities/establishment.entities.dart';
import 'package:venda_mais_client_buy/models/entities/user.entities.dart';
import 'package:venda_mais_client_buy/models/response/validate.response.dart';
import 'package:venda_mais_client_buy/repositories/address.repository.dart';
import 'package:venda_mais_client_buy/repositories/address.repository.interface.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';
import 'package:google_maps_webservice/places.dart';

class AddressRepositoryMock extends Mock implements AddressRepository  {}
class MockConnect extends Mock implements ConnectComponent  {}
class UserStoreMock extends Mock implements UserStore  {}

void main(){
  AddressController controller;
  ConnectComponent connect;
  IAddressRepository repository;
  UserStore userStore;
  setUp(() {
    repository = AddressRepositoryMock();
    connect = MockConnect();
    userStore = UserStoreMock();
    controller = AddressController.tests(repository, connect);
  });

  group('AddressController - alter', ()
  {
    test("alter", () async {
      Address data = new Address();

      UserEntity userEntity = new UserEntity();
      when(userStore.user).thenAnswer((_) =>userEntity);
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.alter(any, any)).thenAnswer((_) async =>
          Future.value(null));
      ValidateResponse response = await controller.alter(userStore, data);
      expect(response.success, true);
    });


    test("Teste de falha de conexão", () async {
      Address data = new Address();
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      ValidateResponse response = await controller.alter(userStore, data);
      expect(response.success, false);
    });
  });

  group('AddressController - remove', ()
  {
    test("remove", () async {
      Address data = new Address();
      List<Address> addressList = [];
      addressList.add(data);

      UserEntity userEntity = new UserEntity();
      userEntity.id = "1l";
      when(userStore.user).thenAnswer((_) =>userEntity);
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.remove(any, any)).thenAnswer((_) async =>
          Future.value(null));

      when(repository.load(any)).thenAnswer((_) async =>
          Future.value(addressList));

      ValidateResponse response = await controller.remove(userStore, data);
      expect(response.success, true);
    });


    test("Teste de falha de conexão", () async {
      Address data = new Address();
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      ValidateResponse response = await controller.remove(userStore, data);
      expect(response.success, false);
    });
  });


  group('AddressController - add', ()
  {
    test("Teste de falha de conexão", () async {
      Map<String, dynamic> map = {"status": "1", "error_message": ""};
      PlacesDetailsResponse detail = new PlacesDetailsResponse.fromJson(map);
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      ValidateResponse response = await controller.add(userStore, detail, 10, 10, 15);
      expect(response.success, false);
    });
  });

  group('AddressController - setDefault', ()
  {
    test("setDefault", () async {
      Address data = new Address();
      data.id = "1l";
      data.address = "test";
      data.number = '10';
      data.neighborhood = "neighborhood";
      data.defaultAddress = true;

      Address data2 = new Address();
      data.id = "2l";
      data.defaultAddress = false;
      List<Address> addressList = [];
      addressList.add(data);
      addressList.add(data2);

      UserEntity userEntity = new UserEntity();
      userEntity.id = "1l";
      when(userStore.user).thenAnswer((_) =>userEntity);
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.setDefault(any, any)).thenAnswer((_) async =>
          Future.value(null));

      when(repository.setUnDefault(any, any)).thenAnswer((_) async =>
          Future.value(null));

      when(repository.load(any)).thenAnswer((_) async =>
          Future.value(addressList));

      ValidateResponse response = await controller.setDefault(userStore, data);
      expect(response.success, true);
    });


    test("Teste de falha de conexão", () async {
      Address data = new Address();
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      ValidateResponse response = await controller.setDefault(userStore, data);
      expect(response.success, false);
    });
  });


  group('AddressController - validateAddress', ()
  {
    test("validateAddress", () {
      EstablishmentData establishmentData = new EstablishmentData();
      establishmentData.city = "city";
      establishmentData.state = 'state';
      Address data = new Address();
      data.id = "1l";
      data.city = "city";
      data.state = 'state';
      bool response = controller.validateAddress(establishmentData, data);
      expect(response, true);
    });

    test("validateAddress", () {
      EstablishmentData establishmentData = new EstablishmentData();
      establishmentData.city = "city2";
      establishmentData.state = 'state2';
      Address data = new Address();
      data.id = "1l";
      data.city = "city";
      data.state = 'state';
      bool response = controller.validateAddress(establishmentData, data);
      expect(response, false);
    });
  });

}