
import 'package:venda_mais_client_buy/constants/erros.messages.dart';

class OrderResponse {
  bool success = false;
  String message;
  String paymentId;
  String authorizationCode;

  void failConnect(){
    success = false;
    message = ErroMessages.CONNECT_INTERNET;
  }
}
