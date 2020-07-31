
import 'package:flutter_cielo/flutter_cielo.dart';
import 'package:venda_mais_client_buy/constants/erros.messages.dart';
import 'package:venda_mais_client_buy/models/entities/cielo.entities.dart';
import 'package:venda_mais_client_buy/models/entities/payment.card.entities.dart';
import 'package:venda_mais_client_buy/models/response/cielo.response.dart';
import 'package:venda_mais_client_buy/models/response/order.response.dart';
import 'package:venda_mais_client_buy/repositories/cielo.repository.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';

import 'package:venda_mais_client_buy/models/response/validate.response.dart';

class CieloComponent {

  CieloEcommerce cielo;
  CieloRepository repository;
  CieloData cieloData;
  Client client;

  CieloComponent(){
    repository = new CieloRepository();
    client = Client();
  }

  CieloComponent.tests(this.repository);

  Future<Null> _getSecretsKey(bool homologation) async{
    cieloData = await repository.get();
    cielo = CieloEcommerce(
        environment: homologation ? Environment.SANDBOX : Environment.PRODUCTION, // ambiente de desenvolvimento
        merchant: Merchant(
          merchantId: cieloData.merchantId,
          merchantKey: cieloData.merchantKey,
        ));
  }

  Future<OrderResponse> saleCard(String orderId, String customerName, String token, String securityCode,
      String brand, double amount, bool homologation) async{

    OrderResponse orderResponse = new OrderResponse();
    await _getSecretsKey(homologation);

    String value = amount.toString().replaceAll(".", "");
    Sale sale = Sale(
        merchantOrderId: orderId,
        customer: Customer(
            name: customerName
        ),
        payment: Payment(
            type: TypePayment.creditCard,
            amount: int.parse(value),
            installments: 1,
            softDescriptor: "Vendas Cielo",
            creditCard: CreditCard.token(
              cardToken: token,
              securityCode: securityCode,
              brand: brand,
            )
        )
    );

    try{
      var response = await cielo.createSale(sale);
      CieloResponse cieloResponse = new CieloResponse(response.payment.returnCode);
      orderResponse.success = cieloResponse.success;
      orderResponse.message = cieloResponse.message;
      orderResponse.paymentId = response.payment.paymentId;
      orderResponse.authorizationCode = response.payment.authorizationCode;
      return orderResponse;
    } on CieloException catch(e){
      print(e.message);
      print(e.errors[0].message);
      print(e.errors[0].code);
      orderResponse.message = ErroMessages.SALE_CARD;
      return orderResponse;
    }
  }

  Future<String> createToken(PaymentCard paymentCard, bool homologation) async {
    await _getSecretsKey(homologation);
    CreditCard cart = CreditCard(
      customerName: paymentCard.customerName,
      cardNumber: paymentCard.cardNumber,
      holder: paymentCard.customerName,
      expirationDate: paymentCard.expirationDate,
      brand: paymentCard.brand,
    );
    try {
      var response = await cielo.tokenizeCard(cart);
      print(response.cardToken);
      return response.cardToken;
    } on CieloException catch (e) {
      print(e.message);
      print(e.errors[0].message);
      print(e.errors[0].code);
      return null;
    } catch (e){
      return null;
    }
  }

  Future<ValidateResponse> cancelSale(String paymentId, String amount, bool homologation) async{
    await _getSecretsKey(homologation);
    ValidateResponse validate = new ValidateResponse();
    Map data;
    String url = "https://apisandbox.cieloecommerce.cielo.com.br/1/sales/$paymentId/void?amount=$amount";
    Map<String, String> header = {"Content-Type": "application/json",
      "MerchantId": cieloData.merchantId,
      "MerchantKey": cieloData.merchantKey};
    try {
      final response = await client.put(url, headers: header);
      String returnText = response.body;
      data = json.decode(returnText);

      if (data["ReturnCode"] == "0") {
        validate.success = true;
      } else {
        validate.message = data["ReturnMessage"];
      }
    } catch (e){
      validate.message = "Erro no cancelamento.";
    }

    return validate;
  }

}