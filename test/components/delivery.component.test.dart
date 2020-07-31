import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:venda_mais_client_buy/components/connect.component.dart';
import 'package:venda_mais_client_buy/components/delivery.component.dart';
import 'package:venda_mais_client_buy/models/entities/address.entities.dart';
import 'package:venda_mais_client_buy/models/entities/establishment.entities.dart';
import 'package:venda_mais_client_buy/models/entities/fee.delivery.entities.dart';
import 'package:venda_mais_client_buy/repositories/fee.delivery.repository.dart';
import 'package:venda_mais_client_buy/repositories/fee.delivery.repository.interface.dart';
import 'package:venda_mais_client_buy/repositories/maps.repository.dart';
import 'package:venda_mais_client_buy/repositories/maps.repository.intefarce.dart';
import 'package:venda_mais_client_buy/stores/cart.store.dart';


class CartStoreMock extends Mock implements CartStore  {}
class MapsRepositoryMock extends Mock implements MapsRepository  {}
class DeliveryRepositoryMock extends Mock implements DeliveryRepository  {}
class MockConnect extends Mock implements ConnectComponent  {}

void main(){
  CartStore cartStore;
  DeliveryComponent deliveryComponent;
  ConnectComponent connect;
  IMapsRepository mapsRepository;
  IDeliveryRepository repository;
  setUp(() {
    cartStore = CartStoreMock();
    repository = DeliveryRepositoryMock();
    mapsRepository = MapsRepositoryMock();
    connect = MockConnect();
    deliveryComponent = DeliveryComponent.tests(repository, mapsRepository, connect);
  });

  group('Delivery component', ()
  {
    test("calculateFee", () async {
      EstablishmentData establishmentData = new EstablishmentData();
      establishmentData.id = "1l";
      establishmentData.latitude = "15151";
      establishmentData.longitude = "4424";
      Address address = new Address();
      address.latitude = "556565";
      address.longitude = "885858";

      when(cartStore.establishment).thenAnswer((_) => establishmentData);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(mapsRepository.getMapDistance(any, any)).thenAnswer((_) async =>
          Future.value(10));

      List<FeeDelivery> fees = [];
      FeeDelivery feeDelivery = new FeeDelivery();
      feeDelivery.min = 0;
      feeDelivery.max = 100;
      feeDelivery.value = 5;
      fees.add(feeDelivery);
      when(repository.getAll(any)).thenAnswer((_) async =>
          Future.value(fees));

      double response = await deliveryComponent.calculateFee(address, cartStore);
      expect(response, 5);
    });

    test("calculateFee - not found fees", () async {
      EstablishmentData establishmentData = new EstablishmentData();
      establishmentData.id = "1l";
      establishmentData.latitude = "15151";
      establishmentData.longitude = "4424";
      Address address = new Address();
      address.latitude = "556565";
      address.longitude = "885858";

      when(cartStore.establishment).thenAnswer((_) => establishmentData);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(mapsRepository.getMapDistance(any, any)).thenAnswer((_) async =>
          Future.value(10));

      List<FeeDelivery> fees = [];
      when(repository.getAll(any)).thenAnswer((_) async =>
          Future.value(fees));

      double response = await deliveryComponent.calculateFee(address, cartStore);
      expect(response, null);
    });

    test("calculateFee - not found distance", () async {
      EstablishmentData establishmentData = new EstablishmentData();
      establishmentData.id = "1l";
      establishmentData.latitude = "15151";
      establishmentData.longitude = "4424";
      Address address = new Address();
      address.latitude = "556565";
      address.longitude = "885858";

      when(cartStore.establishment).thenAnswer((_) => establishmentData);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(mapsRepository.getMapDistance(any, any)).thenAnswer((_) async =>
          Future.value(null));

      double response = await deliveryComponent.calculateFee(address, cartStore);
      expect(response, null);
    });

    test("getCommissionDelivery", () async {
      when(repository.getCommissionDelivery(any)).thenAnswer((_) async =>
          Future.value(5));

      double response = await deliveryComponent.getCommissionDelivery(10);
      expect(response, 5);
    });

    test("Teste de falha de conexão", () async {
      Address address = new Address();
      address.latitude = "556565";
      address.longitude = "885858";
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      double response = await deliveryComponent.calculateFee(address, cartStore);
      expect(null, response);
    });
  });

}