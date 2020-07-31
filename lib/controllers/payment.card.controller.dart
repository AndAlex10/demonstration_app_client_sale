import 'package:enum_to_string/enum_to_string.dart';
import 'package:venda_mais_client_buy/components/cielo.component.dart';
import 'package:venda_mais_client_buy/components/connect.component.dart';
import 'package:venda_mais_client_buy/constants/erros.messages.dart';
import 'package:venda_mais_client_buy/models/entities/payment.card.entities.dart';
import 'package:venda_mais_client_buy/models/entities/payment.order.entities.dart';
import 'package:venda_mais_client_buy/enums/brand.enum.dart';
import 'package:venda_mais_client_buy/repositories/payment.card.repository.dart';
import 'package:venda_mais_client_buy/repositories/payment.card.repository.interface.dart';
import 'package:venda_mais_client_buy/stores/user.store.dart';
import 'package:venda_mais_client_buy/utils/card.number.brand.dart';
import 'package:venda_mais_client_buy/utils/utils.dart';
import 'package:venda_mais_client_buy/models/response/validate.response.dart';

class PaymentCardController{

  IPaymentCardRepository paymentRepository;
  CieloComponent cieloComponent;
  ConnectComponent connect;

  PaymentCardController(){
    paymentRepository = new PaymentCardRepository();
    cieloComponent = new CieloComponent();
    connect = new ConnectComponent();
  }

  PaymentCardController.tests(this.paymentRepository, this.cieloComponent, this.connect);

  Future<ValidateResponse> alter(UserStore userStore, PaymentCard paymentCard) async{
    userStore.setLoading(true);
     ValidateResponse response = new ValidateResponse();
     if(await connect.checkConnect()) {
       paymentRepository.alter(userStore.user, paymentCard);
       response.success = true;
     } else {
       response.failConnect();
     }
    userStore.setLoading(false);
     return response;
  }

  Future<ValidateResponse> remove(UserStore userStore, PaymentCard paymentCard) async{
    userStore.setLoading(true);
    ValidateResponse response = new ValidateResponse();

    if(await connect.checkConnect()) {
      await paymentRepository.remove(userStore.user, paymentCard);
      userStore.user.paymentList =
      await paymentRepository.load(userStore.user.id);
      response.success = true;
    } else {
      response.failConnect();
    }
    userStore.setLoading(false);
    return response;
  }

  Future<ValidateResponse> addCard(UserStore userStore, PaymentCard paymentCard) async{
    ValidateResponse response = new ValidateResponse();
    userStore.setLoading(true);
    if(await connect.checkConnect()) {
      _validateData(paymentCard, response);
      if (response.success) {
        String token = await cieloComponent.createToken(paymentCard, true);
        if (token == null) {
          response.success = false;
          response.message = ErroMessages.NOT_FOUND_COUPON;
        } else {
          paymentCard.cardNumber = "****" + paymentCard.cardNumber.substring(
              paymentCard.cardNumber.length - 4, paymentCard.cardNumber.length);
          paymentCard.token = token;

          paymentCard.securityCode = Utils.encrypt(paymentCard.securityCode);
          paymentCard.order = _orderPayment(userStore.user.paymentList);

          await paymentRepository.add(userStore.user, paymentCard);
          userStore.user.paymentList = await paymentRepository.load(userStore.user.id);
          response.success = true;
        }
      }
    } else {
      response.failConnect();
    }
    userStore.setLoading(false);
    return response;
  }

  int _orderPayment(List<PaymentCard> list){
    int max = 0;
    for (PaymentCard paymentCard in list){
      max = paymentCard.order > max ? paymentCard.order : max;
    }

    return max + 1;
  }

  PaymentOrder setPaymentOrder(PaymentCard paymentCard){
    PaymentOrder paymentOrder = PaymentOrder.fromCard(paymentCard);
    return paymentOrder;
  }


  void _validateData(PaymentCard paymentCard, ValidateResponse response){
    response.success = true;
    _searchBrand(paymentCard);

    if(paymentCard.brand == null){
      response.message = "Bandeira não encontrada ou indisponível.";
      response.success = false;
    } else {
      if (paymentCard.brand.toUpperCase() ==
          EnumToString.parse(BrandType.DINERS)) {
        if (paymentCard.cardNumber.length != 14) {
          response.message = "Informe os 14 números do cartão";
          response.success = false;
        }
      } else if (paymentCard.brand.toUpperCase() ==
          EnumToString.parse(BrandType.AMEX)) {
        if (paymentCard.cardNumber.length != 15) {
          response.message = "Informe os 15 números do cartão";
          response.success = false;
        }
      } else {
        if (paymentCard.cardNumber.length != 16) {
          response.message = "Informe os 16 números do cartão";
          response.success = false;
        }
      }

      if (paymentCard.brand.toUpperCase() ==
          EnumToString.parse(BrandType.AMEX)) {
        if (paymentCard.securityCode.length != 4) {
          response.message = "Informe os 4 dígitos de segurança";
          response.success = false;
        }
      } else {
        if (paymentCard.securityCode.length != 3) {
          response.message = "Informe os 3 dígitos de segurança";
          response.success = false;
        }
      }

      if (paymentCard.expirationDate.length != 7) {
        response.message = "Informe a validade do cartão";
        response.success = false;
      }
    }
  }

  void _searchBrand(PaymentCard paymentCard) {
    paymentCard.brand = CardBrand.getBrand(paymentCard.cardNumber);
    if (paymentCard.brand != null) {
      paymentCard.image = CardBrand.getBrandImage(paymentCard.brand);
    } else {
      paymentCard.image = null;
    }
  }

}