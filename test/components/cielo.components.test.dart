import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:http/testing.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:venda_mais_client_buy/components/cielo.component.dart';
import 'package:venda_mais_client_buy/models/entities/cielo.entities.dart';
import 'package:venda_mais_client_buy/models/response/order.response.dart';
import 'package:venda_mais_client_buy/models/response/validate.response.dart';
import 'package:venda_mais_client_buy/repositories/cielo.repository.dart';
import 'package:venda_mais_client_buy/repositories/cielo.repository.interface.dart';

import 'dart:convert';

class CieloRepositoryMock extends Mock implements CieloRepository  {}

void main(){
  CieloComponent cieloComponent;
  ICieloRepository repository;
  setUp(() {
    repository = CieloRepositoryMock();
    cieloComponent = CieloComponent.tests(repository);
  });

  group('Cielo tests', ()
  {
    test("Testing the cancelSale", () async{
      CieloData cieloData = new CieloData();
      when(repository.get()).thenAnswer((_) async =>
          Future.value(cieloData));
      
      cieloComponent.client = MockClient((request) async{
        final mapJson = {'ReturnCode':"0"};
        return Response(json.encode(mapJson),200);
      });

      ValidateResponse validateResponse = await cieloComponent.cancelSale("paymentId", "500", true);
      expect(validateResponse != null, true);
      expect(validateResponse.success, true);
    });

    test("Testing the cancelSale - fail", () async{
      CieloData cieloData = new CieloData();
      when(repository.get()).thenAnswer((_) async =>
          Future.value(cieloData));
      cieloComponent.client = MockClient((request) async{
        final mapJson = {'ReturnCode':"2", "ReturnMessage":  "error"};
        return Response(json.encode(mapJson),200);
      });

      ValidateResponse validateResponse = await cieloComponent.cancelSale("paymentId", "500", true);
      expect(validateResponse != null, true);
      expect(validateResponse.success, false);
    });

  });

  group('Cielo tests', ()
  {
    test("Testing the saleCard", () async{
      CieloData cieloData = new CieloData();
      cieloData.merchantId = "647379bd-a0a6-4ab2-9d33-a0b655b7a15d";
      cieloData.merchantKey = "JNNACAXLCOLGDSSMOBRIYMKVDNJKGWQEXNRQBSLM";
      when(repository.get()).thenAnswer((_) async =>
          Future.value(cieloData));

      OrderResponse response = await cieloComponent.saleCard("10", "Name", "120ea2d3-906c-4f2c-bb9e-2a899fd055d9", "123", "Master", 100, true);
      expect(response != null, true);
      expect(response.success, true);
      expect(response.paymentId != null, true);
      expect(response.authorizationCode != null, true);
    });

    test("Testing the saleCard - fail", () async{
      CieloData cieloData = new CieloData();
      when(repository.get()).thenAnswer((_) async =>
          Future.value(cieloData));

      OrderResponse response = await cieloComponent.saleCard("10", "Name", "1234546", "123", "Master", 100, true);
      expect(response != null, true);
      expect(response.success, false);
    });

  });

}