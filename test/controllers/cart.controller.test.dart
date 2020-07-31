import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:venda_mais_client_buy/components/cielo.component.dart';
import 'package:venda_mais_client_buy/components/connect.component.dart';
import 'package:venda_mais_client_buy/components/delivery.component.dart';
import 'package:venda_mais_client_buy/components/rabbitmq.component.dart';
import 'package:venda_mais_client_buy/constants/erros.messages.dart';
import 'package:venda_mais_client_buy/controllers/cart.controller.dart';
import 'package:venda_mais_client_buy/models/entities/address.entities.dart';
import 'package:venda_mais_client_buy/models/entities/cart.entities.dart';
import 'package:venda_mais_client_buy/models/entities/coupon.entities.dart';
import 'package:venda_mais_client_buy/models/entities/establishment.entities.dart';
import 'package:venda_mais_client_buy/models/entities/payment.order.entities.dart';
import 'package:venda_mais_client_buy/models/entities/product.entities.dart';
import 'package:venda_mais_client_buy/models/entities/user.entities.dart';
import 'package:venda_mais_client_buy/models/response/order.response.dart';
import 'package:venda_mais_client_buy/repositories/establishment.repository.dart';
import 'package:venda_mais_client_buy/repositories/establishment.repository.interface.dart';
import 'package:venda_mais_client_buy/repositories/notification.repository.dart';
import 'package:venda_mais_client_buy/repositories/notification.repository.interface.dart';
import 'package:venda_mais_client_buy/repositories/order.repository.dart';
import 'package:venda_mais_client_buy/repositories/order.repository.interface.dart';
import 'package:venda_mais_client_buy/models/response/validate.response.dart';
import 'package:venda_mais_client_buy/stores/cart.store.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';

class EstablishmentRepositoryMock extends Mock implements EstablishmentRepository {}
class OrderRepositoryMock extends Mock implements OrderRepository {}
class NotificationRepositoryMock extends Mock implements NotificationRepository {}
class DeliveryComponentMock extends Mock implements DeliveryComponent {}
class CieloComponentMock extends Mock implements CieloComponent {}
class RabbitMQComponentMock extends Mock implements RabbitMQComponent {}
class CartStoreMock extends Mock implements CartStore {}
class UserStoreMock extends Mock implements UserStore {}
class MockConnect extends Mock implements ConnectComponent  {}

