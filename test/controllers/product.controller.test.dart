import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:venda_mais_client_buy/components/connect.component.dart';
import 'package:venda_mais_client_buy/controllers/product.controller.dart';
import 'package:venda_mais_client_buy/models/entities/additional.entities.dart';
import 'package:venda_mais_client_buy/models/entities/menu.entities.dart';
import 'package:venda_mais_client_buy/models/entities/options.entities.dart';
import 'package:venda_mais_client_buy/models/entities/product.entities.dart';
import 'package:venda_mais_client_buy/repositories/product.repository.dart';
import 'package:venda_mais_client_buy/repositories/product.repository.interface.dart';
import 'package:venda_mais_client_buy/view_model/products.view.model.dart';

class ProductRepositoryMock extends Mock implements ProductRepository  {}
class MockConnect extends Mock implements ConnectComponent  {}

void main(){
  ProductController controller;
  ConnectComponent connect;
  IProductRepository repository;
  setUp(() {
    repository = ProductRepositoryMock();
    connect = MockConnect();
    controller = ProductController.tests(repository, connect);
  });

  group('ProductController', ()
  {
    test("getAll", () async {
      List<ProductData> list = [];
      ProductData data = new ProductData();
      list.add(data);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.getAll(any, any, any)).thenAnswer((_) async =>
          Future.value(list));
      ProductsViewModel response = await controller.getAll("1l", new MenuData(), "");
      expect(response.list.length == 1, true);
    });


    test("getAll - Teste de falha de conexão", () async {
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      ProductsViewModel response = await controller.getAll("1l", new MenuData(), "");
      expect(response.list.length == 0, true);
    });

    test("enableProduct", () async {
      ProductData data = new ProductData();
      data.price = 5;
      data.options = true;
      OptionsData optionsData = new OptionsData();
      optionsData.check = true;
      optionsData.price = 10;
      data.optionsList.add(optionsData);

      bool response = controller.enableProduct(data);
      expect(response, true);
    });

    test("enableProduct - false", () async {
      ProductData data = new ProductData();
      data.price = 5;
      data.options = true;
      OptionsData optionsData = new OptionsData();
      optionsData.check = false;
      optionsData.price = 10;
      data.optionsList.add(optionsData);

      bool response = controller.enableProduct(data);
      expect(response, false);
    });

    test("enableProduct - not options", () async {
      ProductData data = new ProductData();
      data.price = 5;
      data.options = false;

      bool response = controller.enableProduct(data);
      expect(response, true);
    });

    test("recalculateValue - option", () async {
      ProductData data = new ProductData();
      data.price = 5;
      data.options = true;
      OptionsData optionsData = new OptionsData();
      optionsData.check = true;
      optionsData.price = 10;
      data.optionsList.add(optionsData);

      double response = controller.recalculateValue(data);
      expect(response, 10);
    });

    test("recalculateValue - additional", () async {
      ProductData data = new ProductData();
      data.options = false;
      data.price = 20;
      Additional additional = new Additional();
      additional.check = true;
      additional.price = 5;
      data.additionalList.add(additional);
      double response = controller.recalculateValue(data);
      expect(response, 25);
    });
  });

}