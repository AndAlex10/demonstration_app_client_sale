import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:venda_mais_client_buy/components/connect.component.dart';
import 'package:venda_mais_client_buy/controllers/category.controller.dart';
import 'package:venda_mais_client_buy/controllers/menu.controller.dart';
import 'package:venda_mais_client_buy/models/entities/category.entities.dart';
import 'package:venda_mais_client_buy/models/entities/menu.entities.dart';
import 'package:venda_mais_client_buy/repositories/category.repository.dart';
import 'package:venda_mais_client_buy/repositories/category.repository.interface.dart';
import 'package:venda_mais_client_buy/repositories/menu.repository.dart';
import 'package:venda_mais_client_buy/repositories/menu.repository.interface.dart';
import 'package:venda_mais_client_buy/view_model/menu.view.model.dart';

class CategoryRepositoryMock extends Mock implements CategoryRepository  {}
class MockConnect extends Mock implements ConnectComponent  {}

void main(){
  CategoryController controller;
  ConnectComponent connect;
  ICategoryRepository repository;
  setUp(() {
    repository = CategoryRepositoryMock();
    connect = MockConnect();
    controller = CategoryController.tests(repository, connect);
  });

  group('MenuController', ()
  {
    test("getAll", () async {
      List<CategoryData> list = [];
      CategoryData data = new CategoryData();
      list.add(data);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.getAll(any)).thenAnswer((_) async =>
          Future.value(list));
      List<CategoryData> response = await controller.getAll("1l");
      expect(response.length == 1, true);
    });

    test("Teste de falha de conexão", () async {
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      List<CategoryData> response = await controller.getAll("1l");
      expect(response.length == 0, true);
    });
  });

}