void main(){
  CartController controller;
  IEstablishmentRepository establishmentRepository;
  IOrderRepository orderRepository;
  INotificationRepository notificationRepository;
  DeliveryComponent deliveryComponent;
  CieloComponent cieloComponent;
  ConnectComponent connect;
  RabbitMQComponent rabbitMQComponent;
  UserStore userStore;
  CartStore cartStore;
  setUp(() {
    establishmentRepository = EstablishmentRepositoryMock();
    orderRepository = OrderRepositoryMock();
    notificationRepository = NotificationRepositoryMock();
    deliveryComponent = DeliveryComponentMock();
    cieloComponent = CieloComponentMock();
    rabbitMQComponent = RabbitMQComponentMock();
    connect = MockConnect();
    userStore = UserStoreMock();
    cartStore = CartStoreMock();
    controller = CartController.tests(establishmentRepository, orderRepository, notificationRepository, deliveryComponent, cieloComponent, connect, rabbitMQComponent);
  });

  group('CartController - add', ()
  {
    test("add", () async {
      ProductData product = new ProductData();
      product.id = "10l";
     EstablishmentData establishmentData = new EstablishmentData();
     establishmentData.id = "1l";
     when(cartStore.establishment).thenAnswer((_) =>establishmentData );
     when(cartStore.quantity).thenAnswer((_) =>2 );
     when(cartStore.amountProduct).thenAnswer((_) =>10 );
     when(cartStore.uniqueProducts).thenAnswer((_) =>[] );
     when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(establishmentRepository.getId(any)).thenAnswer((_) async =>
          Future.value(establishmentData));
     ValidateResponse response = await controller.add(cartStore, "1l", "10l", product, "");
      expect(response.success, true);
    });

    test("add - with items different establishment", () async {
      CartProduct cartProduct = new CartProduct();
      List<CartProduct> uniqueProducts = [];
      uniqueProducts.add(cartProduct);
      ProductData product = new ProductData();
      product.id = "10l";
      EstablishmentData establishmentData = new EstablishmentData();
      establishmentData.id = "1l";
      when(cartStore.establishment).thenAnswer((_) =>establishmentData );
      when(cartStore.quantity).thenAnswer((_) =>2 );
      when(cartStore.amountProduct).thenAnswer((_) =>10 );
      when(cartStore.uniqueProducts).thenAnswer((_) => uniqueProducts );
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(establishmentRepository.getId(any)).thenAnswer((_) async =>
          Future.value(establishmentData));
      ValidateResponse response = await controller.add(cartStore, "10l", "10l", product, "");
      expect(response.success, true);
    });

    test("add - with items different establishment", () async {
      CartProduct cartProduct = new CartProduct();
      List<CartProduct> uniqueProducts = [];
      uniqueProducts.add(cartProduct);
      ProductData product = new ProductData();
      product.id = "10l";
      EstablishmentData establishmentData = new EstablishmentData();
      establishmentData.id = "1l";
      when(cartStore.establishment).thenAnswer((_) =>establishmentData );
      when(cartStore.quantity).thenAnswer((_) =>2 );
      when(cartStore.amountProduct).thenAnswer((_) =>10 );
      when(cartStore.uniqueProducts).thenAnswer((_) => uniqueProducts );
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      ValidateResponse response = await controller.add(cartStore, "1l", "10l", product, "");
      expect(response.success, true);
    });

    test("Teste de falha de conexão", () async {
      ProductData product = new ProductData();
      product.id = "10l";
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));

      ValidateResponse response = await controller.add(cartStore, "1l", "10l", product, "");
      expect(response.success, false);
    });
  });


  group('CartController - finish order', ()
  {
    test("finishOrder - not items", () async {

      EstablishmentData establishmentData = new EstablishmentData();
      establishmentData.id = "1l";
      when(cartStore.establishment).thenAnswer((_) =>establishmentData );
      when(cartStore.quantity).thenAnswer((_) =>2 );
      when(cartStore.amountProduct).thenAnswer((_) =>10 );
      when(cartStore.uniqueProducts).thenAnswer((_) =>[] );
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      OrderResponse response = await controller.finishOrder(cartStore, userStore);
      expect(response.success, false);
      expect(response.message, ErroMessages.NOT_FOUND_CART);
    });

    test("finishOrder with items ", () async {
      CartProduct cartProduct = new CartProduct();
      cartProduct.productData = new ProductData();
      cartProduct.productData.options = false;
      cartProduct.amount = 10.00;
      List<CartProduct> uniqueProducts = [];
      uniqueProducts.add(cartProduct);
      EstablishmentData establishmentData = new EstablishmentData();
      establishmentData.id = "1l";

      UserEntity userEntity = new UserEntity();
      userEntity.id = "1l";
      userEntity.phone = "54545454";
      userEntity.addressList = [];
      Address address = new Address();
      address.defaultAddress = true;
      userEntity.addressList.add(address);
      PaymentOrder paymentOrder = new PaymentOrder();
      paymentOrder.inDelivery = false;
      when(userStore.user).thenAnswer((_) => userEntity);
      when(userStore.connectionRabbitMQ).thenAnswer((_) => null);
      when(cartStore.establishment).thenAnswer((_) =>establishmentData );
      when(cartStore.shipPrice).thenAnswer((_) =>5 );
      when(cartStore.quantity).thenAnswer((_) =>2 );
      when(cartStore.amountProduct).thenAnswer((_) =>10 );
      when(cartStore.distance).thenAnswer((_) =>5 );
      when(cartStore.change).thenAnswer((_) =>0 );
      when(cartStore.payment).thenAnswer((_) =>paymentOrder );
      when(cartStore.uniqueProducts).thenAnswer((_) =>uniqueProducts );
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(establishmentRepository.updateSequence(any, any)).thenAnswer((_) async =>
          Future.value(null));

      OrderResponse orderResponse = new OrderResponse();
      orderResponse.success = true;
      when(cieloComponent.saleCard(any, any, any, any, any, any, any)).thenAnswer((_) async =>
          Future.value(orderResponse));

      when(orderRepository.create(any)).thenAnswer((_) async =>
          Future.value("10l"));

      when(notificationRepository.create(any, any)).thenAnswer((_) async =>
          Future.value(null));

      when(rabbitMQComponent.sendMessage(any, any, any)).thenAnswer((_) async =>
          Future.value(null));
      OrderResponse response = await controller.finishOrder(cartStore, userStore);
      expect(response.success, true);
    });

    test("finishOrder with items - fail card sale ", () async {
      CartProduct cartProduct = new CartProduct();
      cartProduct.productData = new ProductData();
      cartProduct.productData.options = false;
      cartProduct.amount = 10.00;
      List<CartProduct> uniqueProducts = [];
      uniqueProducts.add(cartProduct);
      EstablishmentData establishmentData = new EstablishmentData();
      establishmentData.id = "1l";

      UserEntity userEntity = new UserEntity();
      userEntity.id = "1l";
      userEntity.phone = "54545454";
      userEntity.addressList = [];
      Address address = new Address();
      address.defaultAddress = true;
      userEntity.addressList.add(address);
      PaymentOrder paymentOrder = new PaymentOrder();
      paymentOrder.inDelivery = false;
      when(userStore.user).thenAnswer((_) => userEntity);
      when(userStore.connectionRabbitMQ).thenAnswer((_) => null);
      when(cartStore.establishment).thenAnswer((_) =>establishmentData );
      when(cartStore.shipPrice).thenAnswer((_) =>5 );
      when(cartStore.quantity).thenAnswer((_) =>2 );
      when(cartStore.amountProduct).thenAnswer((_) =>10 );
      when(cartStore.distance).thenAnswer((_) =>5 );
      when(cartStore.change).thenAnswer((_) =>0 );
      when(cartStore.payment).thenAnswer((_) =>paymentOrder );
      when(cartStore.uniqueProducts).thenAnswer((_) =>uniqueProducts );
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(establishmentRepository.updateSequence(any, any)).thenAnswer((_) async =>
          Future.value(null));

      OrderResponse orderResponse = new OrderResponse();
      orderResponse.success = false;
      when(cieloComponent.saleCard(any, any, any, any, any, any, any)).thenAnswer((_) async =>
          Future.value(orderResponse));

      OrderResponse response = await controller.finishOrder(cartStore, userStore);
      expect(response.success, false);
    });

    test("finishOrder with items - payment after delivery ", () async {
      CartProduct cartProduct = new CartProduct();
      cartProduct.productData = new ProductData();
      cartProduct.productData.options = false;
      cartProduct.amount = 10.00;
      List<CartProduct> uniqueProducts = [];
      uniqueProducts.add(cartProduct);
      EstablishmentData establishmentData = new EstablishmentData();
      establishmentData.id = "1l";

      UserEntity userEntity = new UserEntity();
      userEntity.id = "1l";
      userEntity.phone = "54545454";
      userEntity.addressList = [];
      Address address = new Address();
      address.defaultAddress = true;
      userEntity.addressList.add(address);
      PaymentOrder paymentOrder = new PaymentOrder();
      paymentOrder.inDelivery = true;
      when(userStore.user).thenAnswer((_) => userEntity);
      when(userStore.connectionRabbitMQ).thenAnswer((_) => null);
      when(cartStore.establishment).thenAnswer((_) =>establishmentData );
      when(cartStore.shipPrice).thenAnswer((_) =>5 );
      when(cartStore.quantity).thenAnswer((_) =>2 );
      when(cartStore.amountProduct).thenAnswer((_) =>10 );
      when(cartStore.distance).thenAnswer((_) =>5 );
      when(cartStore.change).thenAnswer((_) =>0 );
      when(cartStore.payment).thenAnswer((_) =>paymentOrder );
      when(cartStore.uniqueProducts).thenAnswer((_) =>uniqueProducts );
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));

      when(establishmentRepository.updateSequence(any, any)).thenAnswer((_) async =>
          Future.value(null));

      when(orderRepository.create(any)).thenAnswer((_) async =>
          Future.value("10l"));

      when(notificationRepository.create(any, any)).thenAnswer((_) async =>
          Future.value(null));

      when(rabbitMQComponent.sendMessage(any, any, any)).thenAnswer((_) async =>
          Future.value(null));
      OrderResponse response = await controller.finishOrder(cartStore, userStore);
      expect(response.success, true);
    });

    test("Teste de falha de conexão", () async {
      CartProduct cartProduct = new CartProduct();
      List<CartProduct> uniqueProducts = [];
      uniqueProducts.add(cartProduct);
      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));
      when(cartStore.uniqueProducts).thenAnswer((_) =>uniqueProducts );
      OrderResponse response = await controller.finishOrder(cartStore, userStore);
      expect(response.success, false);
    });
  });

  group('CartController - others', ()
  {
    test("getProductsPrice", () async {
      List<CartProduct> uniqueProducts = [];
      CartProduct cartProduct = new CartProduct();
      cartProduct.productData = new ProductData();
      cartProduct.productData.options = false;
      cartProduct.amount = 10.00;
      uniqueProducts.add(cartProduct);

      CartProduct cartProduct2 = new CartProduct();
      cartProduct2.productData = new ProductData();
      cartProduct2.productData.options = false;
      cartProduct2.amount = 15.00;
      uniqueProducts.add(cartProduct2);

      double response = controller.getProductsPrice(uniqueProducts);
      expect(response, 25);
    });

    test("getDiscount", () {
      Coupon coupon = new Coupon();
      coupon.value = 10;
      double response = controller.getDiscount(coupon);
      expect(response, 10);
    });

    test("getDiscount - not found", () {
      double response = controller.getDiscount(null);
      expect(response, 0);
    });

    test("getAmount", () {
      List<CartProduct> uniqueProducts = [];
      CartProduct cartProduct = new CartProduct();
      cartProduct.productData = new ProductData();
      cartProduct.productData.options = false;
      cartProduct.amount = 10.00;
      uniqueProducts.add(cartProduct);

      CartProduct cartProduct2 = new CartProduct();
      cartProduct2.productData = new ProductData();
      cartProduct2.productData.options = false;
      cartProduct2.amount = 15.00;
      uniqueProducts.add(cartProduct2);

      Coupon coupon = new Coupon();
      coupon.value = 10;

      when(cartStore.uniqueProducts).thenAnswer((_) =>uniqueProducts );
      when(cartStore.coupon).thenAnswer((_) =>coupon );
      when(cartStore.shipPrice).thenAnswer((_) => 3 );

      double response = controller.getAmount(cartStore);
      expect(response, 18);
    });

    test("getShipPrice", () {
      when(cartStore.shipPrice).thenAnswer((_) => 3 );
      double response = controller.getShipPrice(cartStore);
      expect(response, 3);
    });

    test("getShipPrice - null", () {
      when(cartStore.shipPrice).thenAnswer((_) => null );
      double response = controller.getShipPrice(cartStore);
      expect(response, 0);
    });

    test("getShipPriceText", () {
      double shipPrice = 3;
      String response = controller.getShipPriceText(shipPrice);
      expect(response, "R\$${shipPrice.toStringAsFixed(2)}");
    });

    test("getShipPriceText - free", () {
      double shipPrice = 0;
      String response = controller.getShipPriceText(shipPrice);
      expect(response, "Grátis");
    });

    test("getShipPriceText - not found", () {
      String response = controller.getShipPriceText(null);
      expect(response, "Indisponível");
    });

    test("validateFinishOrder ", () {
      EstablishmentData establishmentData = new EstablishmentData();
      establishmentData.open = true;
      when(userStore.isNotAddress()).thenAnswer((_) =>false );
      when(cartStore.payment).thenAnswer((_) =>new PaymentOrder() );
      when(cartStore.establishment).thenAnswer((_) =>establishmentData );
      when(cartStore.shipPrice).thenAnswer((_) =>3 );
      bool response = controller.validateFinishOrder(cartStore, userStore);
      expect(response, true);
    });

    test("validateFinishOrder - not address", () {
      EstablishmentData establishmentData = new EstablishmentData();
      establishmentData.open = true;
      when(userStore.isNotAddress()).thenAnswer((_) =>true );
      when(cartStore.payment).thenAnswer((_) =>new PaymentOrder() );
      when(cartStore.establishment).thenAnswer((_) =>establishmentData );
      when(cartStore.shipPrice).thenAnswer((_) =>3 );
      bool response = controller.validateFinishOrder(cartStore, userStore);
      expect(response, false);
    });

    test("validateFinishOrder - closed establishment", () {
      EstablishmentData establishmentData = new EstablishmentData();
      establishmentData.open = false;
      when(userStore.isNotAddress()).thenAnswer((_) =>false );
      when(cartStore.payment).thenAnswer((_) =>new PaymentOrder() );
      when(cartStore.establishment).thenAnswer((_) =>establishmentData );
      when(cartStore.shipPrice).thenAnswer((_) =>3 );
      bool response = controller.validateFinishOrder(cartStore, userStore);
      expect(response, false);
    });

    test("validateFinishOrder - not payment", () {
      EstablishmentData establishmentData = new EstablishmentData();
      establishmentData.open = true;
      when(userStore.isNotAddress()).thenAnswer((_) =>false );
      when(cartStore.payment).thenAnswer((_) =>null );
      when(cartStore.establishment).thenAnswer((_) =>establishmentData );
      when(cartStore.shipPrice).thenAnswer((_) =>3 );
      bool response = controller.validateFinishOrder(cartStore, userStore);
      expect(response, false);
    });

    test("validateFinishOrder - not shipPrice", () {
      EstablishmentData establishmentData = new EstablishmentData();
      establishmentData.open = true;
      when(userStore.isNotAddress()).thenAnswer((_) =>false );
      when(cartStore.payment).thenAnswer((_) =>new PaymentOrder() );
      when(cartStore.establishment).thenAnswer((_) =>establishmentData );
      when(cartStore.shipPrice).thenAnswer((_) =>null );
      bool response = controller.validateFinishOrder(cartStore, userStore);
      expect(response, false);
    });

    test("calculateShipPrice", () async {
      UserEntity userEntity = new UserEntity();
      userEntity.id = "1l";
      userEntity.phone = "54545454";
      userEntity.addressList = [];
      Address address = new Address();
      address.defaultAddress = true;
      userEntity.addressList.add(address);
      List<CartProduct> uniqueProducts = [];
      CartProduct cartProduct = new CartProduct();
      cartProduct.productData = new ProductData();
      cartProduct.productData.options = false;
      cartProduct.amount = 10.00;
      uniqueProducts.add(cartProduct);

      CartProduct cartProduct2 = new CartProduct();
      cartProduct2.productData = new ProductData();
      cartProduct2.productData.options = false;
      cartProduct2.amount = 15.00;
      uniqueProducts.add(cartProduct2);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(true));
      when(cartStore.uniqueProducts).thenAnswer((_) =>uniqueProducts );

      when(deliveryComponent.calculateFee(any, any)).thenAnswer((_) async =>
          Future.value(3));

      double response = await controller.calculateShipPrice(cartStore, userEntity);
      expect(response, 3);
    });

    test("calculateShipPrice - fail connect net", () async {
      UserEntity userEntity = new UserEntity();
      userEntity.id = "1l";
      userEntity.phone = "54545454";
      userEntity.addressList = [];
      Address address = new Address();
      address.defaultAddress = true;
      userEntity.addressList.add(address);
      List<CartProduct> uniqueProducts = [];
      CartProduct cartProduct = new CartProduct();
      cartProduct.productData = new ProductData();
      cartProduct.productData.options = false;
      cartProduct.amount = 10.00;
      uniqueProducts.add(cartProduct);

      CartProduct cartProduct2 = new CartProduct();
      cartProduct2.productData = new ProductData();
      cartProduct2.productData.options = false;
      cartProduct2.amount = 15.00;
      uniqueProducts.add(cartProduct2);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));
      when(cartStore.uniqueProducts).thenAnswer((_) =>uniqueProducts );

      when(deliveryComponent.calculateFee(any, any)).thenAnswer((_) async =>
          Future.value(3));

      double response = await controller.calculateShipPrice(cartStore, userEntity);
      expect(response, null);
    });

    test("calculateShipPrice - not found address", () async {
      UserEntity userEntity = new UserEntity();
      userEntity.id = "1l";
      userEntity.phone = "54545454";
      userEntity.addressList = [];
      List<CartProduct> uniqueProducts = [];
      CartProduct cartProduct = new CartProduct();
      cartProduct.productData = new ProductData();
      cartProduct.productData.options = false;
      cartProduct.amount = 10.00;
      uniqueProducts.add(cartProduct);

      CartProduct cartProduct2 = new CartProduct();
      cartProduct2.productData = new ProductData();
      cartProduct2.productData.options = false;
      cartProduct2.amount = 15.00;
      uniqueProducts.add(cartProduct2);

      when(connect.checkConnect()).thenAnswer((_) async =>
          Future.value(false));
      when(cartStore.uniqueProducts).thenAnswer((_) =>uniqueProducts );

      when(deliveryComponent.calculateFee(any, any)).thenAnswer((_) async =>
          Future.value(3));

      double response = await controller.calculateShipPrice(cartStore, userEntity);
      expect(response, null);
    });
  });


}