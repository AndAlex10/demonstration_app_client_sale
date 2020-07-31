import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:venda_mais_client_buy/components/connect.component.dart';
import 'package:venda_mais_client_buy/components/maps.component.dart';
import 'package:venda_mais_client_buy/models/entities/address.entities.dart';
import 'package:venda_mais_client_buy/models/entities/establishment.entities.dart';
import 'package:venda_mais_client_buy/models/response/validate.response.dart';
import 'package:venda_mais_client_buy/repositories/maps.repository.dart';
import 'package:venda_mais_client_buy/repositories/maps.repository.intefarce.dart';

class MapsRepositoryMock extends Mock implements MapsRepository  {}
class MockConnect extends Mock implements ConnectComponent  {}

void main(){
  MapsComponent mapsComponent;
  ConnectComponent connect;
  IMapsRepository repository;

  setUp(() {
    repository = MapsRepositoryMock();
    connect = MockConnect();
    mapsComponent = MapsComponent.tests(repository, connect);
  });

  group('Api Maps tests', ()
  {
    test("Teste para trazer key do google maps", () async {
      String key = "1A";

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.getKeyMap()).thenAnswer((_) async =>
          Future.value(key));
      ValidateResponse response = await mapsComponent.getKeyMap();
      expect(response.success, true);
    });

    test("Teste de falha de conexão", () async {
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      ValidateResponse response = await mapsComponent.getKeyMap();
      expect(false, response.success);
    });
  });

  group('Api Maps tests - calcule distance', ()
  {
    test("Teste calcular distancia", () async {
      EstablishmentData establishmentData = new EstablishmentData();
      establishmentData.latitude = "15151";
      establishmentData.longitude = "4424";
      Address address = new Address();
      address.latitude = "556565";
      address.longitude = "885858";

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(repository.getMapDistance(any, any)).thenAnswer((_) async =>
          Future.value(10));
      int response = await mapsComponent.getMapDistance(establishmentData, address);
      expect(response, 10);
    });

    test("Teste de falha de conexão", () async {
      EstablishmentData establishmentData = new EstablishmentData();
      establishmentData.latitude = "15151";
      establishmentData.longitude = "4424";
      Address address = new Address();
      address.latitude = "556565";
      address.longitude = "885858";
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      int response = await mapsComponent.getMapDistance(establishmentData, address);
      expect(null, response);
    });
  });

}