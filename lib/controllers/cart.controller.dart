import 'package:dart_amqp/dart_amqp.dart';
import 'package:venda_mais_client_buy/components/cielo.component.dart';
import 'package:venda_mais_client_buy/components/connect.component.dart';
import 'package:venda_mais_client_buy/components/delivery.component.dart';
import 'package:venda_mais_client_buy/components/rabbitmq.component.dart';
import 'package:venda_mais_client_buy/constants/erros.messages.dart';
import 'package:venda_mais_client_buy/constants/order.actions.execute.constants.dart';
import 'package:venda_mais_client_buy/models/entities/address.entities.dart';
import 'package:venda_mais_client_buy/models/entities/cart.entities.dart';
import 'package:venda_mais_client_buy/models/entities/coupon.entities.dart';
import 'package:venda_mais_client_buy/models/entities/order.entities.dart';
import 'package:venda_mais_client_buy/models/entities/product.entities.dart';
import 'package:venda_mais_client_buy/models/entities/user.entities.dart';
import 'package:venda_mais_client_buy/models/request/order.request.dart';
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

class CartController {
  IEstablishmentRepository establishmentRepository;
  IOrderRepository orderRepository;
  INotificationRepository notificationRepository;
  DeliveryComponent deliveryComponent;
  CieloComponent cieloComponent;
  ConnectComponent connect;
  RabbitMQComponent rabbitMQComponent;

  CartController() {
    establishmentRepository = new EstablishmentRepository();
    orderRepository = new OrderRepository();
    notificationRepository = new NotificationRepository();
    deliveryComponent = new DeliveryComponent();
    cieloComponent = new CieloComponent();
    connect = new ConnectComponent();
    rabbitMQComponent = new RabbitMQComponent();
  }

  CartController.tests(this.establishmentRepository, this.orderRepository, this.notificationRepository, this.deliveryComponent, this.cieloComponent, this.connect, this.rabbitMQComponent);

  Future<ValidateResponse> add(CartStore cartStore, String idEstablishment, String category,
      ProductData product, String obs) async {
    ValidateResponse response = ValidateResponse();

    if(await connect.checkConnect()) {
      CartProduct cartProduct = CartProduct();
      cartProduct.idEstablishment = idEstablishment;
      cartProduct.category = category;
      cartProduct.quantity = cartStore.quantity;
      cartProduct.amount = cartStore.amountProduct;
      cartProduct.pid = product.id;
      cartProduct.productData = product;
      cartProduct.additionalData = product.toAdditionalList();
      cartProduct.obs = obs;

      if (cartStore.uniqueProducts.length == 0) {
        cartStore.setPayment(null);
        cartStore.setCoupon(null);
        cartStore.setEstablishment(
            await establishmentRepository.getId(cartProduct.idEstablishment));
        cartStore.addProduct(cartProduct);

      } else if (cartStore.establishment.id == cartProduct.idEstablishment) {
        cartStore.addProduct(cartProduct);

      } else {
        cartStore.setPayment(null);
        cartStore.setCoupon(null);
        cartStore.clearCart();
        cartStore.addProduct(cartProduct);
        cartStore.setEstablishment(await establishmentRepository.getId(cartProduct.idEstablishment));
      }

      response.success = true;
    } else {
      response.failConnect();
    }

    return response;
  }


  Future<OrderResponse> finishOrder(CartStore cartStore, UserStore userStore) async {
    cartStore.setLoading(true);
    OrderResponse orderResponse = new OrderResponse();
    if (cartStore.uniqueProducts.length == 0) {
      orderResponse.success = false;
      orderResponse.message = ErroMessages.NOT_FOUND_CART;
    } else if(!await connect.checkConnect()) {
      orderResponse.failConnect();
    } else {
      double productsPrice = getProductsPrice(cartStore.uniqueProducts);
      double discount = getDiscount(cartStore.coupon);
      double amount = productsPrice - discount + cartStore.shipPrice;
      double commissionDelivery = await deliveryComponent.getCommissionDelivery(
          cartStore.distance);
      int sequence = 0;
      if (cartStore.establishment.sequence != null) {
        sequence = cartStore.establishment.sequence;
      }

      sequence = sequence + 1;

      await establishmentRepository.updateSequence(
          cartStore.establishment.id, sequence);

      OrderData order = OrderData.setData(
          cartStore.establishment,
          sequence,
          userStore.user,
          cartStore.payment,
          cartStore.uniqueProducts,
          amount,
          productsPrice,
          cartStore.shipPrice,
          cartStore.distance,
          commissionDelivery,
          discount,
          cartStore.change);

      if (cartStore.payment.inDelivery == false) {
        orderResponse = await cieloComponent.saleCard(
            sequence.toString(),
            cartStore.payment.customerName,
            cartStore.payment.token,
            cartStore.payment.securityCode,
            cartStore.payment.brand,
            order.amount,
            true);
        if (!orderResponse.success) {
          cartStore.setLoading(false);
          return orderResponse;
        }
      }

      order.payment.paymentId = orderResponse.paymentId;
      order.id = await orderRepository.create(order);

      await notificationRepository.create(sequence, cartStore.establishment.id);
      await _sendOrderQueue(userStore.connectionRabbitMQ, order);
      cartStore.clearCart();
      cartStore.setCoupon(null);
      orderResponse.success = true;
    }
    cartStore.setLoading(false);
    return orderResponse;
  }

  double getProductsPrice(List<CartProduct> products) {
    double price = 0.0;
    for (CartProduct c in products) {
      if (c.productData != null) price += c.amount;
    }
    return price;
  }

  double getDiscount(Coupon coupon) {
    return coupon != null ? coupon.value : 0.00;
  }

  double getAmount(CartStore cartStore) {
    double price = getProductsPrice(cartStore.uniqueProducts);
    double discount = getDiscount(cartStore.coupon);
    double shipPrice =  cartStore.shipPrice == null ? 0.00 : cartStore.shipPrice;
    return price - discount +  shipPrice;
  }

  double getShipPrice(CartStore cartStore) {
    return  cartStore.shipPrice == null ? 0.00 : cartStore.shipPrice;
  }

  String getShipPriceText(double shipPrice) {
    return  shipPrice == 0.00
        ? "Grátis"
        : shipPrice == null
        ? "Indisponível"
        : "R\$${shipPrice.toStringAsFixed(2)}";
  }

  bool validateFinishOrder(CartStore cartStore, UserStore userStore) {
    if (cartStore.payment != null &&
        (!userStore.isNotAddress()) &&
        cartStore.establishment.open
        && cartStore.shipPrice != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<double> calculateShipPrice(CartStore cartStore, UserEntity user) async {
    if(cartStore.uniqueProducts.length > 0) {
      cartStore.setShipPrice(null);
      if (await connect.checkConnect()) {
        Address address;
        for (Address c in user.addressList) {
          if (c.defaultAddress) address = c;
        }

        if (address != null) {
          return await deliveryComponent.calculateFee(address, cartStore);
        }
      }
    }

    return null;
  }

  Future<Null> _sendOrderQueue(Client connection,OrderData orderData) async{
    OrderRequest orderRequest = new OrderRequest.from(orderData.id, orderData.orderCode.toString(), orderData.idEstablishment, ActionOrder.ORDER_PENDING);
    await rabbitMQComponent.sendMessage(connection, "orders", orderRequest.toMap().toString());
  }

}
