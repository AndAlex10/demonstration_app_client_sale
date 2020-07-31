import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:venda_mais_client_buy/components/connect.component.dart';
import 'package:venda_mais_client_buy/controllers/menu.controller.dart';
import 'package:venda_mais_client_buy/models/entities/menu.entities.dart';
import 'package:venda_mais_client_buy/repositories/menu.repository.dart';
import 'package:venda_mais_client_buy/repositories/menu.repository.interface.dart';
import 'package:venda_mais_client_buy/view_model/menu.view.model.dart';

class MenuRepositoryMock extends Mock implements MenuRepository  {}
class MockConnect extends Mock implements ConnectComponent  {}

void main(){
  MenuController controller;
  ConnectComponent connect;
  IMenuRepository repository;
  setUp(() {
    repository = MenuRepositoryMock();
    connect = MockConnect();
    controller = MenuController.tests(repository, connect);
  });

  group('MenuController', ()
  {
    test("getAll", () async {
      List<MenuData> list = [];
      MenuData data = new MenuData();
      list.add(data);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.getAll(any)).thenAnswer((_) async =>
          Future.value(list));
      MenuViewModel response = await controller.getAll("1l");
      expect(response.list.length == 1, true);
    });


    test("Teste de falha de conexão", () async {
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      MenuViewModel response = await controller.getAll("1l");
      expect(response.list.length == 0, true);
    });
  });

}