import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:venda_mais_client_buy/components/connect.component.dart';
import 'package:venda_mais_client_buy/controllers/establishment.controller.dart';
import 'package:venda_mais_client_buy/models/entities/address.entities.dart';
import 'package:venda_mais_client_buy/models/entities/establishment.entities.dart';
import 'package:venda_mais_client_buy/models/entities/user.entities.dart';
import 'package:venda_mais_client_buy/repositories/establishment.repository.dart';
import 'package:venda_mais_client_buy/repositories/establishment.repository.interface.dart';
import 'package:venda_mais_client_buy/view_model/establishments.view.model.dart';

class EstablishmentRepositoryMock extends Mock implements EstablishmentRepository  {}
class MockConnect extends Mock implements ConnectComponent  {}

void main(){
  EstablishmentController controller;
  ConnectComponent connect;
  IEstablishmentRepository repository;
  setUp(() {
    repository = EstablishmentRepositoryMock();
    connect = MockConnect();
    controller = EstablishmentController.tests(repository, connect);
  });

  group('MenuController', ()
  {
    test("getWithFilterName", () async {
      UserEntity userEntity = new UserEntity();
      Address address = new Address();
      address.city = "Test";
      address.defaultAddress = true;
      address.state = "SP";
      userEntity.addressList.add(address);

      List<EstablishmentData> list = [];
      EstablishmentData data = new EstablishmentData();
      list.add(data);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.getWithFilterName(any, any, any, any)).thenAnswer((_) async =>
          Future.value(list));
      EstablishmentsViewModel response = await controller.getWithFilterName("1l", "test", userEntity);
      expect(response.list.length == 1, true);
    });

    test("getWithFilterName - Teste de falha de conexão", () async {
      UserEntity userEntity = new UserEntity();
      Address address = new Address();
      address.city = "Test";
      address.state = "SP";
      userEntity.addressList.add(address);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      EstablishmentsViewModel response = await controller.getWithFilterName("1l", "test", userEntity);
      expect(response.list.length == 0, true);
    });

    test("getAll", () async {
      UserEntity userEntity = new UserEntity();
      Address address = new Address();
      address.city = "Test";
      address.defaultAddress = true;
      address.state = "SP";
      userEntity.addressList.add(address);

      List<EstablishmentData> list = [];
      EstablishmentData data = new EstablishmentData();
      list.add(data);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.getAll(any, any, any, any)).thenAnswer((_) async =>
          Future.value(list));
      EstablishmentsViewModel response = await controller.getAll("1l", "2l", userEntity);
      expect(response.list.length == 1, true);
    });

    test("getAll - Teste de falha de conexão", () async {
      UserEntity userEntity = new UserEntity();
      Address address = new Address();
      address.city = "Test";
      address.state = "SP";
      userEntity.addressList.add(address);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      EstablishmentsViewModel response = await controller.getAll("1l", "2l", userEntity);
      expect(response.list.length == 0, true);
    });
  });

}